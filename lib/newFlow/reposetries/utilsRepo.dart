import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ventout/newFlow/routes/routeName.dart';

import '../../Utils/utilsFunction.dart';
import '../model/categoryModel.dart';
import '../model/reviewModel.dart';
import '../model/sendNotiFication.dart';
import '../model/zegoCloudeModel.dart';
import '../services/app_url.dart';
import '../services/http_service.dart';
import 'package:http/http.dart' as http;

class UtilsRepo {
  final ApiService apiService;

  UtilsRepo(this.apiService);

  Future<List<CategoryModel>> fetchCategory() async {
    final response = await apiService
        .get(AppUrl.categoryUrl, headers: {"Content-type": "application/json"});
    final List<dynamic> dataJson = json.decode(response.body);
    return dataJson.map((json) => CategoryModel.fromJson(json)).toList();
  }

  Future<List<ReviewModel>> fetchReview(String therpistId) async {
    final response = await apiService.get(AppUrl.reviewgetUrl + therpistId,
        headers: {"Content-type": "application/json"});
    final List<dynamic> dataJson = json.decode(response.body);
    return dataJson.map((json) => ReviewModel.fromJson(json)).toList();
  }

  Future<SendNotificationModel> sendNotificationApi(String sessionid) async {
    final response = await http.patch(
      Uri.parse(AppUrl.baseUrl + AppUrl.sendNotificationUrl + sessionid),
      headers: {
        "Content-type": "application/json",
      },
    );

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SendNotificationModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send notification');
    }
  }

  Future<void> reportApi(String token, title, description) async {
    final response = await http.post(
        Uri.parse(AppUrl.baseUrl + AppUrl.reportUrl),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"title": title, "description": description}));

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      throw Exception('Failed to send notification');
    }
  }

  Future<void> deleteApi(String token, BuildContext context) async {
    final response = await apiService.delete(AppUrl.deleteUrl, headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jasonData = jsonDecode(response.body);
      print(response.body);
      Utils.toastMessage(jasonData['message']);
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.LoginScreen,
        (route) => false,
      );
    } else {
      print(response.body);
      throw Exception('Failed to send notification');
    }
  }
    // =----

    Future<ZegoCloudeModel> fetchZegoCloudeApi() async {
      final response = await http.get(Uri.parse(AppUrl.zegoCloudeApi),
          headers: {"Content-type": "application/json"});
      final dataJson = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print("ZegoCloude Data : ${response.body}");
        }
      }
      if (kDebugMode) {
        print("ZegoCloude Data : ${response.body}");
      }
      return ZegoCloudeModel.fromJson(dataJson);
    }
  
}
