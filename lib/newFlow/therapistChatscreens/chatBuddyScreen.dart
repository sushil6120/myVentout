import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:overcooked/newFlow/bottomNaveBar.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/therapistChatscreens/widgets/dialogWidget.dart';
import 'package:overcooked/newFlow/therapistChatscreens/widgets/messageBubbleWidget.dart';
import 'package:overcooked/newFlow/viewModel/homeViewModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../Utils/colors.dart';
import 'viewmodels/chatProvider.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String therapistName;
  final String therapistImageUrl;

  const ChatScreen({
    super.key,
    required this.chatId,
    this.therapistName = 'Anuja Sharma',
    this.therapistImageUrl =
        'https://res.cloudinary.com/ds5ghtxy2/image/upload/v1745401611/profileImg/o1z2w5gfctafyqg88pxn.jpg',
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  late ChatProvider _chatProvider;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Timer autoMsgTimer = Timer(const Duration(seconds: 0), () {});
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();

  int autoMsgCounter = 0;
  bool hasSentAutoMessage = false;

  String _userId = '';
  String _userName = '';

  @override
  void initState() {
    super.initState();
    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);

    _loadUserData();

    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    Future.wait([sharedPreferencesViewModel.getDialogStatus()]).then(
      (value) {
        print("objects ${value[0]}");
        if (value[0] == false || value[0] == null) {
          showChatDialog(context, primaryColor, colorLightWhite);
        }
      },
    );
    Future.wait([
      sharedPreferencesViewModel.getToken(),
      sharedPreferencesViewModel.getDialogStatus(),
      sharedPreferencesViewModel.getSignUpToken(),
      sharedPreferencesViewModel.getUserName(),
    ]).then(
      (value) {
        _userName = value[3].toString();
        getHomeData.fetchWalletBalanceAPi(
            value[0] == null ? value[2].toString() : value[0].toString());
        _chatProvider.chatPostDataApi(
            value[0].toString(), '67daab1845de62a91b29caba'
            // '67ece108a55f4144a8cb5507'
            );
      },
    );

    _chatProvider.initFirebaseMessaging();
    _checkAndSendAutoMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatProvider.loadMessages(widget.chatId);

      _chatProvider.checkAndSendAutoMessages(widget.chatId, _userName);
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId') ??
        'user_${DateTime.now().millisecondsSinceEpoch}';
    _userName = prefs.getString('name') ?? 'User';

    if (!prefs.containsKey('userId')) {
      await prefs.setString('userId', _userId);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    // The provider will be disposed automatically
    super.dispose();
  }

  // void _scrollToBottom() {
  //   if (_scrollController.hasClients) {
  //     Future.delayed(const Duration(milliseconds: 100), () {
  //       _scrollController.animateTo(
  //         _scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     });
  //   }
  // }

  Future<void> _checkAndSendAutoMessages() async {
    final snapshot = await _firestore
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .get();

    if (snapshot.docs.isEmpty && !hasSentAutoMessage) {
      // Send the three auto messages if the collection is empty
      _sendAutoMessages();
    }
  }

  void _sendAutoMessages() {
    autoMsgTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      DateTime now = DateTime.now();

      if (autoMsgCounter == 0) {
        _sendAutoMessage(
            "${now.hour >= 5 && now.hour < 12 ? "Good morning" : now.hour >= 12 && now.hour < 17 ? 'Good afternoon' : 'Good evening'}, $_userName");
      } else if (autoMsgCounter == 1) {
        _sendAutoMessage(
            "Hi there, I'm Anuja Sharma, your Counseling Psychologist😊 I'm here to listen and support you—no pressure, no judgment. Feel free to share what’s on your mind, whenever you’re ready.");
      }
      // else if (autoMsgCounter == 2) {
      //   _sendAutoMessage("Drop a query until we connect");
      // }
      autoMsgCounter++;

      if (autoMsgCounter > 2) {
        autoMsgTimer.cancel();
        hasSentAutoMessage = true;
      }
    });
  }

  void _sendAutoMessage(String messageText) async {
    final messageId = const Uuid().v4();
    final timestamp = DateTime.now();

    await _firestore
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .doc(messageId)
        .set({
      'id': messageId,
      'content': messageText,
      'senderId': '67daab1845de62a91b29caba',
      'senderName': 'Anuja Sharma',
      'timestamp': timestamp,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        // if (chatProvider.messages.isNotEmpty) {
        //   WidgetsBinding.instance
        //       .addPostFrameCallback((_) => _scrollToBottom());
        // }

        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/back-designs.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                elevation: .5,
                backgroundColor: Colors.black,
                surfaceTintColor: Colors.black,
                shadowColor: colorDark3,
                titleSpacing: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Get.offAll(BottomNavBarView(),
                        transition: Transition.leftToRight);
                  },
                ),
                title: Consumer<HomeViewModel>(
                  builder: (context, value, child) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.expertScreen,
                            arguments: {
                              'id': '67daab1845de62a91b29caba',
                              "balance": value.walletModel!.balance ?? '0',
                              "fees": '12',
                            });
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFF128C7E),
                            backgroundImage:
                                NetworkImage(widget.therapistImageUrl),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.therapistName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Expected response time :',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    ' 8 Minutes',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: chatProvider.messages.isEmpty
                          ? const SizedBox.shrink()
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              itemCount: chatProvider.messages.length +
                                  (chatProvider.isTyping ? 1 : 0),
                              reverse: true,
                              itemBuilder: (context, index) {
                                final messageIndex =
                                    chatProvider.messages.length - 1 - index;

                                if (index < chatProvider.messages.length) {
                                  return WhatsAppMessageBubble(
                                      message:
                                          chatProvider.messages[messageIndex]);
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, -2),
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: 120,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: TextField(
                                    controller: _inputController,
                                    focusNode: _focusNode,
                                    minLines: 1,
                                    maxLines: 5,
                                    cursorColor: const Color(0xFF10A37F),
                                    style: const TextStyle(color: Colors.white),
                                    onChanged: (value) =>
                                        chatProvider.updateInput(value),
                                    decoration: InputDecoration(
                                      hintText:
                                          'Message ${widget.therapistName}...',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(bottom: 4),
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  color: chatProvider.currentInput
                                          .trim()
                                          .isNotEmpty
                                      ? primaryColor
                                      : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  onPressed: chatProvider.currentInput
                                          .trim()
                                          .isNotEmpty
                                      ? () {
                                          if (_inputController.text
                                              .trim()
                                              .isNotEmpty) {
                                            // final utilsProvider =
                                            //     Provider.of<UtilsViewModel>(
                                            //         context,
                                            //         listen: false);

                                            chatProvider.sendMessage(
                                                _inputController.text,
                                                widget.chatId,
                                                _userName);
                                            _inputController.clear();
                                            // utilsProvider.sendNotificationApis(
                                            //   '67ece108a55f4144a8cb5507', context);
                                          }
                                        }
                                      : null,
                                ),
                              )
                            ])),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
