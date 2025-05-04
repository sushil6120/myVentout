
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:overcooked/Utils/colors.dart';


class SessionCreationOverlay extends StatelessWidget {
  final bool isLoading;
  final String message;
  
  const SessionCreationOverlay({
    Key? key,
    required this.isLoading,
    this.message = "Creating Your Session",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.black.withOpacity(0.5),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 19, 18, 18),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                              strokeWidth: 3,
                            ),
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 20,
                              color: greenColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        message,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: colorLightWhite,
                        ),
                      ),
                   
                      Text(
                        "Please wait while we process your payment and confirm your session...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorLightWhite,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}