import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/assetConstants.dart';

import '../../Utils/colors.dart';

class FreeSessionWidget extends StatelessWidget {
  VoidCallback onTap;
  FreeSessionWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // () {
      // showEvaluationSessionDialog(
      //     onPressed: () {
      //       sessionData!
      //           .BookFreeSessionApis(
      //               '10',
      //               DateTime.now().toString(),
      //               token,
      //               true,
      //               "Video Call",
      //               context,
      //               userId: userId.toString())
      //           .then(
      //         (value) {
      //           Navigator.pop(context);
      //         },
      //       );
      //     },
      //     context: context);
      // },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xff111111), 
          borderRadius: BorderRadius.circular(16),
             boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.1),
                  spreadRadius: 5,
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                )
              ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SvgPicture.asset(
                  height: 30,
                  width: 30,
                  color: colorLightWhite,
                  AppAssets.sessionFilled),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      "Claim your Free Session",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: TextStyle(
                        color: darkModeTextLight2,
                        fontSize: 10,
                      ),
                      children: [
                        TextSpan(
                          text: "This is a free ",
                        ),
                        TextSpan(
                          text: "Evaluation Session",
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                        TextSpan(
                          text:
                              " to help us understand the need of counseling in our daily lives.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
