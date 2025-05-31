import 'package:flutter/material.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:provider/provider.dart';

import '../../Utils/colors.dart';

void showEvaluationSessionDialog(
    {required void Function()? onPressed, required BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Consumer<SessionViewModel>(
        builder: (context, values, child) => values.isFreeLoading == true
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: primaryColor,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Creating Free Session....",
                      style: TextStyle(color: colorLightWhite),
                    )
                  ],
                ),
              )
            : AlertDialog(
                // backgroundColor: backgroundColor2,
                title: const Text("Free Session",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )),
                content: const Text(
                  "This is a free Evaluation Session to help you understand the need of counseling in our daily lives. Claim your Free Session.",
                  style: TextStyle(fontSize: 12),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                        )),
                  ),
                  ElevatedButton(
                    onPressed: onPressed,
                    child: Text("Claim Now",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: primaryColor,
                        )),
                  ),
                ],
              ),
      );
    },
  );
}


// -------

void showAnimatedDialog(BuildContext context, Color primaryColor, Color colorLightWhite) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Dialog",
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (_, __, ___) => Container(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );
      
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(0.0, 0.65, curve: Curves.easeOut),
          ),
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curvedAnimation),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            insetPadding: const EdgeInsets.all(20),
            backgroundColor: const Color(0xff111111),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Interval(0.3, 1.0, curve: Curves.easeOutCubic),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Interval(0.4, 1.0, curve: Curves.easeOut),
                            ),
                          ).value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - animation.value) * 10),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        "Note",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Interval(0.5, 1.0, curve: Curves.easeOut),
                            ),
                          ).value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - animation.value) * 15),
                            child: child,
                          ),
                        );
                      },
                      child:  Text(
                        "Free sessions are available from 9 AM to 5 PM everyday. Sorry for the inconvenience, we are just a small startup trying to make a difference.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: colorLightWhite),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Interval(0.6, 1.0, curve: Curves.easeOut),
                            ),
                          ).value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - animation.value) * 20),
                            child: child,
                          ),
                        );
                      },
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          "Okay",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
