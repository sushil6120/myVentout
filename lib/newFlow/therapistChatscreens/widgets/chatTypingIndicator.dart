import 'dart:math';

import 'package:flutter/material.dart';

class WhatsAppTypingIndicator extends StatefulWidget {
  const WhatsAppTypingIndicator({super.key});

  @override
  State<WhatsAppTypingIndicator> createState() =>
      _WhatsAppTypingIndicatorState();
}

class _WhatsAppTypingIndicatorState extends State<WhatsAppTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (index) {
                final double offset = (index * 0.3);
                final animation = sin((_controller.value * 2 - offset) * 3.14);

                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF128C7E)
                        .withOpacity(0.6 + (animation * 0.4).clamp(0, 0.4)),
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}