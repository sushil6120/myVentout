import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/therapistPrefernceScreen.dart';
import 'package:overcooked/newFlow/viewModel/questionsProvider.dart';
import 'package:provider/provider.dart';

import '../../Utils/components.dart';

class AssessmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestionProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: "Relationship Stress Test ",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                        text: "(HAM-D Based)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: "Instructions :",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text:
                          " Read each question carefully and select the option that best describes how you have been feeling in the past week. We will assess it and release the results within a week.",
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: customButton(() {
                provider.clearAnswers();
                Get.offAll(
                    TherapistPreferencesScreen(
                      isRegisterScreen: true,
                      //          selectedExpertise: '',
                      // selectedGender: '',
                      // selectedLanguages: '',
                      // selectedReachMeOut: '',
                      token: '',
                    ),
                    transition: Transition.rightToLeft);
              }, context.deviceWidth, 50, 'Take Assessment', false),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
              "Your data on Overcooked is encrypted and Confidential.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: colorLight2),
            )),
            SizedBox(height: 26),
            // Center(
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.pushNamedAndRemoveUntil(
            //           context, RoutesName.bottomNavBarView, (route) => false);
            //     },
            //     child: Text(
            //       'Skip',
            //       style: TextStyle(
            //         fontWeight: FontWeight.w600,
            //         color: Colors.white.withOpacity(0.6),
            //         fontSize: 18,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 56),
          ],
        ),
      ),
    );
  }
}
