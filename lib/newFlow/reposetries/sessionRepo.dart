import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:provider/provider.dart';

import '../../Utils/utilsFunction.dart';
import '../model/availbiltyModel.dart';
import '../model/cerateSessionModel.dart';
import '../model/sessionHistoryModel.dart';
import '../model/singleSessionModel.dart';
import '../services/app_url.dart';
import '../services/http_service.dart';
import '../widgets/noFreeSeeionDialog.dart';

class SessionRepo {
  final ApiService apiService;

  SessionRepo(this.apiService);

  Future<CreateSessionModel> createSessionApi(
      String fees,
      timeDuration,
      startTime,
      token,
      id,
      bool isInstant,
      bookingType,
      BuildContext? context,
      slotId,
      [isFreeSession]) async {
    SharedPreferencesViewModel sharedPreferencesViewModel =
        SharedPreferencesViewModel();
    final sessionData = Provider.of<SessionViewModel>(context!, listen: false);
    print("working good");
    final response = await apiService.post(
      AppUrl.createSessionUrl + id,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: {
        "fees": fees,
        "timeDuration": timeDuration,
        "startTime": startTime,
        "bookingType": bookingType,
        "slot": slotId
      },
    );
    print("Create session Body : ${{
      "fees": fees,
      "timeDuration": timeDuration,
      "startTime": startTime,
      "bookingType": bookingType,
      "slot": slotId
    }}");

    print(
        "booking response :============${response.body}=====================");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      sharedPreferencesViewModel.saveFreeStatus(false);
      Utils.toastMessage(data['message']);
      sessionData.isFreeSession = isFreeSession;
    } else if (response.statusCode == 400) {
      var data = jsonDecode(response.body);
      // ignore: use_build_context_synchronously
      Get.snackbar('Booking', 'You have already one booking!');
    }
    return CreateSessionModel.fromJson(json.decode(response.body));
  }

  Future<CreateSessionModel> createFreeSessionApi(
    String timeDuration,
    startTime,
    token,
    bool isInstant,
    bookingType,
    BuildContext? context,
  ) async {
    SharedPreferencesViewModel sharedPreferencesViewModel =
        SharedPreferencesViewModel();
    final sessionData = Provider.of<SessionViewModel>(context!, listen: false);
    print("working good");
    final response = await apiService.post(
      AppUrl.createFreeSessionUrl,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: {
        "timeDuration": timeDuration,
        "startTime": startTime,
        "bookingType": bookingType,
        "isInstant": isInstant,
      },
    );
    print("${{
      "isInstant": isInstant,
      "timeDuration": timeDuration,
      "startTime": startTime,
      "bookingType": bookingType,
    }}");

    print("============${response.body}=====================");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      sharedPreferencesViewModel.saveFreeStatus(false);
      Utils.toastMessage(data['message']);
    } else if (response.statusCode == 400) {
      var data = jsonDecode(response.body);
      Get.dialog(
        NoFreeSessionDialog(),
        barrierDismissible: true,
      );
      Get.snackbar('Booking', data['message'].toString());
    } else {
      Get.dialog(
        NoFreeSessionDialog(),
        barrierDismissible: true,
      );
    }
    if (kDebugMode) {
      print("Free Session = ${response.body}");
    }
    return CreateSessionModel.fromJson(json.decode(response.body));
  }

  Future<List<SessionHistoryModel>> fetchSessionHistory(String token) async {
    final response =
        await apiService.get(AppUrl.sessionHistoryUrl + token, headers: {
      "Content-type": "application/json",
    });
    final List<dynamic> dataJson = json.decode(response.body);
    if(kDebugMode){
      print("Session History : ${response.body}");
    }
    return dataJson.map((json) => SessionHistoryModel.fromJson(json)).toList();
  }

  Future<List<SingleSessionModel>> fetchSingleSessionHistory(String id) async {
    final response =
        await apiService.get(AppUrl.singleSessionUrlUrl + id, headers: {
      "Content-type": "application/json",
    });
    final List<dynamic> dataJson = json.decode(response.body);
    if (kDebugMode) {
      print("Single Session History = ${response.body}");
    }
    return dataJson.map((json) => SingleSessionModel.fromJson(json)).toList();
  }

  Future<AvailbiltiModel> createRevieweApi(
    String token,
    TherapistId,
    reviewe,
    int reating,
  ) async {
    final response = await apiService.post(
      AppUrl.reviewUrl + TherapistId,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: {"review": reviewe, "rating": reating},
    );
    print("============${response.body}=====================");

    if (response.statusCode == 200 || response.statusCode == 201) {}
    return AvailbiltiModel.fromJson(json.decode(response.body));
  }

  Future<void> updateSessionTimeApi(
      String sessionId, callStartTime, endTime) async {
    final response = await apiService.patch(
      AppUrl.updateSessiontimeApi + sessionId,
      headers: {
        "Content-type": "application/json",
      },
      body: {"callStartTime": callStartTime, "endTime": endTime},
    );
    print("============${response.body}=====================");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
    }
  }
}
