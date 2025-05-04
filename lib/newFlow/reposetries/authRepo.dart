// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';

import '../model/availbiltyModel.dart';
import '../model/loginModel.dart';
import '../model/otpVerifyModel.dart';
import '../model/therapistProfileModel.dart';
import '../routes/routeName.dart';
import '../services/app_url.dart';
import '../services/http_service.dart';

class AuthRepo {
  final ApiService apiService;

  AuthRepo(this.apiService);

  Future<LoginModel> sendOtpApi(String phone) async {
    final response = await apiService.post(
      AppUrl.sendOtpApi,
      headers: {"Content-type": "application/json"},
      body: {'phone': phone},
    );
    return LoginModel.fromJson(json.decode(response.body));
  }

  Future<OtpVerifyModel> otpVerifyApi(
      String phone, otp, BuildContext context) async {
    SharedPreferencesViewModel sharedPreferencesViewModel =
        SharedPreferencesViewModel();
    final response = await apiService.post(
      AppUrl.otpVerifyUrl,
      headers: {"Content-type": "application/json"},
      body: {'phone': phone, 'otp': otp},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonData = jsonDecode(response.body);
    }
    return OtpVerifyModel.fromJson(json.decode(response.body));
  }

  // --
  Future<AvailbiltiModel> registrationApi(
      String name, age, gender, token) async {
    final response = await apiService.put(
      AppUrl.registerUrl,
      headers: {
        "Content-type": "application/json",
        'Authorization': 'Bearer $token'
      },
      body: {'name': name, 'age': age, "gender": gender},
    );
    return AvailbiltiModel.fromJson(json.decode(response.body));
  }

  // --
  Future<AvailbiltiModel> prefrencesApi(
      token, var defaultQnA, BuildContext context) async {
    final response = await apiService.patch(
      AppUrl.prefrencesUrl,
      headers: {
        "Content-type": "application/json",
        'Authorization': 'Bearer $token'
      },
      body:defaultQnA,
    );
    print("Default QNA : $defaultQnA");
    print("Response  : ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {}
    return AvailbiltiModel.fromJson(json.decode(response.body));
  }

  // ============================== Profile Api ======

  Future<TherapistProfileModel> fetchTherapistProfile(String Id) async {
    final response = await apiService.get(AppUrl.getTherapistProfileApi + Id,
        headers: {"Content-type": "application/json"});
    final Map<String, dynamic> dataJson = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {}
    return TherapistProfileModel.fromJson(dataJson);
  }
}
