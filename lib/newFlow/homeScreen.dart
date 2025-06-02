import 'dart:io';
import 'dart:ui';

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:overcooked/Utils/assetConstants.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/googleMeet/googleMeetScreen.dart';
import 'package:overcooked/newFlow/model/allTherapistModel.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/shimmer/bannerShimmer.dart';
import 'package:overcooked/newFlow/therapistChatscreens/viewmodels/chatProvider.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:overcooked/newFlow/viewModel/slotsViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilViewModel.dart';
import 'package:overcooked/newFlow/viewModel/walletViewModel.dart';
import 'package:overcooked/newFlow/widgets/agentCardWidget.dart';
import 'package:overcooked/newFlow/widgets/bannerWidget.dart';
import 'package:overcooked/newFlow/widgets/creditDialog.dart';
import 'package:overcooked/newFlow/widgets/emergencyNumberWidget.dart';
import 'package:overcooked/newFlow/widgets/therapistChatDialog.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:overcooked/pushNotifications.dart';

import 'shimmer/walletHistoryShimmer.dart';
import 'therapistChatscreens/widgets/chatHomeCardWidget.dart';
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

  SessionViewModel? sessionData;

  var therapistList;
  var myFreeTherapistList;

  PushNotificationService pushNotificationService = PushNotificationService();
  bool isLoading = true;

  String? token, userId, signUpToken;
  String? selectedCategoryId;
  int? selectedindex;
  bool? freeStatus;
  bool isSearch = false;
  String? balance;
  final FocusNode focusNode = FocusNode();
  final scrollController = ScrollController();
  String errorMessage = '';

  List<AllTherapistModel> filterTherapists(List<AllTherapistModel> therapists,
      String searchText, String? selectedCategoryId) {
    return therapists.where((therapist) {
      bool matchesSearchText =
          therapist.name!.toLowerCase().contains(searchText.toLowerCase()) ||
              therapist.category!.any(
                (element) => element.categoryName!
                    .toLowerCase()
                    .contains(searchText.toLowerCase()),
              );
      bool matchesCategory =
          selectedCategoryId == null || therapist.sId == selectedCategoryId;
      bool matchesLanguage = therapist.language!
          .any((lang) => lang.toLowerCase().contains(searchText.toLowerCase()));
      return (matchesSearchText || matchesLanguage) && matchesCategory;
    }).toList();
  }

  void _searchStream({String searchText = '', String? cateId}) {
    if (token == null || token!.isEmpty) {
      print("Cannot search: Token not available");
      return;
    }

    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);

    setState(() {
      if (selectedCategoryId == null) {
        _theraPistStream = getHomeData
            .therapistStream('', '', '', '', '', token)
            .map((therapists) {
          return filterTherapists(therapists, searchText, selectedCategoryId);
        });
      } else {
        _theraPistStream = getHomeData
            .therapistByCateStream(cateId ?? selectedCategoryId!)
            .map((therapists) {
          return filterTherapists(therapists, searchText, selectedCategoryId);
        });
      }
    });
  }

  setSearch(bool value) {
    setState(() {
      isSearch = value;
    });
  }

  Future<void> _initializeData() async {
    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    try {
      print("Starting data initialization");
      Future.wait([
        sharedPreferencesViewModel.getFreeStatus(),
        sharedPreferencesViewModel.getFirstTimeUserValu()
      ]).then(
        (value) {
          freeStatus = value[0];
          if (value[1] == true) {
            showDialog(
              context: context,
              builder: (context) => CreditDialog(
                amount: '500',
                appName: 'Overcooked',
                onNextPressed: () {
                  // chatProvider
                  //     .unlockChatApi(
                  //         balance: double.tryParse(balance.toString()) ?? 0.0)
                  //     .then(
                  //       (value) {},
                  //     );
                  Navigator.of(context).pop();

                  // showDialog(
                  //   context: context,
                  //   builder: (context) => TherapyChatsDialog(
                  //     onBackToHomePressed: () {
                  //       Navigator.of(context).pop();
                  //     },
                  //   ),
                  // );
                },
              ),
            );
            sharedPreferencesViewModel.saveFirstTimeUserValu(false);
          }
        },
      );
      await Future.wait([
        sharedPreferencesViewModel.getSignUpToken(),
        sharedPreferencesViewModel.getToken(),
        sharedPreferencesViewModel.getUserId(),
      ]).then(
        (value) {
          signUpToken = value[0];
          token = value[1];
          userId = value[2];

          print("Free status: $freeStatus");

          print(
              "Auth tokens loaded - SignUp: $signUpToken, Main: $token, User: $userId");

          if (token == null || token!.isEmpty) {
            if (signUpToken == null || signUpToken!.isEmpty) {
              throw Exception("No authentication tokens available");
            }

            token = signUpToken;
            sharedPreferencesViewModel.saveToken(token!);
            print("Using signup token as main token");
          }

          if (userId == null || userId!.isEmpty) {
            throw Exception("User ID is not available");
          }

          final getUtilsData =
              Provider.of<UtilsViewModel>(context, listen: false);
          final walletData =
              Provider.of<WalletViewModel>(context, listen: false);
          final slotsViewModel =
              Provider.of<SlotsViewModel>(context, listen: false);

          print("Loading user profile");
          getHomeData.userProfileApis(
              userId: userId.toString(), token: token.toString());

          print("Loading secondary data");
          Future.wait([
            walletData.fetchWalletBalanceAPi(token!).catchError((e) {
              print("Wallet error: $e");
            }),
            pushNotificationService
                .getDeviceToken(token.toString())
                .catchError((e) {
              print("Notification token error: $e");
            }),
            getUtilsData.fetchCategoryAPi().catchError((e) {
              print("Categories error: $e");
            }),
          ]);

          print("Initializing therapist stream");
          if (widget.isFilter == true) {
            _theraPistStream = getHomeData.therapistStream(
                widget.sortByFee.toString(),
                widget.categories,
                widget.language,
                widget.sortByFee,
                '',
                token);
          } else {
            _theraPistStream =
                getHomeData.therapistStream('', '', '', '', '', token);
          }

          print("Loading remaining data");
          getHomeData
              .fetchStoryAPi()
              .catchError((e) => print("Stories error: $e"));
          slotsViewModel
              .fetchCommissionValueAPi()
              .catchError((e) => print("Commission error: $e"));
          getUtilsData
              .checkForUpdates()
              .catchError((e) => print("Update check error: $e"));

          print("All initialization complete");
        },
      );
    } catch (e) {
      print("Critical error in _initializeData: $e");
      setState(() {
        errorMessage = "Error: ${e.toString()}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("HomePage initState called");

    _initializeData();
  }

  void _updateStream() {
    if (token == null || token!.isEmpty) {
      print("Cannot update stream: Token not available");
      setState(() {
        errorMessage = "Authentication error. Please restart the app.";
      });
      return;
    }

    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);
    print("Updating stream with selectedCategoryId: $selectedCategoryId");

    setState(() {
      if (selectedCategoryId == null) {
        print("Fetching all therapists");
        _theraPistStream =
            getHomeData.therapistStream('', '', '', '', '', token);
      } else {
        print("Fetching therapists by category: $selectedCategoryId");
        _theraPistStream =
            getHomeData.therapistByCateStream(selectedCategoryId.toString());
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
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
            title: SizedBox(
                height: 50,
                width: 50,
                child: SvgPicture.asset(AppAssets.ocLogo)),
            actions: [
              AnimatedIconButton(
                size: 28,
                duration: const Duration(milliseconds: 300),
                onPressed: () {},
                icons: <AnimatedIconItem>[
                  AnimatedIconItem(
                    icon: const Icon(
                      CupertinoIcons.search,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        isSearch = true;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusScope.of(context).requestFocus(focusNode);
                      });
                    },
                  ),
                  AnimatedIconItem(
                    icon: const Icon(Icons.close, color: Colors.red),
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        isSearch = false;
                      });
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ],
              ),
              const SizedBox(
                width: 8,
              ),
              Consumer<WalletViewModel>(
                builder: (context, value, child) {
                  if (value.isLoading == true) {
                    return const SizedBox();
                  } else if (value.walletModel == null) {
                    return const Text('No Balance');
                  } else {
                    balance = value.walletModel!.balance.toString();
                    if (kDebugMode) {
                      print("Wallet Balance : ${balance}");
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.AddMoneyScreen,
                            arguments: {'balance': value.walletModel!.balance});
                      },
                      child: Container(
                        height: height * .036,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 3),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.white),
                            color: Colors.black),
                        child: Center(
                          child: Text(
                            '₹ ${value.walletModel!.balance!.toStringAsFixed(0)}',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                    onPressed: () {
                      UtilsClass().showSettingCard(
                          context, balance == null ? '0' : balance!);
                    },
                    iconSize: 28,
                    icon: Image.asset(
                      'assets/img/dots.png',
                      height: 30,
                    )),
              )
            ],
            bottom: PreferredSize(
              preferredSize:
                  Size.fromHeight(isSearch == true ? height * .06 : 0),
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: isSearch == false
                    ? const SizedBox()
                    : Center(
                        child: TextFormField(
                          // controller: textController,
                          focusNode: focusNode,
                          cursorColor: Colors.white,

                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                              errorStyle: TextStyle(
                                  color: Colors.transparent,
                                  fontSize: context.deviceWidth * .028),
                              hintText: 'Search',
                              hintStyle: GoogleFonts.inter(
                                color: Colors.grey,
                                fontSize: context.deviceWidth * .04,
                                fontWeight: FontWeight.w500,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: .5),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: .5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: .5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: .5),
                              ),
                              fillColor: Colors.grey.withOpacity(.2),
                              filled: true),
                          onChanged: (value) {
                            _searchStream(
                                cateId: selectedCategoryId,
                                searchText: value.toString());
                          },
                        ),
                      ),
              ),
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              color: primaryColor,
              backgroundColor: Colors.black,
              onRefresh: () async {
                await _initializeData();
              },
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
                                    margin: const EdgeInsets.only(
                                        right: 15, left: 4),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/img/filter.png',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .038,
                                        ),
                                        const Text(
                                          ' Filters',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  value.dataList == null ||
                                          value.dataList.isEmpty
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
                        return value.storyLoading == true &&
                                value.storyList.isEmpty
                            ? BannerShimmer()
                            : BannerWidget(storyList: value.storyList);
                      },
                    ),

                    ///point4

                    // Consumer<HomeViewModel>(
                    //   builder: (context, value, child) {
                    //     if (value.isLoading == true && value.storyList == null) {
                    //       return Shimmer.fromColors(
                    //           baseColor: Colors.black,
                    //           highlightColor: Colors.grey[500]!.withOpacity(.5),
                    //           child: Container(
                    //             width: context.deviceWidth,
                    //             height: height * .2,
                    //             margin: const EdgeInsets.only(
                    //                 left: 10, right: 10, top: 10),
                    //             decoration: BoxDecoration(
                    //                 color: Colors.black,
                    //                 borderRadius: BorderRadius.circular(20)),
                    //           ));
                    //     } else if (value.storyList.isEmpty) {
                    //       return const SizedBox();
                    //     } else {
                    //       return BannerWidget(
                    //         storyList: value.storyList,
                    //       );
                    //     }
                    //   },
                    // ),
                    const SizedBox(
                      height: 15,
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
                              GestureDetector(
                                onTap: () {
                                  //  Get.to(WebViewPage(),transition: Transition.rightToLeft);
                                },
                                child: Text(
                                  'Popular Experts',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              .045,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
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
                      height: 16,
                    ),
                    // MiniSessionWidget(onTap: () {

                    // },),
                    // (freeStatus == true)
                    //     ? FreeSessionWidget(
                    //         onTap: () {
                    //           final now = DateTime.now();
                    //           final hour = now.hour;

                    //           if (hour >= 9 && hour < 17) {
                    //             showEvaluationSessionDialog(
                    //               onPressed: () {
                    //                 sessionData!
                    //                     .BookFreeSessionApis(
                    //                   '10',
                    //                   now.toString(),
                    //                   token,
                    //                   true,
                    //                   "Video Call",
                    //                   context,
                    //                   userId: userId.toString(),
                    //                 )
                    //                     .then((value) {
                    //                   Navigator.pop(context);
                    //                 });
                    //               },
                    //               context: context,
                    //             );
                    //           } else {
                    //             showAnimatedDialog(
                    //                 context, primaryColor, colorLightWhite);
                    //           }
                    //         },
                    //       )
                    //     : SizedBox(),

                    // ChatHomeCardWidget(
                    //   userId: userId.toString(),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Consumer<HomeViewModel>(
                      builder: (context, value, child) {
                        return RefreshIndicator(
                          onRefresh: () async {
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
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                          },
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent) {
                                // Trigger pagination when the user scrolls to the bottom
                                final getHomeData = Provider.of<HomeViewModel>(
                                    context,
                                    listen: false);
                                if (widget.isFilter == true) {
                                  _theraPistStream =
                                      getHomeData.therapistStream(
                                    isrefresh: true,
                                    widget.sortByFee.toString(),
                                    widget.categories,
                                    widget.language,
                                    widget.sortByFee,
                                    '',
                                    token,
                                  );
                                } else {
                                  _theraPistStream =
                                      getHomeData.therapistStream(
                                    isrefresh: true,
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
                                final homeViewModel =
                                    Provider.of<HomeViewModel>(context,
                                        listen: false);
                                // if (isLoading == true &&
                                //     homeViewModel.isFirstLoad == true) {
                                //   return ShimmerWalletTransactionItem();
                                // }
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting &&
                                    homeViewModel.isFirstLoad) {
                                  return ShimmerWalletTransactionItem();
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(snapshot.error.toString()),
                                  );
                                } else if (snapshot.data == null ||
                                    snapshot.data!.isEmpty) {
                                  if (homeViewModel
                                      .cachedTherapists.isNotEmpty) {
                                    therapistList =
                                        homeViewModel.cachedTherapists;
                                  } else {
                                    return Center(
                                      heightFactor: context.deviceHeight * .018,
                                      child:
                                          const Text('No Therapist Available!'),
                                    );
                                  }
                                } else if (snapshot.hasData) {
                                  if (homeViewModel.isFirstLoad) {
                                    homeViewModel.setFirstLoadComplete();
                                  }

                                  final getHomeData =
                                      Provider.of<HomeViewModel>(context,
                                          listen: false);
                                  getHomeData.fetchWalletBalanceAPi(
                                      token == null
                                          ? signUpToken.toString()
                                          : token.toString());
                                  therapistList = snapshot.data!.toList();
                                }
                                return ListView.builder(
                                  itemCount: therapistList.length,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (index == therapistList.length &&
                                        value.isLoading) {
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
                                                child: LoadingAnimationWidget
                                                    .staggeredDotsWave(
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "Loading..",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    var item = therapistList[index];

                                    return Consumer<HomeViewModel>(
                                      builder: (context, value, child) {
                                        String capitalizeName(String name) {
                                          return name
                                              .trim()
                                              .split(' ')
                                              .where((word) => word.isNotEmpty)
                                              .map((word) =>
                                                  word[0].toUpperCase() +
                                                  word.substring(1))
                                              .join(' ');
                                        }

                                        String formattedName = capitalizeName(
                                            item.name!.trimLeft().trimRight());

                                        if (value.isEmpty == false) {
                                          return Consumer<SlotsViewModel>(
                                            builder: (context, value2, child) {
                                              return AgentCardWidget(
                                                normalPrice: item
                                                    .feesPerMinuteOfTenMinute!
                                                    .toStringAsFixed(0),
                                                rating: item.avgRating!.toInt(),
                                                isRisingStar: item.risingStar,
                                                onCallTap: () {
                                                  value2.updateSlotId("");
                                                  DateTime now = DateTime.now();
                                                  List<String> days = [
                                                    'Monday',
                                                    'Tuesday',
                                                    'Wednesday',
                                                    'Thursday',
                                                    'Friday',
                                                    'Saturday',
                                                    'Sunday'
                                                  ];
                                                  String? day =
                                                      days[now.weekday - 1];
                                                  value2.updateIndex(
                                                      now.weekday - 1);
                                                  print(
                                                      "object: ${item.discountedFees}");
                                                  value2
                                                      .fetchAvailableSlotsAPi(
                                                          item.sId, day)
                                                      .then((value) {
                                                    // Calculate the original fee value
                                                    double feesValue = (item
                                                                .discountedFees
                                                                .toString()
                                                                .isNotEmpty
                                                            ? item
                                                                .discountedFees
                                                            : item
                                                                .fees) is String
                                                        ? double.tryParse(item
                                                                    .discountedFees
                                                                    .toString()
                                                                    .isNotEmpty
                                                                ? item
                                                                    .discountedFees
                                                                    .toString()
                                                                : item.fees
                                                                    .toString()) ??
                                                            0.0
                                                        : (item.discountedFees
                                                                    .toString()
                                                                    .isNotEmpty
                                                                ? item
                                                                    .discountedFees
                                                                : item.fees)
                                                            .toDouble();

                                                    double walletBalance =
                                                        double.tryParse(
                                                                balance ??
                                                                    '0') ??
                                                            0.0;

                                                    double remainingFees = 0.0;
                                                    if (feesValue >
                                                        walletBalance) {
                                                      remainingFees =
                                                          feesValue -
                                                              walletBalance;
                                                    } else {
                                                      walletBalance = feesValue;
                                                      remainingFees = 0.0;
                                                    }
                                                    print(
                                                        "Fessssss : ${remainingFees} ${feesValue}");
                                                    SelectSlotBottomSheet(
                                                        item.sId,
                                                        "${remainingFees}",
                                                        feesValue,
                                                        balance);

                                                    double walletBalanceUsed =
                                                        feesValue -
                                                            remainingFees;
                                                    print(
                                                        "Wallet balance used: $walletBalanceUsed");
                                                    print(
                                                        "Remaining fees to pay: $remainingFees");

                                                    Future.delayed(
                                                        Duration(seconds: 1),
                                                        () {
                                                      if ((now.weekday - 1) >=
                                                          4) {
                                                        scrollController.jumpTo(
                                                            scrollController
                                                                .position
                                                                .maxScrollExtent);
                                                      }
                                                    });
                                                  });
                                                },
                                                isHomeScreen: true,
                                                isAvailble: item.isAvailable,
                                                isFree: item.isFree == true &&
                                                        freeStatus == true
                                                    ? true
                                                    : false,
                                                name: formattedName,
                                                language: item
                                                    .language!.reversed
                                                    .toList(),
                                                price: item.discountedFees
                                                        .toString()
                                                        .isNotEmpty
                                                    ? item.discountedFees
                                                        .toString()
                                                    : item.fees.toString(),
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
                                                discountPrice:
                                                    item.discountedFees == 0
                                                        ? ''
                                                        : item.fees!
                                                            .toStringAsFixed(0),
                                                theraPistCate:
                                                    item.psychologistCategory,
                                                theraPistSubCate:
                                                    item.qualification,
                                                image: item.profileImg,
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                onCardTap: () {
                                                  Navigator.pushNamed(context,
                                                      RoutesName.expertScreen,
                                                      arguments: {
                                                        'id': item.sId,
                                                        "balance": value
                                                            .walletModel!
                                                            .balance,
                                                        "fees": item.fees,
                                                      });
                                                },
                                              );
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
                              },
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddEmergencyNumberDialog(
          onSave: (number) {
            // Handle saving number (e.g., call API or update state)
            print("Emergency number saved: $number");
          },
        );
      },
    );
  }

  //hello

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

  // SelectSlotBottomSheet(id, fee){
  //   double width = MediaQuery.of(context).size.width;
  //   double height = MediaQuery.of(context).size.height;
  //   return showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //
  //       return BackdropFilter(
  //           filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               const SizedBox(
  //                 height: 8,
  //               ),
  //               Center(
  //                 child: Image.asset(
  //                     width: width * 0.082,
  //                     height: height * 0.015,
  //                     'assets/img/Rectangle.png'),
  //               ),
  //               SizedBox(
  //                 height: height * 0.02,
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(bottom: 20, left: 10, right: 15),
  //                 child: Text("Select your slot",
  //                   style: TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.w500,
  //                       color: darkModePrimaryTextColor
  //                   ),
  //                 ),
  //               ),
  //
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 10),
  //                 child: Text("Days",
  //                   style: TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.w500,
  //                       color: darkModePrimaryTextColor
  //                   ),
  //                 ),
  //               ),
  //               Consumer<SlotsViewModel>(
  //                 builder: (context, value, child) {
  //                   return SingleChildScrollView(
  //                     scrollDirection: Axis.horizontal,
  //                     controller: scrollController,
  //                     child: Row(
  //                       children: List.generate(value.days.length,
  //                               (index){
  //                             return GestureDetector(
  //                                 onTap: (){
  //                                   value.updateIndex(index);
  //                                   value.fetchAvailableSlotsAPi(id, value.days[index]["key"]);
  //                                 },
  //                                 child:Container(
  //                                   alignment: Alignment.center,
  //                                   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
  //                                   margin: EdgeInsets.only(right: 10,left: 5, top: 20, bottom: 20),
  //                                   decoration: BoxDecoration(
  //                                       color: (value.daysTappedIndex == index)?popupColor:colorDark4,
  //                                       borderRadius: BorderRadius.all(Radius.circular(50))
  //                                   ),
  //                                   child: Text("${value.days[index]["day"]}",
  //                                     style: TextStyle(
  //                                         color: (value.daysTappedIndex == index)?greenColor:darkModePrimaryTextColor
  //                                     ),
  //                                   ),
  //                                 )
  //                             );
  //                           }),
  //                     ),
  //                   );
  //                 },
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
  //                 child: Text("Time",
  //                   style: TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.w500,
  //                       color: darkModePrimaryTextColor
  //                   ),
  //                 ),
  //               ),
  //               Consumer<SlotsViewModel>(
  //                 builder: (context, value, child) {
  //                   if(value.availableSlotsLoading == true){
  //                     return Container(
  //                         height: 100,
  //                         alignment: Alignment.center,
  //                         child: CupertinoActivityIndicator(
  //                           color: darkModePrimaryTextColor,
  //                         )
  //                     );
  //                   }else{
  //                     return Padding(
  //                       padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
  //                       child: (value.availableSlotsList.isEmpty)?Container(
  //                         height: 50,
  //                         alignment: Alignment.center,
  //                         child: Text("No slots available"),
  //                       ):SizedBox(
  //                         height: 120,
  //                         child: GridView.count(
  //                           shrinkWrap: true,
  //                           crossAxisCount: 2,
  //                           childAspectRatio: 16/4.5,
  //                           crossAxisSpacing: 20,
  //                           mainAxisSpacing: 20,
  //                           children: List.generate(value.availableSlotsList.length,
  //                                   (index){
  //                                 return GestureDetector(
  //                                     onTap: (){
  //                                       value.updateSlotId(value.availableSlotsList[index]!.sId);
  //                                     },
  //                                     child:Container(
  //                                       width: context.width*.40,
  //                                       alignment: Alignment.center,
  //                                       decoration: BoxDecoration(
  //                                           color: (value.slotId == value.availableSlotsList[index]!.sId)?popupColor:colorDark4,
  //                                           borderRadius: BorderRadius.all(Radius.circular(50))
  //                                       ),
  //                                       child: Text("${value.availableSlotsList[index]!.slot}",
  //                                         style: TextStyle(
  //                                             color: (value.slotId == value.availableSlotsList[index]!.sId)?greenColor:darkModePrimaryTextColor
  //                                         ),
  //                                       ),
  //                                     )
  //                                 );
  //                               }),
  //                         ),
  //                       )
  //                     );
  //                   }
  //                 },
  //               ),
  //
  //               Consumer<SlotsViewModel>(
  //                 builder: (context, value, child) {
  //                   if(value.availableSlotsLoading == true){
  //                     return SizedBox();
  //                   }else{
  //                     return (value.availableSlotsList.isEmpty)?SizedBox():GestureDetector(
  //                         onTap: (){
  //                           Navigator.pop(context);
  //
  //                           dynamic finalAmount;
  //
  //                           if (fee == 0){
  //                             finalAmount = 0;
  //                           }else{
  //                             dynamic tenPercent = fee * (value.commissionValue!/100);
  //                             finalAmount = fee - tenPercent;
  //                           }
  //
  //                           UtilsClass().showRatingBottomSheet(context, finalAmount, token!, "59", value.commissionValue, id, value.isAllSlotsAvailable, value.slotId);
  //                         },
  //                         child:Align(
  //                           alignment: Alignment.center,
  //                           child: Container(
  //                             width: context.width*0.8,
  //                             height: 52,
  //                             alignment: Alignment.center,
  //                             decoration: BoxDecoration(
  //                                 color:greenColor,
  //                                 borderRadius: BorderRadius.all(Radius.circular(60))
  //                             ),
  //                             child: (value.updateSlotsLoading == true)?
  //                             CupertinoActivityIndicator(color: primaryColorDark,)
  //                                 :Text("Next",
  //                               style: TextStyle(
  //                                   color: primaryColorDark,
  //                                   fontWeight: FontWeight.w500,
  //                                   fontSize: 16
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                     );
  //                   }
  //
  //                 },
  //               ),
  //
  //             ],
  //           ));
  //     },
  //   );
  // }

  SelectSlotBottomSheet(id, fee, amountFees, waletBalance) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        final safeAreaBottom = MediaQuery.of(context).padding.bottom;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            height: size.height * 0.7,
            padding: EdgeInsets.only(bottom: safeAreaBottom),
            child: Stack(
              children: [
                // Main content - scrollable
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Center(
                        child: Image.asset(
                            width: size.width * 0.082,
                            height: size.height * 0.015,
                            'assets/img/Rectangle.png'),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 15, right: 15),
                        child: Text(
                          "Select your slot",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: darkModePrimaryTextColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Days",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: darkModePrimaryTextColor),
                        ),
                      ),
                      Consumer<SlotsViewModel>(
                        builder: (context, value, child) {
                          final DateTime today = DateTime.now();
                          final int currentDayOfWeek = today.weekday;

                          final reorderedDays = <Map<String, dynamic>>[];

                          final weekdayToIndex = <int, int>{};
                          for (int i = 0; i < value.days.length; i++) {
                            if (value.days[i].containsKey("dayIndex")) {
                              weekdayToIndex[value.days[i]["dayIndex"]] = i;
                            } else if (value.days[i].containsKey("day")) {
                              String dayName =
                                  value.days[i]["day"].toString().toLowerCase();
                              final dayNames = [
                                "monday",
                                "tuesday",
                                "wednesday",
                                "thursday",
                                "friday",
                                "saturday",
                                "sunday"
                              ];
                              for (int d = 0; d < dayNames.length; d++) {
                                if (dayName == dayNames[d] ||
                                    dayName == dayNames[d].substring(0, 3)) {
                                  weekdayToIndex[d + 1] = i;
                                  break;
                                }
                              }
                            } else if (value.days[i].containsKey("key") &&
                                value.days[i]["key"].toString().contains("-")) {
                              try {
                                DateTime dayDate =
                                    DateTime.parse(value.days[i]["key"]);
                                weekdayToIndex[dayDate.weekday] = i;
                              } catch (e) {}
                            }
                          }

                          if (value.days.isNotEmpty) {
                            for (int weekday = currentDayOfWeek;
                                weekday <= 7;
                                weekday++) {
                              if (weekdayToIndex.containsKey(weekday)) {
                                reorderedDays
                                    .add(value.days[weekdayToIndex[weekday]!]);
                              }
                            }

                            for (int weekday = 1;
                                weekday < currentDayOfWeek;
                                weekday++) {
                              if (weekdayToIndex.containsKey(weekday)) {
                                reorderedDays
                                    .add(value.days[weekdayToIndex[weekday]!]);
                              }
                            }
                          }

                          final daysToUse = reorderedDays.isNotEmpty
                              ? reorderedDays
                              : value.days;

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (scrollController.hasClients) {
                              scrollController.jumpTo(0);
                            }
                          });

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children:
                                  List.generate(daysToUse.length, (index) {
                                final originalIndex = value.days.indexWhere(
                                    (day) =>
                                        day["key"] == daysToUse[index]["key"]);

                                bool isToday = false;
                                if (daysToUse[index].containsKey("dayIndex")) {
                                  isToday = daysToUse[index]["dayIndex"] ==
                                      currentDayOfWeek;
                                } else if (daysToUse[index]
                                    .containsKey("day")) {
                                  String dayName = daysToUse[index]["day"]
                                      .toString()
                                      .toLowerCase();
                                  String todayName = [
                                    "monday",
                                    "tuesday",
                                    "wednesday",
                                    "thursday",
                                    "friday",
                                    "saturday",
                                    "sunday"
                                  ][currentDayOfWeek - 1]
                                      .toLowerCase();
                                  isToday = dayName == todayName ||
                                      dayName == todayName.substring(0, 3);
                                } else if (daysToUse[index]
                                        .containsKey("key") &&
                                    daysToUse[index]["key"]
                                        .toString()
                                        .contains("-")) {
                                  try {
                                    DateTime dayDate =
                                        DateTime.parse(daysToUse[index]["key"]);
                                    DateTime todayNoTime = DateTime(
                                        today.year, today.month, today.day);
                                    isToday =
                                        dayDate.isAtSameMomentAs(todayNoTime);
                                  } catch (e) {
                                    isToday = false;
                                  }
                                }

                                if (isToday && value.daysTappedIndex == -1) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    value.updateIndex(originalIndex);
                                    value.fetchAvailableSlotsAPi(
                                        id, daysToUse[index]["key"]);
                                  });
                                }

                                return GestureDetector(
                                    onTap: () {
                                      value.updateIndex(originalIndex);
                                      value.fetchAvailableSlotsAPi(
                                          id, daysToUse[index]["key"]);
                                      print(
                                          "dyssss :${daysToUse[index]["key"]}");
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 20),
                                      margin: const EdgeInsets.only(
                                          right: 10,
                                          left: 5,
                                          top: 20,
                                          bottom: 20),
                                      decoration: BoxDecoration(
                                          color: (value.daysTappedIndex ==
                                                  originalIndex)
                                              ? popupColor
                                              : colorDark4,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Text(
                                        "${daysToUse[index]["day"]}",
                                        style: TextStyle(
                                            color: (value.daysTappedIndex ==
                                                    originalIndex)
                                                ? greenColor
                                                : darkModePrimaryTextColor),
                                      ),
                                    ));
                              }),
                            ),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 15, right: 15),
                            child: Text(
                              "Time",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: darkModePrimaryTextColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      margin: EdgeInsets.only(right: 6),
                                      decoration: BoxDecoration(
                                        color: colorLightWhite,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    Text(
                                      "Available",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      margin: EdgeInsets.only(right: 6),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    Text(
                                      "Selected",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      margin: EdgeInsets.only(right: 6),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color: colorDark2.withOpacity(.5)),
                                    ),
                                    Text(
                                      "Booked",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Consumer<SlotsViewModel>(
                        builder: (context, value, child) {
                          if (value.availableSlotsLoading == true) {
                            return Container(
                                height: 100,
                                alignment: Alignment.center,
                                child: CupertinoActivityIndicator(
                                  color: darkModePrimaryTextColor,
                                ));
                          } else {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 80, left: 15, right: 15),
                                child: (value.availableSlotsList.isEmpty)
                                    ? Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: const Text("No slots available"),
                                      )
                                    : LayoutBuilder(
                                        builder: (context, constraints) {
                                        final itemWidth =
                                            constraints.maxWidth * 0.45;
                                        final crossAxisCount =
                                            constraints.maxWidth ~/ itemWidth;

                                        return GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: crossAxisCount > 0
                                                  ? crossAxisCount
                                                  : 1,
                                              childAspectRatio: 16 / 4.5,
                                              crossAxisSpacing: 15,
                                              mainAxisSpacing: 15,
                                            ),
                                            itemCount:
                                                value.availableSlotsList.length,
                                            itemBuilder: (context, index) {
                                              bool isSlotPassed = false;
                                              DateTime now = DateTime.now();

                                              try {
                                                String slotTime = value
                                                    .availableSlotsList[index]!
                                                    .slotId!
                                                    .slot
                                                    .toString();

                                                String startTimeStr =
                                                    slotTime.contains("-")
                                                        ? slotTime
                                                            .split("-")[0]
                                                            .trim()
                                                        : slotTime.trim();

                                                if (value.daysTappedIndex <
                                                    value.days.length) {
                                                  bool isToday = false;

                                                  if (value.days[value
                                                              .daysTappedIndex]
                                                          .containsKey("key") &&
                                                      value.days[value
                                                                  .daysTappedIndex]
                                                              ["key"]
                                                          .toString()
                                                          .contains("-")) {
                                                    DateTime selectedDate =
                                                        DateTime.parse(
                                                            value.days[value
                                                                    .daysTappedIndex]
                                                                ["key"]);
                                                    DateTime todayDate =
                                                        DateTime(now.year,
                                                            now.month, now.day);
                                                    isToday = selectedDate
                                                        .isAtSameMomentAs(
                                                            todayDate);
                                                  } else {
                                                    String dayName = value.days[
                                                            value
                                                                .daysTappedIndex]
                                                            ["day"]
                                                        .toString()
                                                        .toLowerCase();
                                                    String todayName = [
                                                      "monday",
                                                      "tuesday",
                                                      "wednesday",
                                                      "thursday",
                                                      "friday",
                                                      "saturday",
                                                      "sunday"
                                                    ][now.weekday - 1];

                                                    isToday = dayName ==
                                                            todayName ||
                                                        dayName ==
                                                            todayName.substring(
                                                                0, 3);
                                                  }

                                                  if (isToday) {
                                                    startTimeStr = startTimeStr
                                                        .replaceAll(" ", "");

                                                    bool isPM = startTimeStr
                                                        .toUpperCase()
                                                        .contains("PM");
                                                    bool isAM = startTimeStr
                                                        .toUpperCase()
                                                        .contains("AM");

                                                    String timeOnly =
                                                        startTimeStr
                                                            .replaceAll(
                                                                "AM", "")
                                                            .replaceAll(
                                                                "am", "")
                                                            .replaceAll(
                                                                "PM", "")
                                                            .replaceAll(
                                                                "pm", "");

                                                    List<String> timeParts =
                                                        timeOnly.split(":");
                                                    int hour =
                                                        int.parse(timeParts[0]);
                                                    int minute =
                                                        int.parse(timeParts[1]);

                                                    if (isPM && hour < 12)
                                                      hour += 12;
                                                    if (isAM && hour == 12)
                                                      hour = 0;

                                                    if (now.hour > hour ||
                                                        (now.hour == hour &&
                                                            now.minute >=
                                                                minute)) {
                                                      isSlotPassed = true;
                                                    }
                                                  }
                                                }
                                              } catch (e) {
                                                isSlotPassed = false;
                                              }

                                              return GestureDetector(
                                                onTap: (isSlotPassed ||
                                                        value
                                                                .availableSlotsList[
                                                                    index]!
                                                                .status ==
                                                            false)
                                                    ? null
                                                    : () {
                                                        value.updateSlotId(value
                                                            .availableSlotsList[
                                                                index]!
                                                            .slotId!
                                                            .sId);
                                                        print(
                                                            "Selected slotId: ${value.slotId}");
                                                      },
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: (isSlotPassed ||
                                                                value
                                                                        .availableSlotsList[
                                                                            index]!
                                                                        .status ==
                                                                    false)
                                                            ? Colors.grey
                                                                .withOpacity(
                                                                    0.3)
                                                            : (value.slotId ==
                                                                    value
                                                                        .availableSlotsList[
                                                                            index]!
                                                                        .slotId!
                                                                        .sId)
                                                                ? popupColor
                                                                : colorDark4,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: Text(
                                                        "${value.availableSlotsList[index]!.slotId!.slot}",
                                                        style: TextStyle(
                                                          color: (isSlotPassed ||
                                                                  value
                                                                          .availableSlotsList[
                                                                              index]!
                                                                          .status ==
                                                                      false)
                                                              ? Colors.grey
                                                                  .withOpacity(
                                                                      0.6)
                                                              : (value.slotId ==
                                                                      value
                                                                          .availableSlotsList[
                                                                              index]!
                                                                          .slotId!
                                                                          .sId)
                                                                  ? greenColor
                                                                  : colorLightWhite,
                                                        ),
                                                      ),
                                                    ),
                                                    if (isSlotPassed ||
                                                        value
                                                                .availableSlotsList[
                                                                    index]!
                                                                .status ==
                                                            false)
                                                      Positioned.fill(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: colorDark1
                                                                .withOpacity(
                                                                    0.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              );
                                            });
                                      }));
                          }
                        },
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    child: Consumer<SlotsViewModel>(
                      builder: (context, value, child) {
                        if (value.availableSlotsLoading == true) {
                          return const SizedBox();
                        } else {
                          return (value.availableSlotsList.isEmpty)
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    if (value.slotId == "" ||
                                        value.slotId == null) {
                                      return;
                                    }

                                    Navigator.pop(context);

                                    int finalAmount;

                                    double feeValue = double.tryParse(
                                            amountFees.toString()) ??
                                        0.0;
                                    num commission =
                                        value.commissionValue ?? 0.0;
                                    double tenPercent =
                                        (feeValue * (commission / 100));
                                    double totalAmount = feeValue + tenPercent;
                                    double walletBalance = double.tryParse(
                                            waletBalance.toString()) ??
                                        0.0;

                                    double remainingAmount =
                                        totalAmount - walletBalance;
                                    finalAmount = remainingAmount > 0
                                        ? remainingAmount.toInt()
                                        : 0;
                                    print("AMount Fees :${totalAmount}");

                                    UtilsClass().showRatingBottomSheet(
                                      totalAmount.toString(),
                                      context,
                                      finalAmount,
                                      token!,
                                      "55",
                                      userId,
                                      value.commissionValue,
                                      id,
                                      value.isAllSlotsAvailable ?? false,
                                      value.slotId,
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 52,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: greenColor,
                                        borderRadius:
                                            BorderRadius.circular(60)),
                                    child: (value.updateSlotsLoading == true)
                                        ? CupertinoActivityIndicator(
                                            color: primaryColorDark)
                                        : Text(
                                            "Next",
                                            style: TextStyle(
                                                color: primaryColorDark,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                  ),
                                );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  paymentBottomSheet(id, fee, amountFees) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  padding: EdgeInsets.only(bottom: 10, left: 10, right: 15),
                  child: Text(
                    "Your session will be confirmed once the your payment has been processed.",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: darkModePrimaryTextColor),
                  ),
                ),
                Consumer<SlotsViewModel>(
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Note: your payment includes session plus ${value.commissionValue}% convenience charges.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: darkModeTextLight3),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 40),
                  child: Consumer<SlotsViewModel>(
                    builder: (context, value, child) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);

                            int finalAmount;

                            if (fee == 0) {
                              finalAmount = 0;
                            } else {
                              int tenPercent =
                                  (fee * (value.commissionValue! / 100))
                                      .toInt();
                              finalAmount = fee + tenPercent;
                            }

                            UtilsClass().showRatingBottomSheet(
                                amountFees,
                                context,
                                finalAmount,
                                token!,
                                "59",
                                userId,
                                value.commissionValue,
                                id,
                                value.isAllSlotsAvailable,
                                value.slotId);
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: context.width * 0.8,
                              height: 52,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: greenColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(60))),
                              child: (value.updateSlotsLoading == true)
                                  ? CupertinoActivityIndicator(
                                      color: primaryColorDark,
                                    )
                                  : Text(
                                      "Click to pay ₹${fee}",
                                      style: TextStyle(
                                          color: primaryColorDark,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                            ),
                          ));
                    },
                  ),
                ),
              ],
            ));
      },
    );
  }
}

//height: height * .7,
//               decoration: const BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20))),
