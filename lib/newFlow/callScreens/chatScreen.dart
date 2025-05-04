import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:overcooked/Utils/responsive.dart';
import '../../Utils/colors.dart';
import '../model/reaminTimeModel.dart';
import '../services/sharedPrefs.dart';
import '../viewModel/chatViewModel.dart';

class ChatPage extends StatefulWidget {
  final String chatId, sessionId;
  String duration, therapistCate, bookingStatus;

  ChatPage({
    Key? key,
    required this.chatId,
    required this.duration,
    required this.bookingStatus,
    required this.sessionId,
    required this.therapistCate,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  List<types.Message> _messages = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();
  types.User? _user;
  late StreamSubscription<QuerySnapshot> _messageSubscription;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool isUploading = false;

  String? userId, userName, profileImage;
  int remainingTime = 0;
  remainTimeModel? datas;
  Timer? _timer;
  String confirmationText = "Confirming with the Expert";
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  // Auto message variables
  late Timer autoMsgTimer = Timer(const Duration(seconds: 0), () {});

  int autoMsgCounter = 0;
  bool hasSentAutoMessage = false; // Track if the auto message has been sent

  @override
  void initState() {
    super.initState();

    double? dur = double.tryParse(widget.duration.toString());
    _initializeUser();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _animationController.forward();
    _startConfirmationTimer();

    // Check if the collection is empty and send auto messages if necessary
    _checkAndSendAutoMessages();
  }

  void _startConfirmationTimer() async {
    await Future.delayed(Duration(
        seconds: widget.bookingStatus == 'Confirm'
            ? 0
            : 30)); // Initial delay for 2 mins
    if (mounted) {
      setState(() {
        confirmationText = "Wait ~ 2 mins";
      });
    }

    await Future.delayed(const Duration(minutes: 1)); // Delay for 1 min
    if (mounted) {
      setState(() {
        confirmationText = "Wait ~ 1 min";
      });
    }

    await Future.delayed(const Duration(minutes: 1)); // Delay for final message
    if (mounted) {
      setState(() {
        confirmationText = "Wait ~ Almost there";
      });
    }
  }

  Future<void> _initializeUser() async {
    final competitionData = Provider.of<ChatViewModel>(context, listen: false);
    await Future.wait([
      sharedPreferencesViewModel.getUserId(),
      sharedPreferencesViewModel.getUserName(),
      sharedPreferencesViewModel.getProfileImage(),
    ]).then((value) {
      userId = value[0];
      userName = value[1];
      profileImage = value[2];

      _user = types.User(
        id: value[0].toString(),
        firstName: userName,
        imageUrl: profileImage,
      );

      _loadMessages();
    });
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
      final textMessage = types.TextMessage(
        author: types.User(id: userId.toString()),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: 'message_id',
        text: notification.body ?? '',
      );
      _addMessage(textMessage);
    }
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    _animationController.dispose();
    autoMsgTimer?.cancel(); // Cancel the auto message timer when disposing

    super.dispose();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _sendMessage(types.Message message) async {
    try {
      await _firestore
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add(message.toJson());

      Provider.of<ChatViewModel>(context, listen: false).addMessage(message);
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    await _sendMessage(textMessage);
  }

  void _loadMessages() {
    _messageSubscription = _firestore
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        _messages = snapshot.docs
            .map((doc) =>
                types.Message.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    }, onError: (error) {
      print('Error loading messages: $error');
    });
  }

  // Check if the collection is empty and send auto messages
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
            "${now.hour >= 5 && now.hour < 12 ? "Good morning" : now.hour >= 12 && now.hour < 17 ? 'Good afternoon' : 'Good evening'}, $userName");
      } else if (autoMsgCounter == 1) {
        _sendAutoMessage(
            "Therapist will contact you at the allotted time, until then please leave a message.");
      } 
      // else if (autoMsgCounter == 2) {
      //   _sendAutoMessage("Drop a query until we connect");
      // }
      autoMsgCounter++;

      if (autoMsgCounter > 2) {
        autoMsgTimer!.cancel();
        hasSentAutoMessage = true;
      }
    });
  }

  void _sendAutoMessage(String messageText) {
    final textMessage = types.TextMessage(
      author: types.User(id: 'therapist'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: messageText,
    );
    _sendMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) => Consumer<ChatViewModel>(
        builder: (context, timerProvider, child) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: false,
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.therapistCate,
                    style: TextStyle(
                        color: colorLightWhite,
                        fontSize: context.deviceWidth * .045,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    widget.bookingStatus == 'Confirm'
                        ? "Tap to go on chat screen"
                        : confirmationText,
                    style: GoogleFonts.inter(
                      color: confirmationText == "Confirming with the Expert"
                          ? greenColor
                          : Colors.white,
                      fontSize: MediaQuery.of(context).size.width * .03,
                    ),
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                Image.asset('assets/img/back-designs.png'),
                SafeArea(
                  child: _user == null
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: colorLightWhite,
                            strokeWidth: 1,
                          ),
                        )
                      : Chat(
                          onMessageDoubleTap: (context, p1) async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(widget.chatId)
                                  .collection('messages')
                                  .doc(p1.id)
                                  .delete();
                              print('Message deleted successfully');
                            } catch (error) {
                              print('Error deleting message: $error');
                            }
                          },
                          messages: _messages,
                          onSendPressed: _handleSendPressed,
                          user: _user!,
                          theme: DefaultChatTheme(
                            backgroundColor: Colors.transparent,
                            primaryColor: semiDark,
                            secondaryColor: Colors.white,
                            inputBackgroundColor: colorDark1,
                            inputBorderRadius: BorderRadius.circular(30),
                            receivedMessageBodyTextStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                            dateDividerTextStyle: const TextStyle(
                                color: semiDark, fontWeight: FontWeight.w600),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      );

  String _formatTime(int minutes) {
    final minutesLeft = minutes % 60;
    final hoursLeft = minutes ~/ 60;
    return '$hoursLeft:${minutesLeft.toString().padLeft(2, '0')}';
  }
}
