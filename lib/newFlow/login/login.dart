import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ventout/Utils/responsive.dart';
import 'package:ventout/newFlow/login/login_controller.dart';
import 'package:ventout/newFlow/viewModel/authViewModel.dart';

import '../../Utils/colors.dart';
import '../../Utils/logintextfieldWidget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = LoginController();

  String countrycodes = "91";
  bool autoValidate = false;
  bool isTrue = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter'),
            ),
            content: Text(
              'Do You Want To Exit The App',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter'),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Container(
                        width: width * 0.25,
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: const Center(
                            child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        exit(0);
                      },
                      child: Container(
                        width: width * 0.25,
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: const Center(
                            child: Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            toolbarHeight: height * 0.06,
            backgroundColor: Colors.transparent,
          ),
          body: Form(
            key: loginController.formKey,
            autovalidateMode: autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Text(
                        'VentOut.',
                        style: TextStyle(
                            height: 1,
                            color: colorLightWhite,
                            fontWeight: FontWeight.w900,
                            fontSize: context.deviceWidth * .1),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: 'Taste therapy with the\n help of',
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: context.deviceWidth * .056,
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: ' Mini Session.',
                            style: GoogleFonts.inter(
                                color: buttonColor,
                                fontSize: context.deviceWidth * .056,
                                fontWeight: FontWeight.w400),
                          )
                        ]))),
                    SizedBox(height: height * 0.03),
                    FormField<String?>(
                      validator: (value) {
                        var valueText =
                            loginController.phoneNumberController.text;
                        if (valueText.isEmpty ||
                            valueText.length < 10 ||
                            !valueText.isNumericOnly) {
                          return 'Please Enter Your Correct Number';
                        }
                        return null;
                      },
                      builder: (state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: LogintextFieldWidget(
                                dialCode: countrycodes == "91"
                                    ? "+$countrycodes"
                                    : "+$countrycodes",
                                onDialPadTap: () {
                                  showCountryPicker(
                                      context: context!,
                                      useSafeArea: true,
                                      countryListTheme: CountryListThemeData(
                                        searchTextStyle:
                                            TextStyle(color: Colors.white),
                                        flagSize: 25,
                                        backgroundColor: Colors.black,

                                        textStyle: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                        bottomSheetHeight: double
                                            .infinity, // Optional. Country list modal height
                                        //Optional. Sets the border radius for the bottomsheet.
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                        //Optional. Styles the search field.
                                        inputDecoration: InputDecoration(
                                          labelText: 'Search',
                                          hintText: 'Start typing to search',
                                          prefixIcon: const Icon(Icons.search),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color(0xFF8C98A8)
                                                  .withOpacity(0.2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      onSelect: (Country country) {
                                        print(
                                            'Select country: ${country.displayName}');

                                        setState(() {
                                          countrycodes =
                                              country.phoneCode.toString();
                                          print(countrycodes);
                                        });
                                      });
                                },
                                color: Colors.white,
                                context: context,
                                controller:
                                    loginController.phoneNumberController,
                                enable: true,
                                forgotPass: false,
                                hintText: '98188 02701',
                                inputType: TextInputType.phone,
                                isPhone: true,
                                label: "",
                                labelText: "",
                                multiline: 1,
                                padding: true,
                                spaced: true,
                                width: 0,
                              ),
                            ),
                            // customTextField(
                            //   context: context,
                            //     controller: loginController.phoneNumberController,
                            //     width: width,
                            //     color: Colors.white,
                            //     isPhone: true,
                            //     inputType: TextInputType.phone,
                            //     spaced: true,
                            //     hintText: '98188 02701'),
                            if (state.hasError)
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width * 0.2, bottom: 10),
                                child: Text(
                                  state.errorText!,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Inter'),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: height * 0.064),
                    Consumer<AuthViewModel>(
                      builder: (context, value, child) {
                        return Center(
                          child: ElevatedButton(
                            onPressed: () {
                              value.sendOtpApis(
                                  loginController.phoneNumberController.text,
                                  context);
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
                    )
                    // SizedBox(height: height * 0.2),
                    // SizedBox(height: height * 0.02),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.black,
            height: context.deviceHeight * .1,
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'By continuing you agree to our\n',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: context.deviceWidth * .035,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' Privacy Policy ',
                        style: GoogleFonts.poppins(
                          color: buttonColor,
                          fontWeight: FontWeight.w400,
                          fontSize: context.deviceWidth * .033,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {}),
                    TextSpan(
                      text: 'and ',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: context.deviceWidth * .035,
                      ),
                    ),
                    TextSpan(
                        text: 'Terms of Services',
                        style: GoogleFonts.poppins(
                          color: buttonColor,
                          fontWeight: FontWeight.w400,
                          fontSize: context.deviceWidth * .033,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {}),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
