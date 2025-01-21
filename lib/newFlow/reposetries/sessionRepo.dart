import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventout/newFlow/services/sharedPrefs.dart';

import '../../Utils/utilsFunction.dart';
import '../model/availbiltyModel.dart';
import '../model/cerateSessionModel.dart';
import '../model/sessionHistoryModel.dart';
import '../model/singleSessionModel.dart';
import '../services/app_url.dart';
import '../services/http_service.dart';

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
      String channelNamem,
      bookingType,
      BuildContext context) async {
    SharedPreferencesViewModel sharedPreferencesViewModel =
        SharedPreferencesViewModel();
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
        "isInstant": isInstant,
        "channelName": channelNamem,
        "bookingType": bookingType
      },
    );
    print("============${response.body}=====================");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      sharedPreferencesViewModel.saveFreeStatus(false);
      Utils.toastMessage(data['message']);
    } else if (response.statusCode == 400) {
      var data = jsonDecode(response.body);
      // ignore: use_build_context_synchronously
      Get.snackbar('Booking', 'You have already one booking!');
    }
    return CreateSessionModel.fromJson(json.decode(response.body));
  }

  Future<List<SessionHistoryModel>> fetchSessionHistory(String token) async {
    final response =
        await apiService.get(AppUrl.sessionHistoryUrl + token, headers: {
      "Content-type": "application/json",
    });
    final List<dynamic> dataJson = json.decode(response.body);
    return dataJson.map((json) => SessionHistoryModel.fromJson(json)).toList();
  }

  Future<List<SingleSessionModel>> fetchSingleSessionHistory(String id) async {
    final response =
        await apiService.get(AppUrl.singleSessionUrlUrl + id, headers: {
      "Content-type": "application/json",
    });
    final List<dynamic> dataJson = json.decode(response.body);
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
