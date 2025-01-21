import 'package:flutter/material.dart';
import 'package:ventout/newFlow/model/categoryModel.dart';
import 'package:ventout/newFlow/services/sharedPrefs.dart';

import '../model/reviewModel.dart';
import '../reposetries/utilsRepo.dart';

class UtilsViewModel with ChangeNotifier {
  final UtilsRepo utilsRepo;

  UtilsViewModel(this.utilsRepo);

  String selectedLanguage = '';
  String selectedExpertise = '';
  String selectedSort = '';
  String selectedSessionLanguage = '';
  String selectedSessionExpertise = '';
  String selectedSessionSort = '';

  List<CategoryModel> _dataList = [];
  List<ReviewModel> reviewList = [];

  List<CategoryModel> get dataList => _dataList;
  bool isLoading = false;

  setResetvalue() {
    selectedLanguage = '';
    selectedExpertise = '';
    selectedSort = '';
    selectedSessionLanguage = '';
    selectedSessionExpertise = '';
    selectedSessionSort = '';
    notifyListeners();
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setLanguage(String value) {
    selectedLanguage = value;
    notifyListeners();
  }

  setExpertise(String value) {
    selectedExpertise = value;
    notifyListeners();
  }

  setSort(String value) {
    selectedSort = value;
    notifyListeners();
  }

  setSessionLanguage(String value) {
    selectedSessionLanguage = value;
    notifyListeners();
  }

  setSessionexpertise(String value) {
    selectedSessionExpertise = value;
    notifyListeners();
  }

  setSessionSort(String value) {
    selectedSessionSort = value;
    notifyListeners();
  }

  Future<void> fetchCategoryAPi() async {
    try {
      _dataList = await utilsRepo.fetchCategory();

      notifyListeners();

      print(_dataList);
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchReViewAPi(String therapistId) async {
    try {
      setLoading(true);
      reviewList = await utilsRepo.fetchReview(therapistId);

      notifyListeners();
      setLoading(false);
      print(_dataList);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> sendNotificationApis(
      String sessionid, BuildContext context) async {
    try {
      setLoading(true);
      final newData = await utilsRepo.sendNotificationApi(
        sessionid,
      );

      setLoading(false);

      print("${newData.callerName}==========");
    } catch (error) {
      setLoading(false);

      print('Error: $error');
    }
  }

  Future<void> deleteApis(String token, BuildContext context) async {
    setLoading(true);
    try {
      final newData = await utilsRepo.deleteApi(token, context);
      setLoading(false);
    } catch (error) {
      setLoading(false);
      print('Error: $error');
    }
  }

  Future<void> reportApis(
      String token, title, description, BuildContext context) async {
    setLoading(true);
    try {
      final newData = await utilsRepo.reportApi(token, title, description);
      setLoading(false);
    } catch (error) {
      setLoading(false);
      print('Error: $error');
    }
  }

  Future<void> zegoCloudeApis() async {
    SharedPreferencesViewModel sharedPreferencesViewModel =
        SharedPreferencesViewModel();
    try {
      final newData = await utilsRepo.fetchZegoCloudeApi();
     
      sharedPreferencesViewModel.saveAppId(newData.zegoCloud!.first.appId.toString());
      sharedPreferencesViewModel
          .saveSecreytKey(newData.zegoCloud!.first.secretKey);
    } catch (error) {
      print('Error: $error');
    }
  }
}
