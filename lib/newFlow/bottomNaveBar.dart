import 'dart:async';
import 'dart:io';
import 'package:app_version_update/app_version_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:overcooked/newFlow/screens/questionsScreen/questionsTestScreen.dart';
import 'package:overcooked/newFlow/viewModel/walletViewModel.dart';
import 'package:overcooked/newFlow/widgets/cancelConfirmationDialog.dart';
import 'package:overcooked/newFlow/widgets/ratingDialog.dart';
import 'package:provider/provider.dart';
import 'package:overcooked/Utils/assetConstants.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/newFlow/homeScreen.dart';
import 'package:overcooked/newFlow/model/singleSessionModel.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/viewModel/homeViewModel.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilViewModel.dart';
import 'package:overcooked/newFlow/widgets/bookingBottomBar.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomNavBarView extends StatefulWidget {
  bool? isFilter;
  String? sortByFee, categories, language;
  int? index;
  BottomNavBarView(
      {Key? key,
      this.isFilter,
      this.categories,
      this.language,
      this.sortByFee,
      this.index})
      : super(key: key);

  @override
  State<BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<BottomNavBarView> {
  late PageController _controller;
  Stream<List<SingleSessionModel>>? _singleSessionStream;
  bool _wasSessionPresent = false;
  bool _dialogShown = false;

  int currentIndex = 0;
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();
  String? userId, token;
  bool? freeStatus;
  int? appId;
  String? patientId, amount, sessionId, duration;

  void getData() async {
    patientId = await sharedPreferencesViewModel.getTPatientId();
    amount = await sharedPreferencesViewModel.getAmount();
    sessionId = await sharedPreferencesViewModel.getSessionId();
    duration = await sharedPreferencesViewModel.getSessionDuration();
    setState(() {});

    print('Patient ID: $patientId');
    print('Amount: $amount');
    print('Session ID: $sessionId');
    print('Duration: $duration');
  }

  int selectedIndex = 0;

  final screens = [
    Text("Home"),
    Text("Schedule"),
    //Text("Story")
  ];

  final List<Map<String, dynamic>> bottomNavigationList = [
    {
      "name": "Home",
      "icons": AppAssets.homeOutline,
      "selectedIcon": AppAssets.homeFilled
    },
    // {
    //   "name": "Chat",
    //   "icons": AppAssets.chatIcon,
    //   "selectedIcon": AppAssets.chatfillIcon
    // },
    {
      "name": "Screening",
      "icons": AppAssets.outtestIcon,
      "selectedIcon": AppAssets.testIcon
    },

    // {
    //   "name": "Session",
    //   "icons": AppAssets.sessionOutline,
    //   "selectedIcon": AppAssets.sessionFilled
    // },
  ];

  @override
  void initState() {
    super.initState();
    _verifyVersion();
    final getUtilsData = Provider.of<UtilsViewModel>(context, listen: false);

    getUtilsData.zegoCloudeApis();
    getData();
    if (widget.index != null) {
      currentIndex = widget.index!;
    }

    final getSessionData =
        Provider.of<SessionViewModel>(context, listen: false);

    Future.wait([sharedPreferencesViewModel.getFreeStatus()]).then((value) {
      freeStatus = value[0];

      print("sl ${freeStatus}");
    });
    Future.wait([
      sharedPreferencesViewModel.getToken(),
      sharedPreferencesViewModel.getUserId(),
      sharedPreferencesViewModel.getTherapistId(),
      sharedPreferencesViewModel.getUserName(),
      sharedPreferencesViewModel.getSignUpToken(),
      sharedPreferencesViewModel.getAppId(),
      sharedPreferencesViewModel.getSecretKey(),
    ]).then((value) {
      userId = value[1];
      token = value[0];
      if (value[5] == null) {
        print('AppId is null');
      } else {
        appId = int.tryParse(value[5].toString());
        print('Parsed AppId: $appId');
      }
      print("############## ${appId} ${value[5]}");

      _singleSessionStream =
          getSessionData.singleSessionStream(value[1].toString());

      setState(() {
        _singleSessionStream =
            getSessionData.singleSessionStream(value[1].toString());
      });
    });

    _controller =
        PageController(initialPage: widget.index == null ? 0 : widget.index!)
          ..addListener(_onPageChange);

    // _verifyVersion();
  }

  void _onPageChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          currentIndex = _controller.page!.round();
        });
      }
    });
  }

  void _verifyVersion() async {
    await AppVersionUpdate.checkForUpdates(
            playStoreId: 'com.ventout.gossip_mark', appleId: '6741849037')
        .then((result) async {
      print(result.storeUrl);
      print(result.storeVersion);
      if (result.canUpdate!) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppVersionUpdate.showAlertUpdate(
            appVersionResult: result,
            context: context,
            backgroundColor: Colors.grey[200],
            title: 'New version available',
            titleTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 24.0),
            content: 'Would you like to update your application?',
            contentTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            updateButtonText: 'UPDATE',
            cancelButtonText: 'UPDATE LATER',
          );
        });
      }
    });
  }

  final iconList = <IconData>[
    Icons.brightness_5,
    Icons.brightness_4,
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: () async {
          final didPop = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Are you sure?',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter'),
              ),
              content: Text(
                'Do You Want To Exit The App',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter'),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          width: width * 0.25,
                          height: height * 0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: const Center(
                              child: Text(
                            'No',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          exit(0);
                        },
                        child: Container(
                          width: width * 0.25,
                          height: height * 0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: const Center(
                              child: Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
          return didPop ?? false;
        },
        child: Column(
          children: [
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    currentIndex = value;
                    print(currentIndex);
                  });
                },
                children: [
                  HomePage(
                    isFilter: widget.isFilter,
                    categories: widget.categories,
                    language: widget.language,
                    sortByFee: widget.sortByFee,
                  ),

                  QuestionsTestScreen()

                  // CallScreenPage(
                  //   isFilter: widget.isFilter,
                  //   categories: widget.categories,
                  //   language: widget.language,
                  //   sortByFee: widget.sortByFee,
                  // ),
                ],
              ),
            ),
            StreamBuilder<List<SingleSessionModel>>(
              stream: _singleSessionStream,
              builder: (context, snapshot) {
                if (_wasSessionPresent &&
                    snapshot.hasData &&
                    snapshot.data!.isEmpty &&
                    !_dialogShown) {
                  _dialogShown = true;
                  Future.delayed(Duration.zero, () async {
                    String? therapistId =
                        await sharedPreferencesViewModel.getTherapistId();
                    final walletModel =
                        Provider.of<WalletViewModel>(context, listen: false);
                    walletModel.fetchWalletBalanceAPi(token ?? '');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return RatingDialog(
                          therapist: therapistId ?? '',
                          token: token.toString(),
                        );
                      },
                    );
                  });
                }

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  _dialogShown = false;
                }
                _wasSessionPresent =
                    snapshot.hasData && snapshot.data!.isNotEmpty;

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SizedBox.shrink();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var items = snapshot.data!.toList();
                    sharedPreferencesViewModel
                        .saveTherapistId(items[index].therapistId.sId);
                    sharedPreferencesViewModel
                        .savePatientId(items.first.bookedBy!.sId);
                    sharedPreferencesViewModel
                        .saveAmount(items.first.fees.toString());
                    sharedPreferencesViewModel.saveSessionId(items.first.sId);
                    sharedPreferencesViewModel
                        .saveSessionDuration(items.first.timeDuration);
                    return GestureDetector(
                        onTap: () {
                          // if (items[index].bookingStatus ==
                          //         'Confirm' &&
                          //     items[index].bookingType ==
                          //         'Chat') {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ChatPage(
                          //       bookingStatus:
                          //           items[index].bookingStatus.toString(),
                          //       therapistCate:
                          //           items[index].therapistId!.name.toString(),
                          //       duration: items[index].timeDuration.toString(),
                          //       chatId: items[index].sId.toString(),
                          //       sessionId: items[index].sId.toString(),
                          //     ),
                          //   ),
                          // );
                          // }
                          _launchMeetLink(items[index].meetLink);
                        },
                        child: Consumer<HomeViewModel>(
                          builder: (context, value, child) =>
                              BookingBottomBarWidget(
                            bookingStatus: items[index].bookingStatus,
                            status: false,
                            name: items[index].therapistId.name.capitalizeFirst,
                            image:
                                items[index].therapistId!.profileImg.toString(),
                            callType: items[index].bookingType.toString(),
                            fee: "${items[index].fees.toStringAsFixed(2)}",
                            slot: items[index].slot.slot.isEmpty
                                ? "Therapist Will Contact you"
                                : "${items[index].slot.slot}",
                            day: items[index].slot.day.isEmpty
                                ? "Free Session"
                                : "${items[index].slot!.day}",
                            onCancelTap: () {
                              showConfirmationDialog(
                                context: context,
                                onConfirm: () {
                                  value
                                      .bookingStatusApis(token.toString(),
                                          'Cancel', items[index].sId, context)
                                      .then((values) {
                                    value.sessionCompleteApis(
                                        items[index].sId.toString(),
                                        true,
                                        context);
                                    _dialogShown = true;
                                    final getSessionData =
                                        Provider.of<SessionViewModel>(context,
                                            listen: false);
                                    getSessionData
                                        .refreshSessionData(userId.toString());
                                  });
                                },
                              );
                            },
                          ),
                        ));
                  },
                );
              },
            ),
          ],
        ),
      ),
      // floatingActionButton: Consumer<SessionViewModel> (
      //   builder: (context, value, child) => value.sessionDatas.isEmpty
      //       ? SizedBox.shrink()
      //       : Padding(
      //           padding: EdgeInsets.only(bottom: context.deviceHeight * .11),
      //           child: FloatingActionButton(
      //             backgroundColor: colorLightWhite,
      //             onPressed: () {
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) => ChatPage(
      //                       bookingStatus: value
      //                           .sessionDatas.first.bookingStatus
      //                           .toString(),
      //                       therapistCate: value
      //                           .sessionDatas.first.therapistId!.name
      //                           .toString(),
      //                       duration: value.sessionDatas.first.timeDuration
      //                           .toString(),
      //                       chatId: value.sessionDatas.first.sId.toString(),
      //                       sessionId:
      //                           value.sessionDatas.first.sId.toString(),
      //                     ),
      //                   ));
      //             },
      //             shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(50)),
      //             child: Icon(
      //               CupertinoIcons.chat_bubble_fill,
      //               size: 34,
      //               color: Colors.black,
      //             ),
      //           ),
      //         ),
      // ),

      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: darkModeTextLight2,
          onTap: (index) => setState(() {
                selectedIndex = index;
                if (selectedIndex == 0) {
                  _controller.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 20),
                    curve: Curves.easeIn,
                  );
                }
                // else if (selectedIndex == 1) {
                //   Get.to(
                //       ChatScreen(
                //         chatId: userId.toString(),
                //       ),
                //       transition: Transition.rightToLeft);
                // }
                else if (selectedIndex == 1) {
                  _controller.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 20),
                    curve: Curves.easeIn,
                  );
                }
              }),
          currentIndex: selectedIndex,
          elevation: 10,
          items: List.generate(bottomNavigationList.length, (index) {
            return BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4, top: 10),
                child: SvgPicture.asset(
                  height: 26,
                  (selectedIndex == index)
                      ? bottomNavigationList[index]["selectedIcon"]!
                      : bottomNavigationList[index]["icons"]!,
                  color:
                      (selectedIndex == index) ? colorLightWhite : colorDark3,
                ),
              ),
              label: bottomNavigationList[index]["name"].toString(),
              backgroundColor: colorLightWhite,
            );
          })),
    );
  }

  void _launchMeetLink(String meetLink) async {
    final Uri url = Uri.parse(meetLink);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $meetLink';
    }
  }
}
