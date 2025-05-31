import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overcooked/newFlow/model/allTherapistModel.dart';
import 'package:overcooked/newFlow/model/sessionHistoryModel.dart';
import 'package:overcooked/newFlow/model/singleSessionModel.dart';
import 'package:overcooked/newFlow/reposetries/sessionRepo.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/viewModel/utilViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilsClass.dart';
import 'package:overcooked/newFlow/viewModel/walletViewModel.dart';
import 'package:overcooked/newFlow/widgets/noFreeSeeionDialog.dart';
import 'package:provider/provider.dart';

import '../../Utils/utilsFunction.dart';

class SessionViewModel with ChangeNotifier {
  final SessionRepo sessionRepo;

  SessionViewModel(this.sessionRepo);
  AllTherapistModel? freeSessionTherapist;

  List<SessionHistoryModel> sessionHistoryData = [];
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();

  List<SingleSessionModel> sessionDatas = [];
  bool isLoading = false;
  bool isFreeSession = false;
  String? agoraToken, message, sessionid;

  bool isFreeLoading = false;

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setFreeLoading(bool value) {
    isFreeLoading = value;
    notifyListeners();
  }

  Future<void> BookSessionApis(String fees, timeDuration, startTime, token, id,
      String userId, bool isInstant, bookingType, BuildContext? context, slotId,
      [isFreeSession]) async {
    final walletData =
        Provider.of<WalletViewModel>(Get.context!, listen: false);
    String? token = await sharedPreferencesViewModel.getToken();
    String? signUptoken = await sharedPreferencesViewModel.getSignUpToken();
    try {
      final newData = await sessionRepo.createSessionApi(
          fees,
          timeDuration,
          startTime,
          token,
          id,
          isInstant,
          bookingType,
          context,
          slotId,
          isFreeSession);
      sharedPreferencesViewModel.saveTherapistId(
          newData.populatedSession!.therapistId!.sId.toString());
      agoraToken = newData.populatedSession!.agoraToken.toString();
      message = newData.message.toString();
      sessionid = newData.populatedSession!.sId.toString();

      notifyListeners();

      if (isInstant == true) {
        final sendNoti = Provider.of<UtilsViewModel>(context!, listen: false);
        sendNoti.sendNotificationApis(sessionid.toString(), context);
      }
      if (message == 'Session booked successfully!') {
        // singleSessionStream(userId);
      } else {
        Utils.toastMessage(newData.message.toString());
      }

      walletData.fetchWalletBalanceAPi(token == null ? signUptoken! : token!);
      print(newData.message);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> BookFreeSessionApis(String timeDuration, startTime, token,
      bool isInstant, bookingType, BuildContext context,
      {required String userId}) async {
    try {
      setFreeLoading(true);
      final newData = await sessionRepo.createFreeSessionApi(
          timeDuration, startTime, token, isInstant, bookingType, context);

      notifyListeners();
      setFreeLoading(false);
      if (isInstant == true) {
        final sendNoti = Provider.of<UtilsViewModel>(context, listen: false);
        sendNoti.sendNotificationApis(sessionid.toString(), context);
      }
      if (message == "Session booked successfully!") {
        sharedPreferencesViewModel.saveTherapistId(
            newData.populatedSession!.therapistId!.sId.toString());
        agoraToken = newData.populatedSession!.agoraToken.toString();
        message = newData.message.toString();
        sessionid = newData.populatedSession!.sId.toString();
        // singleSessionStream(userId);
      } else {
        setFreeLoading(false);

        Utils.toastMessage(newData.message.toString());
      }

      print(newData.message);
    } catch (error) {
      setFreeLoading(false);
      print(error);
    }
  }

  // Future<void> createSessionApis(
  //     String fees,
  //     timeDuration,
  //     startTime,
  //     token,
  //     id,
  //     bool isInstant,
  //     String channelNamem,
  //     bookingType,
  //     name,
  //     image,
  //     userId,
  //     targatedUserId,
  //     targatedUserName,
  //     bool isSessionScreen,
  //     BuildContext context,
  //     ) async {
  //   try {
  //     final newData = await sessionRepo.createSessionApi(fees, timeDuration,
  //         startTime, token, id, isInstant, bookingType, context, "");
  //     sharedPreferencesViewModel.saveTherapistId(
  //         newData.populatedSession!.therapistId!.sId.toString());
  //     agoraToken = newData.populatedSession!.agoraToken.toString();
  //     message = newData.message.toString();
  //     sessionid = newData.populatedSession!.sId.toString();

  //     notifyListeners();

  //     if (isInstant == true) {
  //       final sendNoti = Provider.of<UtilsViewModel>(context, listen: false);
  //       sendNoti.sendNotificationApis(sessionid.toString(), context);
  //     }
  //     if (message == 'Session booked successfully!') {
  //       // UtilsClass().showDialogForSuccessfulBooking(
  //       //   context,
  //       //   image,
  //       //   name,
  //       //   bookingType,
  //       //   userId,
  //       //   targatedUserId,
  //       //   targatedUserName,
  //       //   isSessionScreen,
  //       //   () {},
  //       // );
  //     } else {
  //       Utils.toastMessage(newData.message.toString());
  //     }

  //     print(newData.message);
  //   } catch (error) {
  //     setLoading(false);
  //     print(error);
  //   }
  // }

  Future<void> fetchSessionHistoryAPi(String token) async {
    try {
      setLoading(true);
      sessionHistoryData = await sessionRepo.fetchSessionHistory(token);

      notifyListeners();
      setLoading(false);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> createRevieweAPi(
    String token,
    String therapistId,
    String reviewe,
    int reating,
  ) async {
    try {
      setLoading(true);

      if (reating.isNaN || reating == null) {
        print('Invalid rating value: $reating');
        setLoading(false);
        return;
      }

      print('Sending rating: $reating');
      print(
          'Sending data: { token: $token, therapistId: $therapistId, reviewe: $reviewe, reating: $reating }');

      var newdata = await sessionRepo.createRevieweApi(
          token, therapistId, reviewe, reating);

      print('Response data: $newdata');

      notifyListeners();
      setLoading(false);
    } catch (error) {
      setLoading(false);
      print('Error: $error');
    }
  }

  Stream<List<SingleSessionModel>> singleSessionStream(String id) {
    final controller = StreamController<List<SingleSessionModel>>.broadcast();
    Timer? timer;
    bool isDisposed = false;

    // Force clear existing data
    sessionDatas = [];
    notifyListeners();

    Future<void> fetchFreshData() async {
      if (isDisposed) return;
      try {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final therapistList =
            await sessionRepo.fetchSingleSessionHistory("$id?t=$timestamp");
        print("Fetched API Data: $therapistList");
        if (isDisposed) return;
        sessionDatas = List<SingleSessionModel>.from(therapistList);
        if (sessionDatas.isNotEmpty) {
          print("Session Data: ${sessionDatas.first.bookedBy?.name}");
        } else {
          print("Session data is empty!");
        }
        notifyListeners();
        controller.add([...sessionDatas]);
      } catch (e) {
        print("Error fetching session data: $e");
        if (isDisposed) return;
        controller.add([]);
      }
    }

    fetchFreshData();

    timer = Timer.periodic(Duration(seconds: 2), (_) => fetchFreshData());

    controller.onCancel = () {
      timer?.cancel();
      isDisposed = true;
      print("Session stream canceled and cleaned up");
    };

    return controller.stream;
  }

  StreamSubscription<List<SingleSessionModel>>? _sessionStreamSubscription;

  void refreshSessionData(String userId) {
    sessionDatas = [];

    notifyListeners();

    _sessionStreamSubscription?.cancel();

    final newStream = singleSessionStream(userId);

    _sessionStreamSubscription = newStream.listen((data) {}, onError: (e) {
      print("Stream error: $e");
    });
  }

  Future<void> updateSessionTimeApi(
      String sessionId, callStartTime, endTime) async {
    try {
      var newdata = await sessionRepo.updateSessionTimeApi(
          sessionId, callStartTime, endTime);
    } catch (error) {
      print('Error: $error');
    }
  }
}
