import 'dart:io';
import 'dart:ui';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventout/Utils/responsive.dart';
import 'package:ventout/newFlow/homeScreen.dart';
import 'package:ventout/newFlow/routes/routeName.dart';
import 'package:ventout/newFlow/services/sharedPrefs.dart';
import 'package:ventout/newFlow/widgets/alertDialogTimer.dart';
import 'package:ventout/newFlow/widgets/color.dart';
import 'package:ventout/newFlow/widgets/ratingBottomSheetWidget.dart';

import 'package:ventout/newFlow/login/login.dart';
import 'package:ventout/newFlow/widgets/successFullWidget.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../Utils/components.dart';
import '../widgets/alertDialogWithouttimer.dart';

class UtilsClass {
  void showRatingBottomSheet(
      BuildContext context, int amount, String token, sessionTime) {
    showModalBottomSheet(
      context: context,
      backgroundColor: popupColor,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AmountAddSheet(
            sessionTime: sessionTime,
            token: token,
            amount: amount,
          ),
        );
      },
    );
  }

  // Dialog Box

  void showCustomDialog(
      BuildContext context,
      String fees,
      token,
      id,
      channelName,
      image,
      name,
      perMintFee,
      sessiontime,
      userId,
      targatedUserId,
      targatedUserName,
      bool isSessionScreen) {
    String? _selectedGender;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.black,
            contentPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.only(
                left: Platform.isAndroid ? 12 : 20,
                right: Platform.isAndroid ? 12 : 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: AlertDialogTimer(
              isSessionScreen: isSessionScreen,
              userId: userId,
              targatedUserId: targatedUserId,
              targatedUserName: targatedUserName,
              sessiontime: sessiontime,
              fees: fees,
              token: token,
              id: id,
              channelName: channelName,
              image: image,
              name: name,
              perMintFee: perMintFee,
            ));
      },
    );
  }
  // Dialog Box Without timer

  void showDialogWithoutTimer(
      BuildContext context,
      String fees,
      token,
      id,
      channelName,
      image,
      name,
      perMintFee,
      sessiontime,
      userId,
      targatedUserId,
      targatedUserName,
      VoidCallback onTap,
      bool isSessionScreen) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.black,
            contentPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.only(
                left: Platform.isAndroid ? 12 : 20,
                right: Platform.isAndroid ? 12 : 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: AlertDialogWithoutTimer(
              isSessionScreen: isSessionScreen,
              userId: userId,
              targatedUserId: targatedUserId,
              targatedUserName: targatedUserName,
              sessionTime: sessiontime,
              channelName: channelName,
              fees: fees,
              id: id,
              image: image,
              name: name,
              perMintFee: perMintFee,
              token: token,
            ));
      },
    );
  }

  void showDialogForSuccessfulBooking(
      BuildContext context,
      String image,
      name,
      bookingType,
      userId,
      targatedUserId,
      targatedUserName,
      bool isSessionScreen,
      VoidCallback onTap) {
    String? _selectedGender;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.black,
            contentPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.only(
                left: Platform.isAndroid ? 12 : 20,
                right: Platform.isAndroid ? 12 : 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: SuccessfullWidget(
              isSessionScreen: isSessionScreen,
              userId: userId,
              targatedUserName: targatedUserName,
              targatedUserId: targatedUserId,
              image: image,
              name: name,
              onTap: onTap,
              bookingType: bookingType,
            ));
      },
    );
  }

  // ------------ Setting Card ====

  void showSettingCard(BuildContext context, String amount) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SharedPreferencesViewModel sharedPreferencesViewModel =
        SharedPreferencesViewModel();
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              height: height * .42,
              decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Image.asset(
                          width: width * 0.082,
                          height: height * 0.015,
                          'assets/img/Rectangle.png'),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: settingCard(
                        icon0: const Icon(
                          Icons.wallet,
                          size: 26,
                          color: Colors.white,
                        ),
                        width: width,
                        text: 'Wallet History',
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RoutesName.WalletHistoryScreen,
                              arguments: {'balance': amount});
                        },
                      ),
                    ),
                    const Divider(
                        indent: 10,
                        color: Colors.black12,
                        height: 0.2,
                        endIndent: 10),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: SizedBox(
                        width: width * 0.9,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: width * 0.02),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutesName.SessionHistoryScreen);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(1),
                                  width: width * 0.9,
                                  // constraints: BoxConstraints(minHeight: width * 0.08),
                                  decoration: const BoxDecoration(
                                    //  color: color,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(18),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: width * 0.03),
                                      SvgPicture.asset(
                                        'assets/img/sessionHistory.svg',
                                        height: 24,
                                      ),
                                      SizedBox(width: width * 0.05),
                                      const Text(
                                        'Session History',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const Spacer(),
                                      // IconButton(onPressed: onPressed,
                                      //    // icon: icon
                                      // )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                        indent: 10,
                        color: Colors.black12,
                        height: 0.2,
                        endIndent: 10),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: settingCard(
                        icon0: const Icon(
                          CupertinoIcons.exclamationmark_circle_fill,
                          size: 26,
                          color: Colors.white,
                        ),
                        width: width,
                        text: 'Privacy Policy',
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RoutesName.PrivacyPolicyScreen);
                        },
                      ),
                    ),
                    const Divider(
                        indent: 10,
                        color: Colors.black12,
                        height: 0.2,
                        endIndent: 10),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: settingCard(
                        icon0: const Icon(
                          Icons.menu_book_rounded,
                          size: 26,
                          color: Colors.white,
                        ),
                        width: width,
                        text: 'Term & Condition',
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RoutesName.TermAndConditionScreen);
                        },
                      ),
                    ),
                    const Divider(
                        indent: 10,
                        color: Colors.black12,
                        height: 0.2,
                        endIndent: 10),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: settingCard(
                        icon0: const Icon(
                          CupertinoIcons.question_circle_fill,
                          size: 26,
                          color: Colors.white,
                        ),
                        width: width,
                        text: 'Help',
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesName.HelpScreen);
                        },
                      ),
                    ),
                    Divider(
                      color: Colors.black.withOpacity(.15),
                    ),
                    // SizedBox(
                    //   height: 4,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 0),
                      child: GestureDetector(
                        onTap: () {
                          sharedPreferencesViewModel.logout().then((value) {
                            ZegoUIKitPrebuiltCallInvitationService().uninit();
                            Navigator.pushNamedAndRemoveUntil(context,
                                RoutesName.LoginScreen, (route) => false);
                          });
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.logout,
                                color: Color(0xFFFF0000), size: 26),
                            SizedBox(
                              width: 26,
                            ),
                            Text(
                              'Logout',
                              style: TextStyle(
                                  color: Color(0xFFFF0000),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Center(
                    //   child: InkWell(
                    //     onTap: () {
                    //       ref
                    //           .watch(stateclassController)
                    //           .logout();
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) =>
                    //                   const LoginScreen()));
                    //     },
                    //     child: Container(
                    //         padding: const EdgeInsets.all(1),
                    //         width: width * 0.9,
                    //         constraints: BoxConstraints(
                    //             minHeight: width * 0.12),
                    //         decoration: const BoxDecoration(
                    //           color: Colors.black12,
                    //           borderRadius: BorderRadius.all(
                    //             Radius.circular(18),
                    //           ),
                    //         ),
                    //         child: const Center(
                    //             child: Text(
                    //           'Logout',
                    //           style: TextStyle(
                    //               color: Color(0xFFFF0000),
                    //               fontWeight: FontWeight.w500,
                    //               fontSize: 16),
                    //         ))),
                    //   ),
                    // ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}






// 