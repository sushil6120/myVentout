import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ventout/Utils/colors.dart';
import 'package:ventout/Utils/responsive.dart';
import 'package:ventout/newFlow/callScreen.dart';
import 'package:ventout/newFlow/callScreens/chatScreen.dart';
import 'package:ventout/newFlow/homeScreen.dart';
import 'package:ventout/newFlow/model/singleSessionModel.dart';
import 'package:ventout/newFlow/routes/routeName.dart';
import 'package:ventout/newFlow/services/sharedPrefs.dart';
import 'package:ventout/newFlow/viewModel/homeViewModel.dart';
import 'package:ventout/newFlow/viewModel/sessionViewModel.dart';
import 'package:ventout/newFlow/viewModel/utilViewModel.dart';
import 'package:ventout/newFlow/widgets/bookingBottomBar.dart';
import 'package:ventout/newFlow/widgets/ratingDialog.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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

  @override
  void initState() {
    super.initState();
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
      ZegoUIKitPrebuiltCallInvitationService().init(
          appID: appId!,
          appSign: value[6].toString(),
          userID: value[1].toString(),
          userName: value[3].toString(),
          plugins: [ZegoUIKitSignalingPlugin()],
          uiConfig: ZegoCallInvitationUIConfig(
              inviter: ZegoCallInvitationInviterUIConfig(
            showAvatar: false,
            backgroundBuilder: (context, size, info) {
              return Container(
                width: context.deviceWidth,
                height: context.deviceHeight,
                color: Colors.black,
              );
            },
          )),
          requireConfig: (ZegoCallInvitationData data) {
            var config = (data.invitees.length > 1)
                ? ZegoCallType.videoCall == data.type
                    ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                    : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
                : ZegoCallType.videoCall == data.type
                    ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                    : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
            config.avatarBuilder = (BuildContext context, Size size,
                ZegoUIKitUser? user, Map extraInfo) {
              if (user != null && user.id == value[1].toString()) {
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 80,
                  child: Text(
                    user.name.toString()[0].toUpperCase(),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: colorDark1),
                  ),
                );
                ;
              } else {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        data.customData,
                      ),
                    ),
                  ),
                );
              }
            };
            return config;
          },
          notificationConfig: ZegoCallInvitationNotificationConfig(
            androidNotificationConfig: ZegoCallAndroidNotificationConfig(
                vibrate: true,
                certificateIndex:
                    ZegoSignalingPluginMultiCertificate.firstCertificate),
          ),
          events: ZegoUIKitPrebuiltCallEvents(
            onHangUpConfirmation: (event, defaultAction) {
              getData();
              final getsessionData =
                  Provider.of<SessionViewModel>(context, listen: false);
              getsessionData.updateSessionTimeApi(
                  sessionId.toString(), '', DateTime.now());
              return defaultAction();
            },
            onCallEnd: (event, defaultAction) {
              getData();
              final getsessionData =
                  Provider.of<SessionViewModel>(context, listen: false);
              getsessionData.updateSessionTimeApi(
                  sessionId.toString(), '', DateTime.now());
              final getHomeData =
                  Provider.of<HomeViewModel>(context, listen: false);
              getHomeData.fetchWalletBalanceAPi(
                  token == null ? value[4].toString() : token.toString());
              if (freeStatus == true) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.bottomNavBarView,
                  (route) => false,
                );
              } else {
                Future.delayed(const Duration(milliseconds: 100), () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RatingDialog(
                        therapist: value[2],
                        token: value[0].toString(),
                      );
                    },
                  );
                });
              }

              return defaultAction();
            },
          ),
          invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
            onError: (p0) {
              print('onError: $p0');
            },
            onIncomingCallAcceptButtonPressed: () {
              print('Accepted 8888888');
              final getsessionData =
                  Provider.of<SessionViewModel>(context, listen: false);
              getsessionData.updateSessionTimeApi(
                  sessionId.toString(), DateTime.now(), '');
            },
            onOutgoingCallAccepted: (callID, callee) {
              getData();
              final getsessionData =
                  Provider.of<SessionViewModel>(context, listen: false);
              getsessionData.updateSessionTimeApi(
                  sessionId.toString(), DateTime.now(), '');
              int? dura = int.tryParse(duration!);
              print('Animal $dura');
              Timer(
                Duration(minutes: dura!),
                () {
                  Navigator.pop(context);
                },
              );
            },
          ));
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

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Exit'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // void _verifyVersion() async {
  //   await AppVersionUpdate.checkForUpdates(
  //     playStoreId: 'com.ventout.gossip_mark',
  //   ).then((result) async {
  //     print(result.storeUrl);
  //     print(result.storeVersion);
  //     if (result.canUpdate!) {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         AppVersionUpdate.showAlertUpdate(
  //           appVersionResult: result,
  //           context: context,
  //           backgroundColor: Colors.grey[200],
  //           title: 'New version available',
  //           titleTextStyle: const TextStyle(
  //               color: Colors.black,
  //               fontWeight: FontWeight.w600,
  //               fontSize: 24.0),
  //           content: 'Would you like to update your application?',
  //           contentTextStyle: const TextStyle(
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //           ),
  //           updateButtonText: 'UPDATE',
  //           cancelButtonText: 'UPDATE LATER',
  //         );
  //       });
  //     }
  //   });
  // }

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
                    CallScreenPage(
                      isFilter: widget.isFilter,
                      categories: widget.categories,
                      language: widget.language,
                      sortByFee: widget.sortByFee,
                    ),
                  ],
                ),
              ),
              StreamBuilder<List<SingleSessionModel>>(
                stream: _singleSessionStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty ||
                      snapshot.data == null) {
                    return const SizedBox.shrink();
                  } else if (snapshot.hasData) {
                    List<SingleSessionModel> items = snapshot.data!.toList();

                    sharedPreferencesViewModel
                        .savePatientId(items.first.bookedBy!.sId);
                    sharedPreferencesViewModel
                        .saveAmount(items.first.fees.toString());
                    sharedPreferencesViewModel.saveSessionId(items.first.sId);
                    sharedPreferencesViewModel
                        .saveSessionDuration(items.first.timeDuration);
                    print("userId : $userId ");
                    return Column(
                      children: [
                        ...List.generate(
                          items.length,
                          (index) {
                            return GestureDetector(onTap: () {
                              if (snapshot.data![0].bookingStatus ==
                                  'Confirm') {
                                if (snapshot.data![0].bookingType == 'Chat') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          bookingStatus: items[index]
                                              .bookingStatus
                                              .toString(),
                                          therapistCate: items[index]
                                              .therapistId!
                                              .name
                                              .toString(),
                                          duration: items[index]
                                              .timeDuration
                                              .toString(),
                                          chatId: userId.toString(),
                                          sessionId:
                                              items[index].sId.toString(),
                                        ),
                                      ));
                                }
                              }
                            }, child: Consumer<HomeViewModel>(
                              builder: (context, value, child) {
                                String capitalizeName(String name) {
                                  return name
                                      .split(' ')
                                      .map((word) =>
                                          word[0].toUpperCase() +
                                          word.substring(1))
                                      .join(' ');
                                }

                                String formattedName = capitalizeName(
                                    items[index].therapistId!.name!);

                                return value.statusLoading
                                    ? const SizedBox()
                                    : GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ChatPage(
                                                  bookingStatus: items[index]
                                                      .bookingStatus
                                                      .toString(),
                                                  therapistCate: items[index]
                                                      .therapistId!
                                                      .name
                                                      .toString(),
                                                  duration: items[index]
                                                      .timeDuration
                                                      .toString(),
                                                  chatId: items[index]
                                                      .sId
                                                      .toString(),
                                                  sessionId: items[index]
                                                      .sId
                                                      .toString(),
                                                ),
                                              ));
                                        },
                                        child: BookingBottomBarWidget(
                                          bookingStatus:
                                              items[index].bookingStatus,
                                          status: false,
                                          name: "$formattedName",
                                          image: items[index]
                                              .therapistId!
                                              .profileImg
                                              .toString(),
                                          callType: items[index]
                                              .bookingType
                                              .toString(),
                                          fee:
                                              "${items[index].fees!.toStringAsFixed(2)}",
                                          onCancelTap: () {
                                            value
                                                .bookingStatusApis(
                                                    token.toString(),
                                                    'Cancel',
                                                    snapshot.data![0].sId,
                                                    context)
                                                .then((values) {
                                              value.sessionCompleteApis(
                                                  snapshot.data![0].sId
                                                      .toString(),
                                                  true,
                                                  context);
                                            });
                                          },
                                        ),
                                      );
                              },
                            ));
                          },
                        )
                      ],
                    );
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
        floatingActionButton: Consumer<SessionViewModel>(
          builder: (context, value, child) => value.sessionDatas.isEmpty
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(bottom: context.deviceHeight * .11),
                  child: FloatingActionButton(
                    backgroundColor: colorLightWhite,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              bookingStatus: value
                                  .sessionDatas.first.bookingStatus
                                  .toString(),
                              therapistCate: value
                                  .sessionDatas.first.therapistId!.name
                                  .toString(),
                              duration: value.sessionDatas.first.timeDuration
                                  .toString(),
                              chatId: value.sessionDatas.first.sId.toString(),
                              sessionId:
                                  value.sessionDatas.first.sId.toString(),
                            ),
                          ));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Icon(
                      CupertinoIcons.chat_bubble_fill,
                      size: 34,
                      color: Colors.black,
                    ),
                  ),
                ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: const Duration(milliseconds: 700),
          backgroundColor: const Color(0xff001E15),
          height: 72,
          buttonBackgroundColor: Colors.white,
          animationCurve: Curves.decelerate,
          index: currentIndex,
          color: const Color(0xff181818),
          items: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                margin: EdgeInsets.only(top: currentIndex == 0 ? 0 : 14),
                padding: EdgeInsets.all(currentIndex == 0 ? 0 : 12),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == 0
                        ? Colors.transparent
                        : Colors.grey.withOpacity(.5)),
                child: SvgPicture.asset(
                  'assets/img/homes.svg',
                  width: 26,
                  color: currentIndex == 0 ? Colors.black : Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                margin: EdgeInsets.only(top: currentIndex == 1 ? 0 : 14),
                padding: EdgeInsets.all(currentIndex == 1 ? 0 : 12),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == 1
                        ? Colors.transparent
                        : Colors.grey.withOpacity(.5)),
                child: SvgPicture.asset(
                  'assets/img/session.svg',
                  width: 26,
                  color: currentIndex == 1 ? Colors.black : Colors.white,
                ),
              ),
            )
          ],
          onTap: (value) {
            if (currentIndex == 0) {
              _controller.animateToPage(
                1,
                duration: const Duration(milliseconds: 20),
                curve: Curves.easeIn,
              );
            } else if (currentIndex == 1) {
              _controller.animateToPage(
                0,
                duration: const Duration(milliseconds: 20),
                curve: Curves.easeIn,
              );
            }
          },
        ));
  }
}
