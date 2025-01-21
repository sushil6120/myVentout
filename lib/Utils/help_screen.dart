import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ventout/newFlow/reportScreen.dart';
import 'package:ventout/newFlow/services/sharedPrefs.dart';

import '../Utils/colors.dart';
import '../newFlow/viewModel/utilViewModel.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();
  String? token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.wait([
      sharedPreferencesViewModel.getToken(),
      sharedPreferencesViewModel.getUserId()
    ]).then((value) {
      print(value[0]);
      token = value[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ListTile(
                onTap: () {
                  Get.to(ReportProblemScreen());
                },
                title: Text(
                  "Report a problem",
                  style: GoogleFonts.inter(color: colorLightWhite),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              ),
              ListTile(
                onTap: () {
                  _showAlertDialog(context);
                },
                title: Text(
                  "Delete Account",
                  style: GoogleFonts.inter(color: colorLightWhite),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                ),
              ),
            ],
          ),
          // Container(
          //   width: width,
          //   height: height,
          //   decoration: BoxDecoration(color: Colors.black.withOpacity(.6)),
          //   child: Center(
          //     child: CircularProgressIndicator(color: Colors.white),
          //   ),
          // )
        ],
      ),
    );
  }

  Future<void> _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dialog dismissal on outside tap
      builder: (BuildContext context) {
        return Consumer<UtilsViewModel>(
          builder: (context, value, child) {
            return AlertDialog(
              backgroundColor: colorDark1,
              title: Text(
                'Delete Account',
                style: GoogleFonts.inter(color: colorLightWhite),
              ),
              content: Text(
                'Do you want to proceed?',
                style: GoogleFonts.inter(color: colorLightWhite),
              ),
              actions: <Widget>[
                value.isLoading == true
                    ? LoadingAnimationWidget.waveDots(
                        color: Colors.white, size: 30)
                    : TextButton(
                        onPressed: () {
                          value.deleteApis(token.toString(), context);
                          sharedPreferencesViewModel.logout();
                        },
                        child: Text(
                          'Yes',
                          style: GoogleFonts.inter(color: colorLightWhite),
                        ),
                      ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    print('User clicked No');
                  },
                  child: Text(
                    'No',
                    style: GoogleFonts.inter(color: colorLightWhite),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
