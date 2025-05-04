import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:overcooked/newFlow/login/consentScreen.dart';
import 'package:overcooked/newFlow/model/therapistProfileModel.dart';
import 'package:overcooked/newFlow/reposetries/authRepo.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';

import '../../Utils/utilsFunction.dart';
import '../services/sharedPrefs.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepo authRepo;
  AuthViewModel(this.authRepo);

  bool isLoading = false;
  bool profileLoading = false;

  TherapistProfileModel? therapistProfileModel;

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setProfileLoading(bool value) {
    profileLoading = value;
    notifyListeners();
  }

  Future<void> sendOtpApis(String phone, BuildContext context) async {
    try {
      setLoading(true);
      final newData = await authRepo.sendOtpApi(phone);
      print("Otp : ${newData.otp}");
      setLoading(false);
      if (newData.otp != null) {
        Navigator.pushNamed(context, RoutesName.OtpScreen,
            arguments: {'mobile': phone});
      }
      Utils.toastMessage(newData.message.toString());
      // Utils.toastMessage(newData.otp.toString());

      print(newData.message);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> otpVerifyApis(String phone, otp, BuildContext context) async {
    SharedPreferencesViewModel sharedPreferencesViewModel =
        SharedPreferencesViewModel();
    try {
      setLoading(true);
      final newData = await authRepo.otpVerifyApi(phone, otp, context);
      if (newData.isRegistered == false) {
        sharedPreferencesViewModel.saveSignUpToken(newData.token);
        sharedPreferencesViewModel.saveUserId(newData.userId);
        sharedPreferencesViewModel
            .saveUserName(newData.name == null ? 'Name' : newData.name);
        sharedPreferencesViewModel.saveFreeStatus(newData.freeStatus);
        Navigator.pushNamed(context, RoutesName.genderSelectionScreen,
            arguments: {'name': ""});
      } else {
        sharedPreferencesViewModel.saveToken(newData.token);
        sharedPreferencesViewModel.saveUserId(newData.userId);
        sharedPreferencesViewModel.saveUserName(newData.name);
        sharedPreferencesViewModel.saveFreeStatus(newData.freeStatus);
        print(newData.token);
        Navigator.pushNamed(
          context,
          RoutesName.bottomNavBarView,
        );
      }
      setLoading(false);

      Utils.toastMessage(newData.message.toString());

      print(newData.message);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> registerationApis(
      String name, age, gender, token, BuildContext context) async {
    try {
      setLoading(true);
      final newData = await authRepo.registrationApi(name, age, gender, token);

      setLoading(false);
      if (newData.message == 'User registered successfully!') {
        Get.to(ConsentScreen(name: "$name"),
            transition: Transition.rightToLeft);
      }

      Utils.toastMessage(newData.message.toString());
      print(newData.message);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> prefrencesApis(
      String token, var defaultQnA, BuildContext context) async {
    try {
      setLoading(true);
      final newData = await authRepo.prefrencesApi(token, defaultQnA, context);
      setLoading(false);
      Utils.toastMessage(newData.message.toString());
      print(newData.message);
    } catch (error) {
      setLoading(false);
      print(error);
    }
  }

  Future<void> fetchTherapistProfileAPi(String Id) async {
    try {
      setProfileLoading(true);

      therapistProfileModel = await authRepo.fetchTherapistProfile(Id);

      notifyListeners();
      setProfileLoading(false);
      print(therapistProfileModel!.language);
    } catch (error) {
      setProfileLoading(false);
      print(error);
    }
  }
}
