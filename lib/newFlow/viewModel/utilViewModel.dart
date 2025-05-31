import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:overcooked/newFlow/model/categoryModel.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';

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

  Future<void> checkForUpdates() async {
    AppUpdateInfo? updateInfo = await InAppUpdate.checkForUpdate();
    if (kDebugMode) {
      print("Update Info : $updateInfo");
    }
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      _showUpdateDialog();
    }
  }

  void _showUpdateDialog() {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.black,
      title: const Text(
        'Update Available',
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        'A new update is available. Do you want to update?',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Get.back();
            InAppUpdate.performImmediateUpdate();
          },
          child: const Text(
            'Update',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'Later',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ));
  }

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

  Future<void> sendNotificationApis(String userId, BuildContext context) async {
    try {
      await utilsRepo.sendNotificationApi(
        userId,
      );

   
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

      sharedPreferencesViewModel
          .saveAppId(newData.zegoCloud!.first.appId.toString());
      sharedPreferencesViewModel
          .saveSecreytKey(newData.zegoCloud!.first.secretKey);
    } catch (error) {
      print('Error: $error');
    }
  }
}
