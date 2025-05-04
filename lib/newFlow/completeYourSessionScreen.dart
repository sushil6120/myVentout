import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/newFlow/model/allTherapistModel.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/viewModel/homeViewModel.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:overcooked/newFlow/viewModel/slotsViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilsClass.dart';
import 'package:overcooked/newFlow/viewModel/walletViewModel.dart';
import 'package:overcooked/newFlow/widgets/agentCardWidget.dart';
import 'package:provider/provider.dart';

class CompleteYourSessionScreen extends StatefulWidget {
  final AllTherapistModel? therapist;
  const CompleteYourSessionScreen({super.key, this.therapist});

  @override
  State<CompleteYourSessionScreen> createState() => _CompleteYourSessionScreenState();
}

class _CompleteYourSessionScreenState extends State<CompleteYourSessionScreen> {

  String? token, userId, signUpToken;
  String? selectedCategoryId;
  int? selectedindex;
  bool? freeStatus;
  bool isSearch = false;
  String? balance;
  final FocusNode focusNode = FocusNode();
  final scrollController = ScrollController();
  SharedPreferencesViewModel sharedPreferencesViewModel =
  SharedPreferencesViewModel();
  SessionViewModel? sessionData;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Complete your session"),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<SlotsViewModel>(
                builder: (context, value2, child) {
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
                      widget.therapist!.name!.trimLeft().trimRight());
                  return AgentCardWidget(
                    normalPrice: widget.therapist!
                        .feesPerMinuteOfTenMinute!
                        .toStringAsFixed(0),
                    rating: widget.therapist!.avgRating!.toInt(),
                    isRisingStar: widget.therapist!.risingStar,
                    // onCallTap: () {
                    //   int? balances = widget.therapist!.discountedFeesForTenMinute != 0
                    //       ? widget.therapist!.discountedFeesForTenMinute
                    //       : widget.therapist!.feesForTenMinute!;
                    //
                    //   if (value.walletModel!.balance! < balances! && freeStatus == false) {
                    //     UtilsClass()
                    //         .showRatingBottomSheet(
                    //       context,
                    //       widget.therapist!.discountedFeesForTenMinute !=
                    //               0
                    //           ? widget.therapist!
                    //               .discountedFeesForTenMinute!
                    //               .toInt()
                    //           : widget.therapist!.feesForTenMinute!
                    //               .toInt(),
                    //       token.toString(),
                    //       '10',
                    //     );
                    //   }
                    //   else if (widget.therapist!.isAvailable == false) {
                    //     UtilsClass().showCustomDialog(context,
                    //       widget.therapist!.isFree == true && freeStatus == true ? '0' : widget.therapist!.feesForTenMinute == null ? '0' : widget.therapist!.discountedFeesForTenMinute == 0 ? widget.therapist!.feesForTenMinute.toString() : widget.therapist!.discountedFeesForTenMinute.toString(),
                    //       token,
                    //       widget.therapist!.sId,
                    //       widget.therapist!.name,
                    //       widget.therapist!.profileImg,
                    //       widget.therapist!.name,
                    //       widget.therapist!.discountedFeesPerMinuteOfTenMinute != 0
                    //           ? widget.therapist!
                    //               .feesPerMinuteOfTenMinute
                    //           : widget.therapist!
                    //               .feesPerMinuteOfTenMinute,
                    //       '10',
                    //       userId,
                    //       widget.therapist!.sId,
                    //       widget.therapist!.name,
                    //       true,
                    //     );
                    //   } else {
                    //     UtilsClass().showDialogWithoutTimer(context, widget.therapist!.isFree == true && freeStatus == true ? '0' : widget.therapist!.feesForTenMinute == 0
                    //               ? '0'
                    //               : widget.therapist!.discountedFeesForTenMinute == 0 ? widget.therapist!.feesForTenMinute.toString() : widget.therapist!.discountedFeesForTenMinute.toString(),
                    //       token,
                    //       widget.therapist!.sId,
                    //       widget.therapist!.name,
                    //       widget.therapist!.profileImg,
                    //       widget.therapist!.name,
                    //       widget.therapist!.discountedFeesPerMinuteOfTenMinute != 0
                    //           ? widget.therapist!
                    //               .discountedFeesPerMinuteOfTenMinute
                    //           : widget.therapist!
                    //               .feesPerMinuteOfTenMinute,
                    //       '10',
                    //       userId,
                    //       widget.therapist!.sId,
                    //       widget.therapist!.name,
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

                      value2.fetchAvailableSlotsAPi(widget.therapist!.sId, "$day").then((value){
                        if(value2.isAllSlotsAvailable == false){
                          paymentBottomSheet(widget.therapist!.sId, widget.therapist!.fees);
                        }else{
                          SelectSlotBottomSheet(widget.therapist!.sId, widget.therapist!.fees);
                          Future.delayed(Duration(seconds: 1), (){
                            if((now.weekday-1) >= 4){
                              scrollController.jumpTo(scrollController.position.maxScrollExtent);
                            }
                          });
                        }
                      });
                    },
                    isHomeScreen: true,
                    isAvailble: widget.therapist!.isAvailable,
                    isFree: widget.therapist!.isFree == true && freeStatus == true ? true : false,
                    name: formattedName,
                    language: widget.therapist!.language!.reversed.toList(),
                    price: widget.therapist!.discountedFeesForTenMinute == 0 ? widget.therapist!.feesForTenMinute!.toStringAsFixed(2) : widget.therapist!.discountedFeesForTenMinute!.toStringAsFixed(2),
                    oneMintPrice: widget.therapist!.discountedFeesPerMinuteOfTenMinute != 0 ? widget.therapist!.discountedFeesPerMinuteOfTenMinute!.toStringAsFixed(0)
                        : widget.therapist!.feesPerMinuteOfTenMinute != 0 ? widget.therapist!.feesPerMinuteOfTenMinute!.toStringAsFixed(0) : '',
                    discountPrice: widget.therapist!.isFree == true && freeStatus == true ? '0'
                        : widget.therapist!.discountedFeesForTenMinute == 0 ? ''
                        : widget.therapist!.discountedFeesForTenMinute!.toStringAsFixed(0),
                    theraPistCate: widget.therapist!.psychologistCategory,
                    theraPistSubCate: widget.therapist!.qualification,
                    image: widget.therapist!.profileImg,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    onCardTap: () {
                      Navigator.pushNamed(context,
                          RoutesName.expertScreen,
                          arguments: {
                            'id': widget.therapist!.sId,
                            "balance": "0",
                            "fees": widget.therapist!.fees,
                          });
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

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
                                                    "${value.availableSlotsList[index]!.slotId!.slot}",
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
                                Navigator.pop(context);

                                int finalAmount;

                                if (fee == 0) {
                                  finalAmount = 0;
                                } else {
                                  int tenPercent = (fee * (value.commissionValue! / 100)).toInt();
                                  finalAmount = fee - tenPercent;
                                }

                                // UtilsClass().showRatingBottomSheet(
                                //     context,
                                //     finalAmount,
                                //     token!,
                                //     "59",
                                //     value.commissionValue,
                                //     id,
                                //     value.isAllSlotsAvailable,
                                //     value.slotId
                                // );
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
                          onTap: (){
                            var data = {
                              "slots": value.availableSlotsList
                            };

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
