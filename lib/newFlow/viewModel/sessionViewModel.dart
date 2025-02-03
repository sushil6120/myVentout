import 'package:flutter/material.dart';
import 'package:overcooked/newFlow/model/allTherapistModel.dart';
import 'package:overcooked/newFlow/model/sessionHistoryModel.dart';
import 'package:overcooked/newFlow/model/singleSessionModel.dart';
import 'package:overcooked/newFlow/reposetries/sessionRepo.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/viewModel/utilViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilsClass.dart';
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

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> BookSessionApis(
      String fees,
      timeDuration,
      startTime,
      token,
      id,
      bool isInstant,
      bookingType,
      BuildContext? context,
      slotId,
      [isFreeSession]
      ) async {
    try {
      final newData = await sessionRepo.createSessionApi(fees, timeDuration,
          startTime, token, id, isInstant, bookingType, context , slotId, isFreeSession);
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
        // UtilsClass().showDialogForSuccessfulBooking(
        //   context,
        //   image,
        //   name,
        //   bookingType,
        //   userId,
        //   targatedUserId,
        //   targatedUserName,
        //   isSessionScreen,
        //   () {},
        // );
      } else {
        Utils.toastMessage(newData.message.toString());
      }

      print(newData.message);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> createSessionApis(
      String fees,
      timeDuration,
      startTime,
      token,
      id,
      bool isInstant,
      String channelNamem,
      bookingType,
      name,
      image,
      userId,
      targatedUserId,
      targatedUserName,
      bool isSessionScreen,
      BuildContext context,
      ) async {
    try {
      final newData = await sessionRepo.createSessionApi(fees, timeDuration,
          startTime, token, id, isInstant, bookingType, context, "");
      sharedPreferencesViewModel.saveTherapistId(
          newData.populatedSession!.therapistId!.sId.toString());
      agoraToken = newData.populatedSession!.agoraToken.toString();
      message = newData.message.toString();
      sessionid = newData.populatedSession!.sId.toString();

      notifyListeners();

      if (isInstant == true) {
        final sendNoti = Provider.of<UtilsViewModel>(context, listen: false);
        sendNoti.sendNotificationApis(sessionid.toString(), context);
      }
      if (message == 'Session booked successfully!') {
        // UtilsClass().showDialogForSuccessfulBooking(
        //   context,
        //   image,
        //   name,
        //   bookingType,
        //   userId,
        //   targatedUserId,
        //   targatedUserName,
        //   isSessionScreen,
        //   () {},
        // );
      } else {
        Utils.toastMessage(newData.message.toString());
      }

      print(newData.message);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

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

  Stream<List<SingleSessionModel>> singleSessionStream(String id) async* {
    try {
      while (true) {
        List<SingleSessionModel> theraPistList =
            await sessionRepo.fetchSingleSessionHistory(id);
        yield theraPistList;

        await Future.delayed(Duration(seconds: 1));
        sessionDatas = theraPistList;
        notifyListeners();
      }
    } catch (e) {
      print("Error in stream: $e");
    }
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
