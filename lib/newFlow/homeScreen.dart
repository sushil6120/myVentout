import 'dart:io';
import 'dart:ui';

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/assetConstants.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/login/assessmentScreen.dart';
import 'package:overcooked/newFlow/model/allTherapistModel.dart';
import 'package:overcooked/newFlow/prefrencesScreen/prefrencesScreen.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/shimmer/walletHistoryShimmer.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:overcooked/newFlow/viewModel/slotsViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilViewModel.dart';
import 'package:overcooked/newFlow/viewModel/walletViewModel.dart';
import 'package:overcooked/newFlow/widgets/agentCardWidget.dart';
import 'package:overcooked/newFlow/widgets/bannerWidget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:overcooked/pushNotifications.dart';
import "dart:math";

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

  String? token, userId, signUpToken;
  String? selectedCategoryId;
  int? selectedindex;
  bool? freeStatus;
  bool isSearch = false;
  String? balance;
  final FocusNode focusNode = FocusNode();
  final scrollController = ScrollController();

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
    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);
    if (selectedCategoryId == null) {
      setState(() {
        _theraPistStream = getHomeData
            .therapistStream('', '', '', '', '', token)
            .map((therapists) {
          return filterTherapists(therapists, searchText, selectedCategoryId);
        });
      });
    } else {
      setState(() {
        _theraPistStream =
            getHomeData.therapistByCateStream(cateId!).map((therapists) {
              return filterTherapists(therapists, searchText, selectedCategoryId);
            });
      });
    }
  }

  setSearch(bool value) {
    setState(() {
      isSearch = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // incomingCalls();
    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);
    final getUtilsData = Provider.of<UtilsViewModel>(context, listen: false);
    final walletData = Provider.of<WalletViewModel>(context, listen: false);
    final slotsViewModel = Provider.of<SlotsViewModel>(context, listen: false);
    sessionData = Provider.of<SessionViewModel>(context, listen: false);
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
      print("${token} token token");
      walletData.fetchWalletBalanceAPi(token == null ? value[0]! : token!);
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
      slotsViewModel.fetchCommissionValueAPi();
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
  void dispose() {
    // TODO: implement dispose
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
          // appBar: AppBar(
          //   automaticallyImplyLeading: false,
          //   backgroundColor: Colors.transparent,
          //   centerTitle: true,
          //   surfaceTintColor: Colors.transparent,
          //   title: SizedBox(
          //       height: 50,
          //       width: 50,
          //       child: SvgPicture.asset(AppAssets.ocLogo)),
          // ),
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
              // IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search)),
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
              preferredSize: Size.fromHeight(isSearch == true ? height * .06 : 0),
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
                  ///point4
                  (freeStatus == false)?
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   PageRouteBuilder(
                      //     pageBuilder: (context, animation, secondaryAnimation) =>
                      //         PreferenceScreen(
                      //           isRegisterScreen: false,
                      //         ),
                      //     transitionsBuilder:
                      //         (context, animation, secondaryAnimation, child) {
                      //       const begin = Offset(1.0, 0.0);
                      //       const end = Offset(0.0, 0.0);
                      //       const curve = Curves.easeInOut;
                      //
                      //       var tween = Tween(begin: begin, end: end)
                      //           .chain(CurveTween(curve: curve));
                      //       var offsetAnimation = animation.drive(tween);
                      //
                      //       return SlideTransition(
                      //         position: offsetAnimation,
                      //         child: child,
                      //       );
                      //     },
                      //   ),
                      // );
                      print("${therapistList} myTherapistList");
                      print("${therapistList[0].myTherapist} myTherapistList");
                      myFreeTherapistList = therapistList!.where((item){
                        return (item.myTherapist == true);
                      }).toList();

                      print("${myFreeTherapistList} myTherapistList");

                      final _random = new Random();
                      var item = myFreeTherapistList[_random.nextInt(myFreeTherapistList.length)];
                      sessionData!.freeSessionTherapist = item;
                      sessionData!.BookSessionApis("0", "10", DateTime.now().toString(), token, item.sId, true, "Video Call", context, "");

                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF003D2A), // Green background
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: SvgPicture.asset(
                                height: 30,
                                width: 30,
                                AppAssets.sessionFilled
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    "Claim your Free Session",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: darkModeTextLight2,
                                      fontSize: 10,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                        "This is a free ",
                                      ),
                                      TextSpan(
                                        text: "Evaluation Session",
                                        style: TextStyle(
                                          color: primaryColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                        " to help us understand the need of counseling in our daily lives.",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ):SizedBox(),

                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       PageRouteBuilder(
                  //         pageBuilder: (context, animation, secondaryAnimation) =>
                  //             PreferenceScreen(
                  //               isRegisterScreen: false,
                  //             ),
                  //         transitionsBuilder:
                  //             (context, animation, secondaryAnimation, child) {
                  //           const begin = Offset(1.0, 0.0);
                  //           const end = Offset(0.0, 0.0);
                  //           const curve = Curves.easeInOut;
                  //
                  //           var tween = Tween(begin: begin, end: end)
                  //               .chain(CurveTween(curve: curve));
                  //           var offsetAnimation = animation.drive(tween);
                  //
                  //           return SlideTransition(
                  //             position: offsetAnimation,
                  //             child: child,
                  //           );
                  //         },
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 10, horizontal: 16),
                  //     margin: const EdgeInsets.all(12),
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFF003D2A), // Green background
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.only(right: 16),
                  //           child: SvgPicture.asset(
                  //               height: 30,
                  //               width: 30,
                  //               AppAssets.preferences2
                  //           ),
                  //         ),
                  //         Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Padding(
                  //                 padding: const EdgeInsets.only(bottom: 4),
                  //                 child: Text(
                  //                   "Lets help you find psychologist",
                  //                   style: GoogleFonts.inter(
                  //                     color: Colors.white,
                  //                     fontWeight: FontWeight.w500,
                  //                     fontSize: 16,
                  //                   ),
                  //                 ),
                  //               ),
                  //               RichText(
                  //                 textAlign: TextAlign.start,
                  //                 text: TextSpan(
                  //                   style: TextStyle(
                  //                     color: darkModeTextLight2,
                  //                     fontSize: 10,
                  //                   ),
                  //                   children: [
                  //                     TextSpan(
                  //                       text:
                  //                       "Not sure where to begin? Try some ",
                  //                     ),
                  //                     TextSpan(
                  //                       text: "clinically tested questions",
                  //                       style: TextStyle(
                  //                         color: primaryColor,
                  //                       ),
                  //                     ),
                  //                     TextSpan(
                  //                       text:
                  //                       " to help us understand your needs and emotional state.",
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //
                  //       ],
                  //     ),
                  //   ),
                  // ),


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
                              therapistList = snapshot.data!.toList();

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
                                        return Consumer<SlotsViewModel>(
                                          builder: (context, value2, child) {
                                            return AgentCardWidget(
                                              normalPrice: item
                                                  .feesPerMinuteOfTenMinute!
                                                  .toStringAsFixed(0),
                                              rating: item.avgRating!.toInt(),
                                              isRisingStar: item.risingStar,
                                              // onCallTap: () {
                                              //   int? balances = item.discountedFeesForTenMinute != 0
                                              //       ? item.discountedFeesForTenMinute
                                              //       : item.feesForTenMinute!;
                                              //
                                              //   if (value.walletModel!.balance! < balances! && freeStatus == false) {
                                              //     UtilsClass()
                                              //         .showRatingBottomSheet(
                                              //       context,
                                              //       item.discountedFeesForTenMinute !=
                                              //               0
                                              //           ? item
                                              //               .discountedFeesForTenMinute!
                                              //               .toInt()
                                              //           : item.feesForTenMinute!
                                              //               .toInt(),
                                              //       token.toString(),
                                              //       '10',
                                              //     );
                                              //   }
                                              //   else if (item.isAvailable == false) {
                                              //     UtilsClass().showCustomDialog(context,
                                              //       item.isFree == true && freeStatus == true ? '0' : item.feesForTenMinute == null ? '0' : item.discountedFeesForTenMinute == 0 ? item.feesForTenMinute.toString() : item.discountedFeesForTenMinute.toString(),
                                              //       token,
                                              //       item.sId,
                                              //       item.name,
                                              //       item.profileImg,
                                              //       item.name,
                                              //       item.discountedFeesPerMinuteOfTenMinute != 0
                                              //           ? item
                                              //               .feesPerMinuteOfTenMinute
                                              //           : item
                                              //               .feesPerMinuteOfTenMinute,
                                              //       '10',
                                              //       userId,
                                              //       item.sId,
                                              //       item.name,
                                              //       true,
                                              //     );
                                              //   } else {
                                              //     UtilsClass().showDialogWithoutTimer(context, item.isFree == true && freeStatus == true ? '0' : item.feesForTenMinute == 0
                                              //               ? '0'
                                              //               : item.discountedFeesForTenMinute == 0 ? item.feesForTenMinute.toString() : item.discountedFeesForTenMinute.toString(),
                                              //       token,
                                              //       item.sId,
                                              //       item.name,
                                              //       item.profileImg,
                                              //       item.name,
                                              //       item.discountedFeesPerMinuteOfTenMinute != 0
                                              //           ? item
                                              //               .discountedFeesPerMinuteOfTenMinute
                                              //           : item
                                              //               .feesPerMinuteOfTenMinute,
                                              //       '10',
                                              //       userId,
                                              //       item.sId,
                                              //       item.name,
                                              //       () {},
                                              //       false,
                                              //     );
                                              //   }
                                              // },
                                              onCallTap: (){
                                                value2.updateSlotId("");
                                                DateTime now = DateTime.now();
                                                List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
                                                String? day = days[now.weekday - 1];
                                                value2.updateIndex(now.weekday - 1);

                                                value2.fetchAvailableSlotsAPi(item.sId, "$day").then((value){
                                                  if(value2.isAllSlotsAvailable == true){
                                                    paymentBottomSheet(item.sId, item.fees);
                                                  }else{
                                                    SelectSlotBottomSheet(item.sId, item.fees);
                                                    Future.delayed(Duration(seconds: 1), (){
                                                      if((now.weekday-1) >= 4){
                                                        scrollController.jumpTo(scrollController.position.maxScrollExtent);
                                                      }
                                                    });
                                                  }
                                                });
                                              },
                                              isHomeScreen: true,
                                              isAvailble: item.isAvailable,
                                              isFree: item.isFree == true && freeStatus == true ? true : false,
                                              name: formattedName,
                                              language: item.language!.reversed.toList(),
                                              // price: item.discountedFeesForTenMinute == 0 ? item.feesForTenMinute!.toStringAsFixed(2) : item.discountedFeesForTenMinute!.toStringAsFixed(2),
                                              price:item.fees.toString(),
                                              oneMintPrice: item.discountedFeesPerMinuteOfTenMinute != 0 ? item.discountedFeesPerMinuteOfTenMinute!.toStringAsFixed(0)
                                                  : item.feesPerMinuteOfTenMinute != 0 ? item.feesPerMinuteOfTenMinute!.toStringAsFixed(0) : '',
                                              discountPrice: item.isFree == true && freeStatus == true ? '0'
                                                  : item.discountedFeesForTenMinute == 0 ? ''
                                                  : item.discountedFeesForTenMinute!.toStringAsFixed(0),
                                              theraPistCate: item.psychologistCategory,
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
                                                      "balance": value.walletModel!.balance,
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

  SelectSlotBottomSheet(id, fee) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true, // Allow the sheet to take more space
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
        final safeAreaBottom = MediaQuery.of(context).padding.bottom;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            height: size.height * 0.7, // Limit maximum height to 70% of screen
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
                            'assets/img/Rectangle.png'
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
                        child: Text(
                          "Select your slot",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: darkModePrimaryTextColor
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Days",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: darkModePrimaryTextColor
                          ),
                        ),
                      ),
                      Consumer<SlotsViewModel>(
                        builder: (context, value, child) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: List.generate(
                                  value.days.length,
                                      (index) {
                                    return GestureDetector(
                                        onTap: () {
                                          value.updateIndex(index);
                                          value.fetchAvailableSlotsAPi(id, value.days[index]["key"]);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                                          margin: const EdgeInsets.only(right: 10, left: 5, top: 20, bottom: 20),
                                          decoration: BoxDecoration(
                                              color: (value.daysTappedIndex == index) ? popupColor : colorDark4,
                                              borderRadius: BorderRadius.circular(50)
                                          ),
                                          child: Text(
                                            "${value.days[index]["day"]}",
                                            style: TextStyle(
                                                color: (value.daysTappedIndex == index) ? greenColor : darkModePrimaryTextColor
                                            ),
                                          ),
                                        )
                                    );
                                  }
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                        child: Text(
                          "Time",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: darkModePrimaryTextColor
                          ),
                        ),
                      ),
                      Consumer<SlotsViewModel>(
                        builder: (context, value, child) {
                          if (value.availableSlotsLoading == true) {
                            return Container(
                                height: 100,
                                alignment: Alignment.center,
                                child: CupertinoActivityIndicator(
                                  color: darkModePrimaryTextColor,
                                )
                            );
                          } else {
                            return Padding(
                                padding: const EdgeInsets.only(bottom: 80, left: 15, right: 15), // Added bottom padding for button
                                child: (value.availableSlotsList.isEmpty)
                                    ? Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: const Text("No slots available"),
                                )
                                    : LayoutBuilder(
                                    builder: (context, constraints) {
                                      // Calculate how many items can fit per row based on available width
                                      final itemWidth = constraints.maxWidth * 0.45; // 45% of available width
                                      final crossAxisCount = constraints.maxWidth ~/ itemWidth;

                                      return GridView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: crossAxisCount > 0 ? crossAxisCount : 1,
                                            childAspectRatio: 16/4.5,
                                            crossAxisSpacing: 15,
                                            mainAxisSpacing: 15,
                                          ),
                                          itemCount: value.availableSlotsList.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                                onTap: () {
                                                  value.updateSlotId(value.availableSlotsList[index]!.sId);
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: (value.slotId == value.availableSlotsList[index]!.sId) ? popupColor : colorDark4,
                                                      borderRadius: BorderRadius.circular(50)
                                                  ),
                                                  child: Text(
                                                    "${value.availableSlotsList[index]!.slot}",
                                                    style: TextStyle(
                                                        color: (value.slotId == value.availableSlotsList[index]!.sId) ? greenColor : darkModePrimaryTextColor
                                                    ),
                                                  ),
                                                )
                                            );
                                          }
                                      );
                                    }
                                )
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Fixed bottom button
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Consumer<SlotsViewModel>(
                      builder: (context, value, child) {
                        if (value.availableSlotsLoading == true) {
                          return const SizedBox();
                        } else {
                          return (value.availableSlotsList.isEmpty)
                              ? const SizedBox()
                              : GestureDetector(
                              onTap: () {
                                if(value.slotId == "" || value.slotId == null){
                                  return;
                                }
                                Navigator.pop(context);

                                int finalAmount;

                                if (fee == 0) {
                                  finalAmount = 0;
                                } else {
                                  int tenPercent = (fee * (value.commissionValue! / 100)).toInt();
                                  finalAmount = fee + tenPercent;
                                }

                                UtilsClass().showRatingBottomSheet(
                                    context,
                                    finalAmount,
                                    token!,
                                    "59",
                                    value.commissionValue,
                                    id,
                                    value.isAllSlotsAvailable,
                                    value.slotId
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                height: 52,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: greenColor,
                                    borderRadius: BorderRadius.circular(60)
                                ),
                                child: (value.updateSlotsLoading == true)
                                    ? CupertinoActivityIndicator(color: primaryColorDark)
                                    : Text(
                                  "Next",
                                  style: TextStyle(
                                      color: primaryColorDark,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16
                                  ),
                                ),
                              )
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

  paymentBottomSheet(id, fee){
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
                  child: Text("Your session will be confirmed once the your payment has been processed.",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: darkModePrimaryTextColor
                    ),
                  ),
                ),

                Consumer<SlotsViewModel>(
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Note: your payment includes session plus ${value.commissionValue}% convenience charges.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: darkModeTextLight3
                        ),
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
                             int tenPercent = (fee * (value.commissionValue! / 100)).toInt();
                             finalAmount = fee + tenPercent;
                           }

                           UtilsClass().showRatingBottomSheet(
                               context,
                               finalAmount,
                               token!,
                               "59",
                               value.commissionValue,
                               id,
                               value.isAllSlotsAvailable,
                               value.slotId
                           );
                         },
                         child:Align(
                           alignment: Alignment.center,
                           child: Container(
                             width: context.width*0.8,
                             height: 52,
                             alignment: Alignment.center,
                             decoration: BoxDecoration(
                                 color:greenColor,
                                 borderRadius: BorderRadius.all(Radius.circular(60))
                             ),
                             child: (value.updateSlotsLoading == true)?
                             CupertinoActivityIndicator(color: primaryColorDark,)
                                 :Text("Click to pay ₹${fee}",
                               style: TextStyle(
                                   color: primaryColorDark,
                                   fontWeight: FontWeight.w500,
                                   fontSize: 16
                               ),
                             ),
                           ),
                         )
                     );

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
