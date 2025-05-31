import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/model/allTherapistModel.dart';
import 'package:overcooked/newFlow/prefrencesScreen/prefrencesScreen.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/shimmer/walletHistoryShimmer.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilsClass.dart';
import 'package:overcooked/newFlow/viewModel/walletViewModel.dart';
import 'package:overcooked/newFlow/widgets/agentCardWidget.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animated_icon_button/animated_icon_button.dart';

import 'viewModel/homeViewModel.dart';
import 'viewModel/utilViewModel.dart';

class CallScreenPage extends StatefulWidget {
  bool? isFilter;
  String? sortByFee, categories, language;
  CallScreenPage(
      {super.key,
      this.isFilter,
      this.categories,
      this.language,
      this.sortByFee});

  @override
  State<CallScreenPage> createState() => _CallScreenPageState();
}

class _CallScreenPageState extends State<CallScreenPage> {
  Stream<List<AllTherapistModel>>? _theraPistStream;
  int? selectedindex;
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();
  final FocusNode focusNode = FocusNode();

  bool isShowBottom = false;
  bool isSearch = false;
  String? selectedCategoryId, token, balance, userId;
  bool? freeStatus;

  bool isFilterHome = false;
  bool isFilterOtherScreen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final getSessionData =
        Provider.of<SessionViewModel>(context, listen: false);
    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);
    final getUtilsData = Provider.of<UtilsViewModel>(context, listen: false);
    final walletData = Provider.of<WalletViewModel>(context, listen: false);

    getHomeData.fetchStoryAPi();

    Future.wait([sharedPreferencesViewModel.getFreeStatus()]).then((value) {
      freeStatus = value[0];
    });
    Future.wait([
      sharedPreferencesViewModel.getToken(),
      sharedPreferencesViewModel.getUserId()
    ]).then((value) {
      token = value[0];
      userId = value[1];
      walletData.fetchWalletBalanceAPi(token.toString());
      if (widget.isFilter == false) {
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
    });
  }

  void _updateStream() {
    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);
    print("SelectedId : $selectedCategoryId");

    setState(() {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            'Full Session',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: MediaQuery.of(context).size.width * .06),
          ),
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
              children: [
                const SizedBox(
                  height: 20,
                ),
                Consumer<UtilsViewModel>(
                  builder: (context, value, child) {
                    if (value.isLoading == true) {
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
                                  arguments: {'isHome': false},
                                );
                                setState(() {
                                  widget.isFilter = result != null;
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
                                        ? greenColor
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
                                  widget.isFilter = false;
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
                                        ? greenColor
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
                                          ? greenColor
                                          : Colors.transparent,
                                      width: 0.5,
                                    ),
                                    color: const Color(0xff202020),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${value.dataList[index].emoji.toString()}  ${value.dataList[index].categoryName.toString()}",
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white),
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
                const SizedBox(
                  height: 10,
                ),
                ///point4
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
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
                            fontSize: MediaQuery.of(context).size.width * .045,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 28,
                ),
                Consumer<HomeViewModel>(
                  builder: (context, value, child) {
                    return NotificationListener(
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
                              child: const Text('No Therapist Availble!'),
                            );
                          } else if (snapshot.hasData) {
                            final items = snapshot.data!.toList();
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index + 1 == snapshot.data!.length &&
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
                                var item = snapshot.data!.toList();
                                return Consumer<WalletViewModel>(
                                  builder: (context, value, child) {
                                    String capitalizeName(String name) {
                                      String normalized = name
                                          .replaceAll(RegExp(r'\s+'), ' ')
                                          .trim();

                                      return normalized
                                          .split(' ')
                                          .map((word) => word.isNotEmpty
                                              ? word[0].toUpperCase() +
                                                  word
                                                      .substring(1)
                                                      .toLowerCase()
                                              : '')
                                          .join(' ');
                                    }

                                    String formattedName =
                                        capitalizeName(item[index].name!);

                                    return AgentCardWidget(
                                      normalPrice:
                                          item[index].fees!.toStringAsFixed(0),
                                      rating: item[index].avgRating!.toInt(),
                                      onCallTap: () {
                                        int? balancess =
                                            item[index].discountedFees != null
                                                ? item[index].discountedFees
                                                : item[index].fees!;
                                        if (value.walletModel!.balance! <
                                                balancess! &&
                                            freeStatus == false) {
                                          // UtilsClass().showRatingBottomSheet(
                                          //     context,
                                          //     item[index].discountedFees != 0
                                          //         ? item[index]
                                          //             .discountedFees!
                                          //             .toInt()
                                          //         : item[index].fees!.toInt(),
                                          //     token.toString(),
                                          //     '45',userId);
                                        } else if (item[index].isAvailable ==
                                            false) {
                                          UtilsClass().showCustomDialog(
                                              context,
                                              item[index].isFree == true &&
                                                      freeStatus == true
                                                  ? '0'
                                                  : item[index].fees == null
                                                      ? '0'
                                                      : item[index]
                                                                  .discountedFees ==
                                                              0
                                                          ? item[index]
                                                              .fees
                                                              .toString()
                                                          : item[index]
                                                              .discountedFees
                                                              .toString(),
                                              token,
                                              item[index].sId,
                                              item[index].name,
                                              item[index].profileImg,
                                              item[index].name,
                                              item[index].feesPerMinute,
                                              '45',
                                              userId,
                                              item[index].sId,
                                              item[index].name,
                                              true);
                                        } else {
                                          UtilsClass().showDialogWithoutTimer(
                                              context,
                                              item[index].isFree == true &&
                                                      freeStatus == true
                                                  ? '0'
                                                  : item[index].fees == null
                                                      ? '0'
                                                      : item[index]
                                                                  .discountedFees ==
                                                              0
                                                          ? item[index]
                                                              .fees
                                                              .toString()
                                                          : item[index]
                                                              .discountedFees
                                                              .toString(),
                                              token,
                                              item[index].sId,
                                              item[index].name,
                                              item[index].profileImg,
                                              item[index].name,
                                              item[index].feesPerMinute,
                                              '45',
                                              userId,
                                              item[index].sId,
                                              item[index].name,
                                              () {},
                                              true);
                                        }
                                      },
                                      isRisingStar: item[index].risingStar,
                                      isHomeScreen: false,
                                      isAvailble: item[index].isAvailable,
                                      isFree: false,
                                      name: "$formattedName",
                                      // Fixing the language access issue
                                      language: item[index].language!,
                                      price: item[index].fees == null
                                          ? ''
                                          : item[index]
                                              .fees!
                                              .toStringAsFixed(0),
                                      oneMintPrice: item[index]
                                                      .discountedFeesPerMinute !=
                                                  null ||
                                              item[index]
                                                      .discountedFeesPerMinute !=
                                                  0
                                          ? item[index]
                                              .discountedFeesPerMinute!
                                              .toStringAsFixed(0)
                                          : item[index].feesPerMinute != 0
                                              ? item[index]
                                                  .feesPerMinute!
                                                  .toStringAsFixed(0)
                                              : '',
                                      discountPrice:
                                          item[index].discountedFees == null
                                              ? ''
                                              : item[index]
                                                  .discountedFees!
                                                  .toStringAsFixed(0),
                                      theraPistCate:
                                          item[index].psychologistCategory,
                                      theraPistSubCate:
                                          item[index].qualification,
                                      image: item[index].profileImg,
                                      onTap: () {
                                        setState(() {
                                          isShowBottom = true;
                                        });
                                        Navigator.pop(context);
                                      },
                                      onCardTap: () {
                                        Navigator.pushNamed(
                                            context, RoutesName.expertScreen,
                                            arguments: {
                                              'id': item[index].sId,
                                              "balance":
                                                  value.walletModel!.balance
                                            });
                                      },
                                    );
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
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CustomeContainer(
      String filterTitle, int selectedIndex, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
            border: Border.all(color: greenColor, width: .5),
            color: const Color(0xff202020),
            borderRadius: BorderRadius.circular(25)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              filterTitle,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
