import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overcooked/main.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesViewModel with ChangeNotifier {
  String? userToken;
  String? workerToken;
  String? userId;
  String? workerId;

  saveToken(String? token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('token', token!);
  }

  saveFreeStatus(bool? value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('freeStatus', value!);
  }
  saveDialogStatus(bool? value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('saveDialogStatus', value!);
  }

  saveTherapistId(String? therapistId) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('therapistId', therapistId!);
  }
    savePatientId(String? token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('PatientId', token!);
  }

  saveAmount(String? token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('amount', token!);
  }

  saveSessionId(String? token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('sessionId', token!);
  }
  saveAppId(String? token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('appId', token!);
  }
  saveSecreytKey(String? token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('secretKey', token!);
  }

  saveSessionDuration(String? token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('duration', token!);
  }

  saveUserId(String? token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('userId', token!);
  }

  Future<String?> getToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('token');
    return token;
  }
  Future<String?> getAppId() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('appId');
    return token;
  }
  Future<String?> getSecretKey() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('secretKey');
    return token;
  }

  Future<bool?> getFreeStatus() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final bool? token = sp.getBool('freeStatus');
    return token;
  }
  Future<bool?> getDialogStatus() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final bool? token = sp.getBool('saveDialogStatus');
    return token;
  }

  Future<String?> getTherapistId() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('therapistId');
    return token;
  }

   Future<String?> getSessionDuration() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('duration');
    return token;
  }

  Future<String?> getSessionId() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('sessionId');
    return token;
  }

  Future<String?> getAmount() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('amount');
    return token;
  }

  Future<String?> getTPatientId() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('PatientId');
    return token;
  }

  Future<String?> getUserId() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('userId');
    return token;
  }

  saveProfileImage(String? token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('profileImage', token!);
  }

  saveUserName(String? token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('name', token!);
  }
  saveUserNumber(String? token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('saveUserNumber', token!);
  }

  saveSignUpToken(String? token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('signUp', token!);
  }

  Future<String?> getProfileImage() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('profileImage');
    return token;
  }

  Future<String?> getUserName() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('name');
    return token;
  }
  Future<String?> getUserNumber() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('saveUserNumber');
    return token;
  }

  Future<String?> getSignUpToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? token = sp.getString('signUp');
    return token;
  }

  saveIsInstalled(bool? isInstalled) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('isInstalled', isInstalled!);
  }

  Future<bool?> getIsInstalled() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final bool? isInstalled = sp.getBool('isInstalled');
    return isInstalled;
  }

  saveID(String? id) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('id', id!);
  }

  Future<String?> getID() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? id = sp.getString('id');
    return id;
  }

  saveUsername(String? username) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('username', username!);
  }

  saveUserDetails(String? username, String? firstname, String? lastname,
      String? bio, String? image, String? email) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('username', username!);
    sp.setString('firstname', firstname!);
    sp.setString('lastname', lastname!);
    sp.setString('bio', bio!);
    sp.setString('image', image!);
    sp.setString("email", email!);
  }

  saveEnterDetails(
      String? username, String? firstname, String? lastname) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('username', username!);
    sp.setString('firstname', firstname!);
    sp.setString('lastname', lastname!);
  }

  saveImage(String? image) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('image', image!);
  }

  saveBio(String? bio) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('bio', bio!);
  }

  saveEmail(String? email) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('email', email!);
  }

  Future<String?> getUsername() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? username = sp.getString('username');
    return username;
  }

  Future<String?> getFirstname() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? firstname = sp.getString('firstname');
    return firstname;
  }

  Future<String?> getLastname() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? lastname = sp.getString('lastname');
    return lastname;
  }

  Future<String?> getBio() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? bio = sp.getString('bio');
    return bio;
  }

  Future<String?> getEmail() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? bio = sp.getString('email');
    return bio;
  }

  Future<String?> getImage() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    final String? image = sp.getString('image');
    return image;
  }

  saveS3Bucket(
      String? bucketName, String? poolId, String? region, String? path) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('bucketName', bucketName!);
    sp.setString('poolId', poolId!);
    sp.setString('region', region!);
    sp.setString('path', path!);
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.clear();
  }

  Future<bool> removeToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.remove("token");
  }

  Future<bool> removeSignUpToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.remove("signUp");
  }

  Future<void> initSharedPreference(BuildContext context) async {
    preferences = await SharedPreferences.getInstance();
    getSharedPreference();
    if (userToken != null && userToken!.isNotEmpty) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.bottomNavBarView, (route) => false);
      return;
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.LoginScreen, (route) => false);
    }
  }

  Future<void> getSharedPreference() async {
    userToken = preferences?.getString('token') ?? '';

    userId = preferences?.getString('userId') ?? '';
  }

  Future<void> logout() async {
    await preferences?.clear();
    userToken = '';
    userId = '';
    workerId = '';
    workerToken = '';
    notifyListeners();
  }
}
