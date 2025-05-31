import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:overcooked/Utils/utilsFunction.dart';
import 'package:overcooked/newFlow/addMoneyScreen.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../../services/app_url.dart';
import '../../viewModel/walletViewModel.dart';
import '../../widgets/addMoneyDialog.dart';
import '../model/chatMessageModel.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  String _currentInput = '';
  String get currentInput => _currentInput;

  bool _isTyping = false;
  bool get isTyping => _isTyping;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  StreamSubscription<QuerySnapshot>? _messagesSubscription;
  Timer? _autoMessageTimer;
  int _autoMessageCounter = 0;
  bool _hasSentAutoMessages = false;
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();

  void addMessage(ChatMessage message) {
    messages.add(message);
    notifyListeners();
  }

  // void initFirebaseMessaging() async {
  //   // Request permission for notifications
  //   await _firebaseMessaging.requestPermission();

  //   // // Handle incoming messages when app is in foreground
  //   // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   //   final notification = message.notification;
  //   //   if (notification != null) {
  //   //     _addMessage(ChatMessage(
  //   //       id: const Uuid().v4(),
  //   //       content: notification.body ?? '',
  //   //       role: MessageRole.assistant,
  //   //       timestamp: DateTime.now(),
  //   //     ));
  //   //   }
  //   // });
  // }

  void updateInput(String input) {
    _currentInput = input;
    notifyListeners();
  }

  void loadMessages(String chatId) {
    _messagesSubscription = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      _messages = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ChatMessage(
          id: doc.id,
          content: data['content'] ?? '',
          role: data['senderId'] == chatId
              ? MessageRole.user
              : MessageRole.assistant,
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
      notifyListeners();
    }, onError: (error) {
      print('Error loading messages: $error');
    });
  }

  Future<void> sendMessage(String content, chatId, userName) async {
    if (content.trim().isEmpty) return;

    final messageId = const Uuid().v4();
    final timestamp = DateTime.now();

    // Add message locally first for immediate UI update
    _addMessage(ChatMessage(
      id: messageId,
      content: content,
      role: MessageRole.user,
      timestamp: timestamp,
    ));

    // Set typing indicator
    _setTyping(true);

    // Send to Firestore
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set({
        'id': messageId,
        'content': content,
        'senderId': chatId,
        'senderName': userName,
        'timestamp': timestamp,
      });
    } catch (error) {
      print('Error sending message: $error');
      _setTyping(false);
    }
  }

  void _addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void _setTyping(bool typing) {
    _isTyping = typing;
    notifyListeners();
  }

  Future<void> checkAndSendAutoMessages(String chatId, userName) async {
    if (_hasSentAutoMessages) return;

    final snapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();

    if (snapshot.docs.isEmpty) {
      _sendAutoMessages(userName, chatId);
    }
  }

  void _sendAutoMessages(String chatId, userName) {
    _autoMessageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final now = DateTime.now();

      if (_autoMessageCounter == 0) {
        _sendAutoMessage(
            "${now.hour >= 5 && now.hour < 12 ? 'Good morning' : now.hour >= 12 && now.hour < 17 ? 'Good afternoon' : 'Good evening'}, $userName",
            chatId);
      } else if (_autoMessageCounter == 1) {
        _sendAutoMessage(
            "I'm Anuja Sharma, your therapist. How are you feeling today?",
            chatId);
      } else if (_autoMessageCounter == 2) {
        _sendAutoMessage(
            "Feel free to share what's on your mind, and we can begin our session.",
            chatId);
      }

      _autoMessageCounter++;

      if (_autoMessageCounter > 2) {
        _autoMessageTimer?.cancel();
        _hasSentAutoMessages = true;
      }
    });
  }

  Future<void> _sendAutoMessage(String content, chatId) async {
    final messageId = const Uuid().v4();
    final timestamp = DateTime.now();

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .set({
      'id': messageId,
      'content': content,
      'senderId': '67daab1845de62a91b29caba',
      'senderName': 'Anuja Sharma',
      'timestamp': timestamp,
    });
  }

  Future<void> chatPostDataApi(String token, id) async {
    final response = await http.post(
      Uri.parse(AppUrl.sendPostChatApi + id),
      headers: {
        "Content-type": "application/json",
        'Authorization': 'Bearer $token'
      },
    );
    print('chatPostDataApi: ${response.body}');
  }

  Future<void> unlockChatApi({required double balance}) async {
    final walletData =
        Provider.of<WalletViewModel>(Get.context!, listen: false);
    String? userId = await sharedPreferencesViewModel.getUserId();
    String? token = await sharedPreferencesViewModel.getToken();
    String? signUptoken = await sharedPreferencesViewModel.getSignUpToken();
    if (userId == null) {
      throw ' User id null';
    }
    final response = await http.patch(Uri.parse(AppUrl.unlockChat + userId),
        headers: {
          "Content-type": "application/json",
        },
        body: jsonEncode({"amount": 100}));
    print('unlockChatApi: ${response.statusCode}, ${response.body}');
    var data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      walletData.fetchWalletBalanceAPi(token == null ? signUptoken! : token!);
    }
    if (response.statusCode == 401) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return AddMoneyDialog(
            onBackToHomePressed: () {
              Get.to(
                  AddMoneyScreen(
                    arguments: {'balance': balance ?? 0},
                  ),
                  transition: Transition.rightToLeft);
            },
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _autoMessageTimer?.cancel();
    super.dispose();
  }
}
