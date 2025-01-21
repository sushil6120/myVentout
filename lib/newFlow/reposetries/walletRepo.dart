import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../model/availbiltyModel.dart';
import '../model/paymentLogModel.dart';
import '../model/walletHistoryModel.dart';
import '../model/walletModel.dart';
import '../routes/routeName.dart';
import '../services/app_url.dart';
import '../services/http_service.dart';

class WalletRepo {
  final ApiService apiService;

  WalletRepo(this.apiService);

  Future<WalletModel> fetchWalletBalance(String token) async {
    final response = await apiService.get(AppUrl.walletUrl, headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    });
    final Map<String, dynamic> dataJson = json.decode(response.body);
    return WalletModel.fromJson(dataJson);
  }

  Future<List<WalletHistoryModel>> fetchWalletHistory(
    String token,
  ) async {
    final response = await apiService
        .get("${AppUrl.walletHistoryUrl}/$token?isDeducted=true", headers: {
      "Content-type": "application/json",
    });
    final List<dynamic> dataJson = json.decode(response.body);
    print(response.body);
    return dataJson.map((json) => WalletHistoryModel.fromJson(json)).toList();
  }

  Future<List<PaymentLogModel>> fetchPaymentLogApi(
    String token,
  ) async {
    final response = await apiService.get(AppUrl.paymentLogUrl, headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    });
    final List<dynamic> dataJson = json.decode(response.body);
    print(response.body);
    return dataJson.map((json) => PaymentLogModel.fromJson(json)).toList();
  }

  Future<AvailbiltiModel> addMoneyApi(
      int amount, String token, bool isSuccess, BuildContext context) async {
    final response = await apiService.patch(
      AppUrl.addMoneyUrl,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: {'addMoney': amount, "isSuccess": isSuccess},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
     if(data['isSuccess'] == true){
       Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.WalletSuccessScreen,
        (route) => false,
      );
     }
    }
    return AvailbiltiModel.fromJson(json.decode(response.body));
  }

  Future<AvailbiltiModel> moneyDeductApi(
      String amount, userId, token, sessionId) async {
    final response = await apiService.patch(
      AppUrl.moneyDeductUrl + userId,
      headers: {
        "Content-type": "application/json",
        // "Authorization": "Bearer $token"
      },
      body: {'withdrawMoney': amount, "sessionId": sessionId},
    );

    print("sushil ${response.body}");
    return AvailbiltiModel.fromJson(json.decode(response.body));
  }

  Future<AvailbiltiModel> sessionCompleteApi(
    String sessionId,
  ) async {
    final response = await apiService.patch(
      AppUrl.completeStatusUrl + sessionId,
      headers: {
        "Content-type": "application/json",
      },
      body: {
        'isCompleted': true,
      },
    );

    print("sushilkumar ${response.body}");
    return AvailbiltiModel.fromJson(json.decode(response.body));
  }
}
