import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overcooked/newFlow/therapistChatscreens/model/chatMessageModel.dart';
import 'package:overcooked/newFlow/therapistChatscreens/widgets/chatTypingIndicator.dart';

import '../../../Utils/colors.dart';


class WhatsAppMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const WhatsAppMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isUser
                ? popupColor
                : colorDark1, 
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              message.isLoading
                  ? const WhatsAppTypingIndicator()
                  : SelectableText(
                      message.content,
                      style: const TextStyle(
                        color: colorLightWhite,
                        fontSize: 16,
                      ),
                    ),

              Padding(
                padding: const EdgeInsets.only(top: 2, left: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(message.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                    // if (isUser) ...[
                    //   const SizedBox(width: 3),
                    //   Icon(
                    //     Icons.done_all,
                    //     size: 14,
                    //     color: const Color(
                    //         0xFF34B7F1), // WhatsApp blue check marks
                    //   ),
                    // ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}