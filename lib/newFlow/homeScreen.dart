import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ventout/Utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ventout/Utils/responsive.dart';
import 'package:ventout/newFlow/login/assessmentScreen.dart';
import 'package:ventout/newFlow/model/allTherapistModel.dart';
import 'package:ventout/newFlow/prefrencesScreen/prefrencesScreen.dart';
import 'package:ventout/newFlow/routes/routeName.dart';
import 'package:ventout/newFlow/services/sharedPrefs.dart';
import 'package:ventout/newFlow/shimmer/walletHistoryShimmer.dart';
import 'package:ventout/newFlow/viewModel/sessionViewModel.dart';
import 'package:ventout/newFlow/viewModel/utilViewModel.dart';
import 'package:ventout/newFlow/widgets/agentCardWidget.dart';
import 'package:ventout/newFlow/widgets/bannerWidget.dart';
import 'package:ventout/newFlow/widgets/color.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ventout/pushNotifications.dart';

import 'viewModel/homeViewModel.dart';
import 'viewModel/utilsClass.dart';

class HomePage extends StatefulWidget {
  bool? isFilter = false;
  String? sortByFee, categories, language;
  HomePage(
      {super.key,
      this.isFilter,
      this.categories,
      this.language,
      this.sortByFee});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        _theraPistStream = getHomeData.therapistStream(
            widget.sortByFee.toString(),
            widget.categories,
            widget.language,
            widget.sortByFee,
            '',
            token == null ? value[0] : token);
      } else {
        _theraPistStream = getHomeData.therapistStream(
            '', '', '', '', '', token == null ? value[0] : token);
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
        _theraPistStream =
            getHomeData.therapistStream('', '', '', '', '', token);
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
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            title: SizedBox(
                height: 50,
                width: 50,
                child: SvgPicture.asset('assets/img/VO4.svg')),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<UtilsViewModel>(
                    builder: (context, value, child) {
                      if (value.isLoading == true && value.dataList == null) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Row(
                            children: [
                              ...List.generate(
                                  5,
                                  (index) => Shimmer.fromColors(
                                      baseColor: Colors.black,
                                      highlightColor:
                                          Colors.grey[500]!.withOpacity(.5),
                                      child: Container(
                                        width: context.deviceWidth * .2,
                                        height: height * .04,
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10, top: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      )))
                            ],
                          ),
                        );
                      } else {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Filter Button
                              GestureDetector(
                                onTap: () async {
                                  var result = await Navigator.pushNamed(
                                    context,
                                    RoutesName.sortFilterScreen,
                                    arguments: {'isHome': true},
                                  );
                                  setState(() {
                                    widget.isFilter = result !=
                                        null; // Update isFilter based on result
                                  });
                                  print(result);
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(right: 15, left: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff202020),
                                    border: Border.all(
                                      color: widget.isFilter == true
                                          ? primaryColor
                                          : Colors.transparent,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/img/filter.png',
                                        height:
                                            MediaQuery.of(context).size.width *
                                                .038,
                                      ),
                                      const Text(
                                        ' Filters',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // All Button
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategoryId = null;
                                    selectedindex = null;
                                    widget.isFilter =
                                        false; // Remove the filter when "All" is selected
                                    _updateStream();
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 15),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedindex == null &&
                                              widget.isFilter == false
                                          ? primaryColor
                                          : Colors
                                              .transparent, // Green border if "All" is selected
                                      width: 0.5,
                                    ),
                                    color: const Color(0xff202020),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'All',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Category Buttons
                              ...List.generate(
                                value.dataList == null || value.dataList.isEmpty
                                    ? 0
                                    : value.dataList.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategoryId =
                                          value.dataList[index].sId;
                                      selectedindex = index;
                                      widget.isFilter = false;
                                      _updateStream();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 6),
                                    margin: const EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selectedindex == index
                                            ? primaryColor
                                            : Colors.transparent,
                                        width: 0.5,
                                      ),
                                      color: const Color(0xff202020),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${value.dataList[index].emoji.toString()}  ${value.dataList[index].categoryName.toString()}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: Platform.isAndroid ? 10 : 10,
                  ),
                  Consumer<HomeViewModel>(
                    builder: (context, value, child) {
                      if (value.isLoading == true && value.storyList == null) {
                        return Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: Colors.grey[500]!.withOpacity(.5),
                            child: Container(
                              width: context.deviceWidth,
                              height: height * .2,
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)),
                            ));
                      } else if (value.storyList.isEmpty) {
                        return const SizedBox();
                      } else {
                        return BannerWidget(
                          storyList: value.storyList,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.checkmark_seal_fill,
                              color: primaryColor,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Popular Experts',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * .045,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        //   GestureDetector(
                        //     onTap: () {
                        //       Get.to(
                        //           PreferenceScreen(
                        //             isRegisterScreen: false,

                        //           ),
                        //           transition: Transition.rightToLeft);
                        //     },
                        //     child:   Icon(
                        //   Icons.tune,
                        //   color: Color(0xff1DB954),
                        //   size: 24,
                        // ),
                        //   )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Consumer<HomeViewModel>(
                    builder: (context, value, child) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                            // Trigger pagination when the user scrolls to the bottom
                            final getHomeData = Provider.of<HomeViewModel>(
                                context,
                                listen: false);
                            if (widget.isFilter == true) {
                              _theraPistStream = getHomeData.therapistStream(
                                widget.sortByFee.toString(),
                                widget.categories,
                                widget.language,
                                widget.sortByFee,
                                '',
                                token,
                              );
                            } else {
                              _theraPistStream = getHomeData.therapistStream(
                                '',
                                '',
                                '',
                                '',
                                '',
                                token,
                              );
                            }
                          }
                          return false;
                        },
                        child: StreamBuilder<List<AllTherapistModel>>(
                          key: ValueKey(selectedCategoryId),
                          stream: _theraPistStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ShimmerWalletTransactionItem();
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            } else if (snapshot.data == null ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                heightFactor: context.deviceHeight * .018,
                                child: const Text('No Therapist Available!'),
                              );
                            } else if (snapshot.hasData) {
                              final getHomeData = Provider.of<HomeViewModel>(
                                  context,
                                  listen: false);
                              getHomeData.fetchWalletBalanceAPi(token == null
                                  ? signUpToken.toString()
                                  : token.toString());

                              // Therapist List
                              var therapistList = snapshot.data!.toList();

                              return ListView.builder(
                                itemCount: therapistList.length,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (index + 1 == therapistList.length &&
                                      !value.isLoading) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 14,
                                              width: 14,
                                              child: LoadingAnimationWidget.staggeredDotsWave(
                                                size: 20,
                                                color: Colors.white,
                                              )),
                                          Text(
                                            "Loading..",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          )
                                        ],
                                      )),
                                    );
                                  }
                                  var item = therapistList[index];

                                  return Consumer<HomeViewModel>(
                                    builder: (context, value, child) {
                                      String capitalizeName(String name) {
                                        return name
                                            .trim()
                                            .split(' ')
                                            .where((word) => word
                                                .isNotEmpty) // Filter out empty words
                                            .map((word) =>
                                                word[0].toUpperCase() +
                                                word.substring(1))
                                            .join(' ');
                                      }

                                      String formattedName = capitalizeName(
                                          item.name!.trimLeft().trimRight());

                                      if (value.isEmpty == false) {
                                        return AgentCardWidget(
                                          normalPrice: item
                                              .feesPerMinuteOfTenMinute!
                                              .toStringAsFixed(0),
                                          rating: item.avgRating!.toInt(),
                                          isRisingStar: item.risingStar,
                                          onCallTap: () {
                                            int? balances = item
                                                        .discountedFeesForTenMinute !=
                                                    0
                                                ? item
                                                    .discountedFeesForTenMinute
                                                : item.feesForTenMinute!;

                                            if (value.walletModel!.balance! <
                                                    balances! &&
                                                freeStatus == false) {
                                              UtilsClass()
                                                  .showRatingBottomSheet(
                                                context,
                                                item.discountedFeesForTenMinute !=
                                                        0
                                                    ? item
                                                        .discountedFeesForTenMinute!
                                                        .toInt()
                                                    : item.feesForTenMinute!
                                                        .toInt(),
                                                token.toString(),
                                                '10',
                                              );
                                            } else if (item.isAvailable ==
                                                false) {
                                              UtilsClass().showCustomDialog(
                                                context,
                                                item.isFree == true &&
                                                        freeStatus == true
                                                    ? '0'
                                                    : item.feesForTenMinute ==
                                                            null
                                                        ? '0'
                                                        : item.discountedFeesForTenMinute ==
                                                                0
                                                            ? item
                                                                .feesForTenMinute
                                                                .toString()
                                                            : item
                                                                .discountedFeesForTenMinute
                                                                .toString(),
                                                token,
                                                item.sId,
                                                item.name,
                                                item.profileImg,
                                                item.name,
                                                item.discountedFeesPerMinuteOfTenMinute != 0
                                                    ? item
                                                        .feesPerMinuteOfTenMinute
                                                    : item
                                                        .feesPerMinuteOfTenMinute,
                                                '10',
                                                userId,
                                                item.sId,
                                                item.name,
                                                true,
                                              );
                                            } else {
                                              UtilsClass()
                                                  .showDialogWithoutTimer(
                                                context,
                                                item.isFree == true &&
                                                        freeStatus == true
                                                    ? '0'
                                                    : item.feesForTenMinute == 0
                                                        ? '0'
                                                        : item.discountedFeesForTenMinute ==
                                                                0
                                                            ? item
                                                                .feesForTenMinute
                                                                .toString()
                                                            : item
                                                                .discountedFeesForTenMinute
                                                                .toString(),
                                                token,
                                                item.sId,
                                                item.name,
                                                item.profileImg,
                                                item.name,
                                                item.discountedFeesPerMinuteOfTenMinute != 0
                                                    ? item
                                                        .discountedFeesPerMinuteOfTenMinute
                                                    : item
                                                        .feesPerMinuteOfTenMinute,
                                                '10',
                                                userId,
                                                item.sId,
                                                item.name,
                                                () {},
                                                false,
                                              );
                                            }
                                          },
                                          isHomeScreen: true,
                                          isAvailble: item.isAvailable,
                                          isFree: item.isFree == true &&
                                                  freeStatus == true
                                              ? true
                                              : false,
                                          name: formattedName,
                                          language:
                                              item.language!.reversed.toList(),
                                          price:
                                              item.discountedFeesForTenMinute ==
                                                      0
                                                  ? item.feesForTenMinute!
                                                      .toStringAsFixed(2)
                                                  : item
                                                      .discountedFeesForTenMinute!
                                                      .toStringAsFixed(2),
                                          oneMintPrice: item
                                                      .discountedFeesPerMinuteOfTenMinute !=
                                                  0
                                              ? item
                                                  .discountedFeesPerMinuteOfTenMinute!
                                                  .toStringAsFixed(0)
                                              : item.feesPerMinuteOfTenMinute !=
                                                      0
                                                  ? item
                                                      .feesPerMinuteOfTenMinute!
                                                      .toStringAsFixed(0)
                                                  : '',
                                          discountPrice: item.isFree == true &&
                                                  freeStatus == true
                                              ? '0'
                                              : item.discountedFeesForTenMinute ==
                                                      0
                                                  ? ''
                                                  : item
                                                      .discountedFeesForTenMinute!
                                                      .toStringAsFixed(0),
                                          theraPistCate:
                                              item.psychologistCategory,
                                          theraPistSubCate: item.qualification,
                                          image: item.profileImg,
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          onCardTap: () {
                                            Navigator.pushNamed(context,
                                                RoutesName.expertScreen,
                                                arguments: {
                                                  'id': item.sId,
                                                  "balance":
                                                      value.walletModel!.balance
                                                });
                                          },
                                        );
                                      } else {
                                        return Center(
                                            child: Text(
                                                'No Therapist Available!'));
                                      }
                                    },
                                  );
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
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
