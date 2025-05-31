import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/colors.dart';

class CreditDialog extends StatelessWidget {
  final VoidCallback onNextPressed;
  final String amount;
  final String appName;

  const CreditDialog({
    Key? key,
    required this.onNextPressed,
    required this.amount,
    required this.appName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      elevation: 2,
      contentPadding: EdgeInsets.zero,
      title: Text(
        "Congrats! You've been credited ₹$amount.",
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
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
                    text: 'Thanks for joining ',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextSpan(
                    text: appName,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: primaryColor,
                    ),
                  ),
                  TextSpan(
                    text:
                        '. We\'ve added ₹$amount to your wallet to help you start your mental wellness journey.',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 54),
            GestureDetector(
              onTap: onNextPressed,
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
                  'Next',
                  style: GoogleFonts.roboto(
                    color: colorDark1,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
