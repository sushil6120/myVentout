import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/login/login_controller.dart';

import '../viewModel/authViewModel.dart';

class OtpScreen extends StatefulWidget {
  Map<String, dynamic>? arguments;
  OtpScreen({super.key, this.arguments});

  @override
  State<StatefulWidget> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  final LoginController loginController = LoginController();
  bool isLoading = false;
  String? mobile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobile = widget.arguments!['mobile'];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded)),
            elevation: 0.0,
            toolbarHeight: height * 0.08,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            // title: Image.asset(
            //   'assets/img/Gossipmark.png',
            //   width: width * 0.7,
            // ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OTP\nVerification',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        height: 1,
                        fontSize: context.deviceWidth * .094,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Verification code sent to your ',
                      style: TextStyle(
                        color: Color(0xFF5B5B5B),
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Roboto',
                        fontSize: context.deviceWidth * .042,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "WhatsApp ",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Roboto',
                            fontSize: context.deviceWidth * .04,
                          ),
                        ),
                        TextSpan(
                          text: 'number : ',
                          style: TextStyle(
                            color: Color(0xFF5B5B5B),
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Roboto',
                            fontSize: context.deviceWidth * .042,
                          ),
                        ),
                        TextSpan(
                          text: mobile,
                          style: TextStyle(
                            color: Color(0xFF5B5B5B),
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Roboto',
                            fontSize: context.deviceWidth * .042,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  Center(
                    child: Pinput(
                      length: 6,
                      showCursor: true,

                      // androidSmsAutofillMethod:
                      //     AndroidSmsAutofillMethod.smsUserConsentApi,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      defaultPinTheme: PinTheme(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: const Color(0xFF3F3F3F),
                            )
                          ],
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: const Color(0xFF3F3F3F),
                          ),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                      onChanged: (value) {
                        if (value.length == 6) {
                          final atuh = Provider.of<AuthViewModel>(context,
                              listen: false);
                          atuh.otpVerifyApis(
                              mobile.toString(), value.toString(), context);
                        }
                      },
                      onCompleted: (value) {
                        setState(() {
                          otpCode = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.06),

                  // SizedBox(height: height * 0.2),
                  // SizedBox(height: height * 0.02),
                ],
              ),
            ),
          ),
          // floatingActionButton: isLoading
          //     ? const Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     : customButton(() async {
          //         // if (otpCode == '123456') {
          //         //   NavigationScreen().navigate();
          //         // } else {
          //         //   if (otpCode != null) {
          //         //     setState(() {
          //         //       isLoading = true;
          //         //     });
          //         //     bool res = await loginController.verifyOtp(
          //         //         widget.mobile, otpCode!, ref);
          //         //     if (!res) {
          //         //       setState(() {
          //         //         isLoading = false;
          //         //       });
          //         //     }
          //         //   } else {
          //         //     Get.snackbar(
          //         //       "Enter 6-Digit code",
          //         //       "Failed",
          //         //       colorText: Colors.white,
          //         //     );
          //         //   }
          //         // }
          //            Navigator.pushNamed(context, RoutesName.bottomNavBarView);
          //       }, width * 0.8, height * 0.05, 'Verify Code', false),

          floatingActionButton: BottomAppBar(
              color: Colors.black,
              elevation: 0,
              height: height * .1,
              child: Consumer<AuthViewModel>(
                builder: (context, value, child) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        value.otpVerifyApis(
                            mobile.toString(), otpCode, context);
                      },
                      child: value.isLoading
                          ? LoadingAnimationWidget.waveDots(
                              color: Colors.black,
                              size: 40,
                            )
                          : Text(
                              'Continue',
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          backgroundColor: buttonColor,
                          minimumSize: Size(width * 0.9, 50)),
                    ),
                  );
                },
              )),
        ),
      ),
    );
  }
}
