import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ventout/newFlow/services/sharedPrefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen10 extends ConsumerStatefulWidget {
  const SplashScreen10({super.key});

  @override
  ConsumerState<SplashScreen10> createState() => _SplashScreen10State();
}

class _SplashScreen10State extends ConsumerState<SplashScreen10> {
  String? token;
  String? id;

  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 1500), () {
      init();
    });
  }

  Future<void> init() async {
    await sharedPreferencesViewModel.initSharedPreference(context);
  }

  @override
  void dispose() {
    // Don't forget to dispose of the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset(
            "assets/img/AppIcon.png",
            width: width * .54,
            // height: height * .54,
            fit: BoxFit.cover,
          ),
        )));
  }
}
