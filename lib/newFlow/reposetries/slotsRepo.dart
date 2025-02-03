
import 'dart:convert';

import 'package:overcooked/newFlow/model/availableSlotsModel.dart';
import 'package:overcooked/newFlow/model/commissionValueModel.dart';
import 'package:overcooked/newFlow/services/app_url.dart';
import 'package:overcooked/newFlow/services/http_service.dart';

class SlotsRepo {
  final ApiService apiService;

  SlotsRepo(this.apiService);

  Future<AvailableSlotsModel?> fetchAvailableSlots(id) async {
    AvailableSlotsModel? availableSlotsModel;
    final response = await apiService.get("${AppUrl.availableSlotsApi}$id",
        headers: {"Content-type": "application/json"});
    availableSlotsModel = AvailableSlotsModel.fromJson(json.decode(response.body));
    return availableSlotsModel;
  }

  Future<CommissionValueModel?> fetchCommissionValue() async {
    CommissionValueModel? commissionValueModel;
    final response = await apiService.get("${AppUrl.commissionValueApi}",
        headers: {"Content-type": "application/json"});
    commissionValueModel = CommissionValueModel.fromJson(json.decode(response.body));
    return commissionValueModel;
  }

}