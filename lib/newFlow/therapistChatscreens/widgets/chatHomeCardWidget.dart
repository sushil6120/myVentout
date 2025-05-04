import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/newFlow/resultScreen.dart';
import 'package:overcooked/newFlow/therapistChatscreens/chatBuddyScreen.dart';
import 'package:overcooked/newFlow/therapistPrefernceScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Utils/assetConstants.dart';

class ChatHomeCardWidget extends StatelessWidget {
Color ?iconColor;
String userId;
  ChatHomeCardWidget(
      {super.key,
      this.iconColor = colorLightWhite,
      required this.userId
     });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ChatScreen(chatId: userId,),
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
      
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        margin: const EdgeInsets.only(left: 12,right: 12,bottom: 24),
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
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SvgPicture.asset(
                height: 28,
                width: 28,
                AppAssets.chatIcon,
                color: iconColor,
              ),
            ),
            SizedBox(
         height:    6 ,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      "Chat with psychologist!",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
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
                          text:
                              "We’ve matched you with a therapist who’s here to listen and support you. ",
                        ),
                        TextSpan(
                          text: "Enjoy free trial",
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              " — ask up to 10 questions, whenever you need, wherever you are.",
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
