import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:overcooked/Utils/assetConstants.dart';
import 'package:overcooked/Utils/components.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/viewModel/authViewModel.dart';

class DOBScreen extends StatefulWidget {
  Map<String, dynamic>? arguments;

  DOBScreen({
    super.key,
    this.arguments,
  });

  @override
  State<DOBScreen> createState() => _DOBScreenState();
}

class _DOBScreenState extends State<DOBScreen> {
  DateTime? dob;
  final TextEditingController _datecontroller = TextEditingController();
  final TextEditingController _monthcontroller = TextEditingController();
  final TextEditingController _yearcontroller = TextEditingController();
 
  String? age, name, token, gender;

  FocusNode _dateFocusNode = FocusNode();
  FocusNode _monthFocusNode = FocusNode();
  FocusNode _yearFocusNode = FocusNode();

  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.arguments!['name'];
    gender = widget.arguments!['gender'];

    Future.wait([sharedPreferencesViewModel.getSignUpToken()]).then((value) {
      token = value[0];
    });
  }

  @override
  void dispose() {
    _dateFocusNode.dispose();
    _monthFocusNode.dispose();
    _yearFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    print('dob: $dob');
    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.08),
            // Center(
            //   child: RichText(
            //     text: TextSpan(
            //       children: [
            //         TextSpan(
            //           text: 'Welcome to ',
            //           style: TextStyle(
            //             fontFamily: 'LeagueSpartan',
            //             fontSize: 32,
            //             fontWeight: FontWeight.w600,
            //             color: Colors.white.withOpacity(0.4),
            //           ),
            //         ),
            //         const TextSpan(
            //           text: 'VO',
            //           style: TextStyle(
            //             fontFamily: 'LeagueSpartan',
            //             fontSize: 32,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Row(
              children: [
                Text(
                  'Welcome to ',
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
                SizedBox(
                    height: 30,
                    width: 30,
                    child: SvgPicture.asset(AppAssets.ocLogo)),
              ],
            ),
            SizedBox(height: height * 0.07),
            Text(
              "What's your date of\nbirth?",
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 30,
                )),
            SizedBox(height: height * 0.1),
            Row(
              children: [
                SizedBox(width: width * 0.06),
                SizedBox(
                  width: width * 0.28,
                  child: TextField(
                    controller: _datecontroller,
                    focusNode: _dateFocusNode,
                    onChanged: (value) {
                      setState(() {
                        _datecontroller.text = value;
                      });
      
                      if (value.length == 2) {
                        _dateFocusNode.nextFocus();
                      } else if (value.isEmpty) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                    keyboardType: TextInputType.datetime,
                    style: const TextStyle(fontSize: 32),
                    decoration: InputDecoration(
                      hintText: 'DD',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 32,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      counterStyle: const TextStyle(fontSize: 0),
                    ),
                    maxLength: 2,
                  ),
                ),
                SizedBox(
                  width: width * 0.28,
                  child: TextField(
                    controller: _monthcontroller,
                    onChanged: (value) {
                      setState(() {
                        _monthcontroller.text = value;
                      });
                      if (value.length == 2) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.length == 0) {
                        FocusScope.of(context).isFirstFocus;
                      } else if (value.isEmpty) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                    onSubmitted: (_) {
                      setState(() {
                        FocusScope.of(context).previousFocus();
                      });
                    },
                    keyboardType: TextInputType.datetime,
                    style: const TextStyle(fontSize: 32),
                    decoration: InputDecoration(
                      hintText: 'MM',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 32,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      counterStyle: const TextStyle(fontSize: 0),
                    ),
                    maxLength: 2,
                  ),
                ),
                SizedBox(
                  width: width * 0.28,
                  child: TextField(
                    controller: _yearcontroller,
                    onChanged: (value) {
                      setState(() {
                        _yearcontroller.text = value;
                      });
                      if (value.length == 4) {
                        FocusScope.of(context)
                            .unfocus(); // Move focus to the next TextField
                      } else if (value.length == 0) {
                        setState(() {
                          FocusScope.of(context).previousFocus();
                        });
                      } else if (value.isEmpty) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                    onEditingComplete: () {
                      if (_yearcontroller.text.isEmpty) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                    keyboardType: TextInputType.datetime,
                    style: const TextStyle(fontSize: 32),
                    decoration: InputDecoration(
                      hintText: 'YYYY',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 32,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      counterStyle: const TextStyle(fontSize: 0),
                    ),
                    maxLength: 4,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // (dob != null)
            //     ?
            Center(child: Consumer<AuthViewModel>(
              builder: (context, value, child) {
                return customButton(() async {
                  // const HomeScreen().navigate();
                  if (_datecontroller.text.isNotEmpty &&
                      _monthcontroller.text.isNotEmpty &&
                      _yearcontroller.text.isNotEmpty) {
                    setState(() {
                      dob = DateTime.parse(
                          '${_yearcontroller.text}${_monthcontroller.text}${_datecontroller.text}');
                      print('dob: $dob');
                      age =
                          (DateTime.now().difference(dob!).inDays / 365.2425)
                              .round()
                              .toString();
                      print(age);
                    });
                    value.registerationApis(
                        name.toString(), age, gender, token, context);
                  }
                }, width * 0.75, height * 0.05, 'Get Started!',
                    value.isLoading);
              },
            )),
            // : const SizedBox(),
            const Spacer(),
            const Center(
              child:
                  Text('We use this to calculate the age on your profile.'),
            ),
          ],
        ),
      ),
    );
  }


}
