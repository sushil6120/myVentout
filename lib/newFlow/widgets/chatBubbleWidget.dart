import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  ChatBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://cdn.prod.website-files.com/619e8d2e8bd4838a9340a810/647c10640a3ea753d88b9748_profile-picture-hero-img.webp'), // Replace with the actual image URL
            ),
          if (!isMe) SizedBox(width: 8),
          Container(
            margin: EdgeInsets.only(
              top: 15,
              bottom: 10,
              right: isMe ? 10 : width * 0.29,
              left: isMe ? width * 0.29 : 10,
            ),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.white : Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(color: isMe ? Colors.black : Colors.white),
                  ),
                ),
              ],
            ),
          ),
          if (isMe) SizedBox(width: 8),
          if (isMe)
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://i.pngimg.me/thumb/f/720/a8bd1f9386.jpg'), // Replace with the actual sender image URL
            ),
        ],
      ),
    );
  }
}

class Message {
  final String content;
  final bool isMe;

  Message({required this.content, required this.isMe});
}
