import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/colors.dart';

class AddMoneyDialog extends StatelessWidget {
  final VoidCallback onBackToHomePressed;

  AddMoneyDialog({
    Key? key,
    required this.onBackToHomePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      elevation: 2,
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: GoogleFonts.roboto(
                  color: Colors.white54,
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text: "Insufficient Balance:  ",
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: Colors.red.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'Add money to your wallet.',
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: colorLightWhite),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 34,
            ),
            GestureDetector(
              onTap: onBackToHomePressed,
              child: Container(
                width: double.infinity,
                height: 40,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: colorLightWhite,
                  borderRadius: BorderRadius.circular(32),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Add Money',
                  style: GoogleFonts.roboto(
                    color: colorDark1,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 14),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 14),
            //   child: RichText(
            //     textAlign: TextAlign.start,
            //     text: TextSpan(
            //       style: GoogleFonts.roboto(
            //         color: Colors.white,
            //         fontSize: 12,
            //       ),
            //       children: [

            //         TextSpan(
            //           text: 'Overcooked',
            //           style: GoogleFonts.roboto(
            //             fontSize: 8,
            //             fontWeight: FontWeight.w200,
            //             // color: primaryColor,
            //           ),
            //         ),
            //         TextSpan(
            //           text: ' is built on quality. No AI, No astrologers, No active listeners and No life coaches! Only Real Certified Therapists.',
            //           style: GoogleFonts.roboto(
            //             fontSize: 8,

            //             fontWeight: FontWeight.w200,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
