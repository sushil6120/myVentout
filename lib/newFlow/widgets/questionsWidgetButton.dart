import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/newFlow/resultScreen.dart';
import 'package:overcooked/newFlow/therapistPrefernceScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/assetConstants.dart';
import '../../Utils/colors.dart';

class QuestionsButtonWidget extends StatelessWidget {
  String token;
  String pdfLink;
  int? totalScrore;
  QuestionsButtonWidget(
      {super.key,
      required this.token,
      required this.pdfLink,
      this.totalScrore});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (pdfLink.isNotEmpty) {
          downloadpdf(pdfLink, context);
        } else {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TherapistPreferencesScreen(
                isRegisterScreen: false,
                token: token!,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset(0.0, 0.0);
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 19, 19, 19),
          boxShadow: [
            BoxShadow(
                color: colorDark1.withOpacity(.3),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 4))
          ],
          // popupColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            totalScrore != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SvgPicture.asset(
                      height: 28,
                      width: 28,
                      AppAssets.preferences2,
                      color: colorLightWhite,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Get.to(
                          UserResultNameScreen(
                              totalScroe: totalScrore.toString()),
                          transition: Transition.rightToLeft);
                    },
                    child: Container(
                        margin: EdgeInsets.only(right: 6),
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 6, bottom: 6),
                        decoration: BoxDecoration(
                            color: colorDark1,
                            borderRadius: BorderRadius.circular(4)),
                        child: Column(
                          children: [
                            Icon(
                              Icons.remove_red_eye,
                              size: 28,
                            ),
                            Text(
                              "View result",
                              style: TextStyle(
                                  fontSize: 8,
                                  color: colorLightWhite,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        )),
                  ),
            SizedBox(
              width: totalScrore == null ? 6 : 0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      "Am I depressed or just overthinking?",
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
                        color: darkModeTextLight1,
                        fontSize: 10,
                      ),
                      children: [
                        TextSpan(
                          text: "Take a 10-question (HAM-D Based) ",
                        ),
                        TextSpan(
                          text: " depression test",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(
                          text:
                              "  and gain insight into your mental well-being.",
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

  Future<void> downloadpdf(String pdfLink, BuildContext context) async {
    final Uri url = Uri.parse(pdfLink);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not report'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
