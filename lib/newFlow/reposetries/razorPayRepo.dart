import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/createPaymentModel.dart';
import '../services/app_url.dart';
import '../services/http_service.dart';

class RazorPayRepo {
  final ApiService apiService;
  RazorPayRepo(this.apiService);

  Future<void> capturePaymentApi(
      String amount, paymentId, BuildContext context) async {
    final response = await apiService.post(
      AppUrl.capturePaymentApi,
      headers: {
        "Content-type": "application/json",
      },
      body: {"paymentId": paymentId, "amount": amount},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (kDebugMode) {
        print(response.body);
      }
    }
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("CaptureApi : ${response.body}");
      }
    } else {
      if (kDebugMode) {
        print("CaptureApi : ${response.body}");
      }
    }
  }
}
