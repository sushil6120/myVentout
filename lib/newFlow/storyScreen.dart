import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/model/allTherapistModel.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilViewModel.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:overcooked/newFlow/widgets/storyWidget.dart';
import 'package:overcooked/pushNotifications.dart';

import 'viewModel/homeViewModel.dart';

class StoryPage extends StatefulWidget {
  bool? isFilter = false;
  String? sortByFee, categories, language;
  StoryPage(
      {super.key,
      this.isFilter,
      this.categories,
      this.language,
      this.sortByFee});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  Stream<List<AllTherapistModel>>? _theraPistStream;

  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();

  PushNotificationService pushNotificationService = PushNotificationService();

  String? token, userId, signUpToken;
  String? selectedCategoryId;
  int? selectedindex;
  bool? freeStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // incomingCalls();
    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);
    final getUtilsData = Provider.of<UtilsViewModel>(context, listen: false);
    final getSessionData =
        Provider.of<SessionViewModel>(context, listen: false);

    getHomeData.storyList.clear();

    Future.wait([sharedPreferencesViewModel.getFreeStatus()]).then((value) {
      freeStatus = value[0];

      print("sl ${freeStatus}");
    });

    Future.wait([
      sharedPreferencesViewModel.getSignUpToken(),
      sharedPreferencesViewModel.getToken(),
      sharedPreferencesViewModel.getUserId(),
    ]).then((value) {
      if (value[1] == null || value[1]!.isEmpty) {
        sharedPreferencesViewModel.saveToken(value[0]);
      }
      token = value[1];
      userId = value[2];
      signUpToken = value[0];
      pushNotificationService.getDeviceToken(token.toString());
      print("Token : " + token.toString());
      print("userid ${value[2]}");
      if (widget.isFilter == true) {
        getHomeData.therapistStream(
            widget.sortByFee.toString(),
            widget.categories!,
            widget.language!,
            widget.sortByFee!,
            '',
            token == null ? value[0] !: token!);
      } else {
       getHomeData.therapistStream(
            '', '', '', '', '', token == null ? value[0]! : token!);
      }

      getUtilsData.fetchCategoryAPi();
      getHomeData.fetchStoryAPi();
      getHomeData.fetchWalletBalanceAPi(
          token == null ? value[0].toString() : token.toString());
      print(value[2]);
    });
  }

  void _updateStream() {
    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);
    print("SelectedId : $selectedCategoryId");

    setState(() {
      // Force the StreamBuilder to rebuild by setting a new key
      _theraPistStream = null;

      if (selectedCategoryId == null) {
      
            getHomeData.therapistStream('', '', '', '', '', token!);
      } else {
        _theraPistStream =
            getHomeData.therapistByCateStream(selectedCategoryId.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/back-designs.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: false,
            title: Text(
              'Story',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: MediaQuery.of(context).size.width * .06),
            ),
          ),
          body: SafeArea(
            child: Consumer<HomeViewModel>(
              builder: (context, value, child) {
                if (value.storyLoading == true) {
                  return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey,
                      child: Container(
                        width: context.deviceWidth,
                        height: context.deviceHeight -
                            (context.safeAreaHeight +
                                context.appBarHeight +
                                170),
                        margin: EdgeInsets.symmetric(
                            horizontal: Platform.isAndroid ? 14 : 20.0,
                            vertical: 20),
                        padding: EdgeInsets.only(
                            left: 10, bottom: 20, right: 10, top: 30),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.2),
                            borderRadius: BorderRadius.circular(60)),
                      ));
                } else if (value.storyList.isEmpty) {
                  return const SizedBox();
                } else {
                  return StoryWidget(
                    storyList: (value.storyList..shuffle(Random())),
                  );
                }
              },
            ),
          ),
        ));
  }

  Widget CustomeContainer(
      String filterTitle, String selectedCategoryId, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: selectedCategoryId == null
                    ? primaryColor
                    : Colors.transparent,
                width: .5),
            color: const Color(0xff202020),
            borderRadius: BorderRadius.circular(25)),
        child: Center(
          child: Text(
            filterTitle,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * .038,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
