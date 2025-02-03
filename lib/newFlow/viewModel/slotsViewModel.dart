import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overcooked/newFlow/model/availableSlotsModel.dart';
import 'package:overcooked/newFlow/model/commissionValueModel.dart';
import 'package:overcooked/newFlow/reposetries/slotsRepo.dart';

class SlotsViewModel with ChangeNotifier {
  final SlotsRepo slotsRepo;

  SlotsViewModel(this.slotsRepo);

  bool isLoading = false;
  bool allSlotsLoading = false;
  bool slotsByDayLoading = true;
  bool availableSlotsLoading = true;
  bool updateSlotsLoading = false;
  bool commissionValueLoading = false;
  bool updateAllSlotsAvailableLoading = false;
  bool isAllSlotsAvailable = false;
  int? commissionValue;
  String? slotId = "";

  int daysTappedIndex = 0;

  AvailableSlotsModel? availableSlotsData;
  CommissionValueModel? commissionValueData;

  List<Map<String, dynamic>> days = [
    {
      "day": "Mon",
      "key": "Monday"
    },
    {
      "day": "Tue",
      "key": "Tuesday"
    },
    {
      "day": "Wed",
      "key": "Wednesday"
    },
    {
      "day": "Thu",
      "key": "Thursday"
    },
    {
      "day": "Fri",
      "key": "Friday"
    },
    {
      "day": "Sat",
      "key": "Saturday"
    },
    {
      "day": "Sun",
      "key": "Sunday"
    },

  ];


  setAvailableSlotsLoading(bool value) {
    availableSlotsLoading = value;
    notifyListeners();
  }

  setCommissionValueLoading(bool value) {
    commissionValueLoading = value;
    notifyListeners();
  }


  updateIndex(index) {
    daysTappedIndex = index;
    notifyListeners();
  }

  updateSlotId(id) {
    slotId = id;
    notifyListeners();
  }

  // Future<void> fetchAllSlotsAPi() async {
  //   try {
  //     setAllSlotsLoading(true);
  //     allSlotsData = await slotsRepo.fetchAllSlots();
  //
  //     allSlotsData!.data!.forEach((value){
  //       if(value.day == "Monday"){
  //         allSlots["Monday"]!.add(value);
  //       }else if(value.day == "Tuesday"){
  //         allSlots["Tuesday"]!.add(value);
  //       }else if(value.day == "Wednesday"){
  //         allSlots["Wednesday"]!.add(value);
  //       }else if(value.day == "Thursday"){
  //         allSlots["Thursday"]!.add(value);
  //       }else if(value.day == "Friday"){
  //         allSlots["Friday"]!.add(value);
  //       }else if(value.day == "Saturday"){
  //         allSlots["Saturday"]!.add(value);
  //       }else if(value.day == "Sunday"){
  //         allSlots["Sunday"]!.add(value);
  //       }
  //     });
  //
  //     notifyListeners();
  //     setAllSlotsLoading(false);
  //   } catch (error) {
  //     setAllSlotsLoading(false);
  //     print(error);
  //   }
  // }

  List<AvailableSlots?> availableSlotsList = [];

  Future<void> fetchAvailableSlotsAPi(id, day) async {
    try {
      setAvailableSlotsLoading(true);
      availableSlotsData = await slotsRepo.fetchAvailableSlots(id);
      isAllSlotsAvailable = availableSlotsData!.slotAvailability!;
      availableSlotsList = [];
      availableSlotsData!.availableSlots!.forEach((value){
        if(value.day == day){
          availableSlotsList.add(value);
        }
      });
      notifyListeners();
      setAvailableSlotsLoading(false);
    } catch (error) {
      setAvailableSlotsLoading(false);
      print("${error} available slots");
    }
  }

  Future<void> fetchCommissionValueAPi() async {
    try {
      setCommissionValueLoading(true);

      commissionValueData = await slotsRepo.fetchCommissionValue();

      commissionValue = int.parse(commissionValueData!.data![0].userCommission!.toString());

      print("this is commision value $commissionValue");

  
      notifyListeners();
      setCommissionValueLoading(false);
    } catch (error) {
      print("this is error new new ${error}");
      setCommissionValueLoading(false);
    }
  }

}
