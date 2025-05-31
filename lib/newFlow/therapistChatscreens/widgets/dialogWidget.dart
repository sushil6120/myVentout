import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';

void showChatDialog(
    BuildContext context, Color primaryColor, Color colorLightWhite) {
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: Tween<double>(begin: 0.0, end: 1.0)
                              .animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve:
                                      Interval(0.4, 1.0, curve: Curves.easeOut),
                                ),
                              )
                              .value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - animation.value) * 10),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        "Welcome!",
                        textAlign: TextAlign.center,
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
                          opacity: Tween<double>(begin: 0.0, end: 1.0)
                              .animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve:
                                      Interval(0.5, 1.0, curve: Curves.easeOut),
                                ),
                              )
                              .value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - animation.value) * 15),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        "Your Counseling Psychologist, Anuja Sharma, is here for you. 🌿",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: colorLightWhite),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: Tween<double>(begin: 0.0, end: 1.0)
                              .animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve:
                                      Interval(0.5, 1.0, curve: Curves.easeOut),
                                ),
                              )
                              .value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - animation.value) * 15),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        "You now have 7 days of free access to chat — feel free to ask up to 10 questions during this time.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: colorLightWhite),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: Tween<double>(begin: 0.0, end: 1.0)
                              .animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve:
                                      Interval(0.5, 1.0, curve: Curves.easeOut),
                                ),
                              )
                              .value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - animation.value) * 15),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        "We're so glad you're here. Let's take the first step together.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: colorLightWhite),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: Tween<double>(begin: 0.0, end: 1.0)
                              .animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve:
                                      Interval(0.6, 1.0, curve: Curves.easeOut),
                                ),
                              )
                              .value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - animation.value) * 20),
                            child: child,
                          ),
                        );
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          SharedPreferencesViewModel
                              sharedPreferencesViewModel =
                              SharedPreferencesViewModel();
                          sharedPreferencesViewModel.saveDialogStatus(true);
                          Navigator.of(context).pop();
                        },
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
