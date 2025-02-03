import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overcooked/newFlow/reposetries/homeRepo.dart';

class ChatViewModel with ChangeNotifier {
  HomeRepo homeRepo;
  ChatViewModel(this.homeRepo);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  types.User? _user;
  List<types.Message> _messages = [];
  bool isLoading = false;
  bool isSize = false;
  Timer? _timer;
  int remainingTime = 45; // Time in seconds

  int get minutes => remainingTime ~/ 60;
  int get seconds => remainingTime % 60;

  types.User? get user => _user;

  void loading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void isSizes(bool value) {
    isSize = value;
    notifyListeners();
  }

  void setMessages(List<types.Message> messages) {
    _messages = messages;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void addMessage(types.Message message) {
    _messages.insert(0, message);
    notifyListeners();
  }

  // Fetch remaining time from API
  Future<void> fetchRemainingTimeApi(double minutes, String bookingId) async {
    try {
      setLoading(true);
      var newData = await homeRepo.remainingTimeApi(minutes, bookingId);
      remainingTime = (newData.remainingMinutes! ).toInt(); // Convert minutes to seconds
      notifyListeners();
      setLoading(false);

      startTimer(); // Start timer after getting the remaining time
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        notifyListeners();
      } else {
        timer.cancel();
        onTimerComplete();
      }
    });
  }

  void onTimerComplete() {
    // Call your API when the timer reaches 0 and navigate back
    hitApiAndNavigateBack();
  }

  void hitApiAndNavigateBack() {
    // TODO: Add your API call logic here

    // After API call, navigate back
    // Assuming you have a context or a navigatorKey
    // navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
