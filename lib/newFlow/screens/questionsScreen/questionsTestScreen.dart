import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/valueConstants.dart';
import 'package:overcooked/newFlow/resultScreen.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/shimmer/walletHistoryShimmer.dart';
import 'package:provider/provider.dart';

import '../../routes/routeName.dart';
import '../../viewModel/homeViewModel.dart';
import '../../viewModel/slotsViewModel.dart';
import '../../widgets/filterAgentCards.dart';
import '../../widgets/questionsWidgetButton.dart';
import '../../widgets/selectSlotBottomSheet.dart';
import 'widget/testButtonWidget.dart';

class QuestionsTestScreen extends StatefulWidget {
  const QuestionsTestScreen({super.key});

  @override
  State<QuestionsTestScreen> createState() => _QuestionsTestScreenState();
}

class _QuestionsTestScreenState extends State<QuestionsTestScreen> {
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();
  final scrollController = ScrollController();
  bool? freeStatus;

  String? token, userId, signUpToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.wait([sharedPreferencesViewModel.getFreeStatus()]).then((value) {
      freeStatus = value[0];

      print("sl ${freeStatus}");
    });
    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);

    Future.wait([
      sharedPreferencesViewModel.getSignUpToken(),
      sharedPreferencesViewModel.getToken(),
      sharedPreferencesViewModel.getUserId(),
    ]).then(
      (value) {
        if (value[1] == null || value[1]!.isEmpty) {
          sharedPreferencesViewModel.saveToken(value[0]);
          token = value[0];
        }
        token = value[1];
        userId = value[2];
        signUpToken = value[0];
        getHomeData.userProfileApis(
            userId: userId.toString(),
            token: token == null ? value[0].toString() : token!);
        getHomeData.fetchFilterTherapistAPi(token!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: () async {
            final getHomeData =
                Provider.of<HomeViewModel>(context, listen: false);
            getHomeData.cachedFilterData.clear();
            await getHomeData.fetchFilterTherapistAPi(token!, isRefresh: true);
          },
          child: ListView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: verticalSpaceSmall,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Consumer<HomeViewModel>(
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Overcooked clinic',
                        //   style: const TextStyle(
                        //     fontSize: 28,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        // const SizedBox(height: 4),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withOpacity(0.2),
                                Colors.transparent
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            value.userProfileModel == null
                                ? 'Hello'
                                : "Hello ${value.userProfileModel!.name.toString()}",
                            style: TextStyle(
                              fontSize: 18,
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Consumer<HomeViewModel>(
                builder: (context, value, child) =>
                    value.userProfileModel == null
                        ? SizedBox.fromSize()
                        : QuestionsButtonWidget(
                            token: token.toString(),
                            pdfLink: value.userProfileModel!.pdf,
                            totalScrore: value.userProfileModel!.totalValue,
                          ),
              ),
              Consumer<HomeViewModel>(
                builder: (context, value, child) {
                  return value.userProfileModel != null &&
                          value.userProfileModel!.totalValue != 0 &&
                          value.userProfileModel!.totalValue > 7
                      ? TestResultButton(
                          testName: "Depression Screening Result",
                          resultStatus: getDepressionLevel(
                              value.userProfileModel!.totalValue),
                          onTap: () {
                            Get.to(UserResultNameScreen(
                                totalScroe: value.userProfileModel!.totalValue
                                    .toString()));
                          },
                        )
                      : SizedBox.shrink();
                },
              ),
              // SizedBox(
              //   height: verticalSpaceSmall,
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 14, right: 14),
              //   child: Text(
              //     "Am I depressed or just overthinking?",
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(
              //       fontSize: 18,
              //       color: colorDark3,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: verticalSpaceSmall,
              ),
              Consumer<HomeViewModel>(
                builder: (context, value, child) {
                  if (value.isLoading == true &&
                      value.isFirstFilterLoad &&
                      value.filterTherapistData.isEmpty) {
                    return ShimmerWalletTransactionItem();
                  } else if (value.filterTherapistData.isEmpty) {
                    return FutureBuilder(
                      future: Future.delayed(Duration(seconds: 4)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return ShimmerWalletTransactionItem();
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      itemCount: value.filterTherapistData.length,
                      itemBuilder: (context, index) {
                        var item = value.filterTherapistData[index];
                        String formattedName =
                            capitalizeName(item.name!.trimLeft().trimRight());
                        return Consumer<SlotsViewModel>(
                          builder: (context, value2, child) {
                            return FilterAgentCardWidget(
                              normalPrice: item.feesPerMinuteOfTenMinute!
                                  .toStringAsFixed(0),
                              rating: item.avgRating!.toInt(),
                              isRisingStar: item.risingStar,
                              onCallTap: () {
                                value2.updateSlotId("");
                                DateTime now = DateTime.now();
                                List<String> days = [
                                  'Sunday',
                                  'Monday',
                                  'Tuesday',
                                  'Wednesday',
                                  'Thursday',
                                  'Friday',
                                  'Saturday'
                                ];
                                String? day = days[now.weekday - 1];
                                value2.updateIndex(now.weekday - 1);
                                double feesValue = (item.discountedFees
                                            .toString()
                                            .isNotEmpty
                                        ? item.discountedFees
                                        : item.fees) is String
                                    ? double.tryParse(item.discountedFees
                                                .toString()
                                                .isNotEmpty
                                            ? item.discountedFees.toString()
                                            : item.fees.toString()) ??
                                        0.0
                                    : (item.discountedFees.toString().isNotEmpty
                                            ? item.discountedFees
                                            : item.fees)!
                                        .toDouble();

                                double balanceValue = double.tryParse(value
                                        .walletModel!.balance
                                        .toString()) ??
                                    0.0;

                                double finalAmount = feesValue > balanceValue
                                    ? (item.discountedFees.toString().isNotEmpty
                                            ? item.discountedFees
                                            : item.fees)! -
                                        balanceValue
                                    : 0.0;
                                value2.fetchAvailableSlotsAPi(item.sId, "$day");

                                SelectSlotBottomSheet(
                                  waletBalance:balanceValue.toString() ,
                                    feesValue.toString(),
                                    userId: userId.toString(),
                                    item.sId,
                                    finalAmount,
                                    token,
                                    scrollController,
                                    context);
                              },
                              isHomeScreen: true,
                              isAvailble: item.isAvailable,
                              isFree: item.isFree == true && freeStatus == true
                                  ? true
                                  : false,
                              name: formattedName,
                              language: item.language!.reversed.toList(),
                              price: item.discountedFees.toString().isNotEmpty
                                  ? item.discountedFees.toString()
                                  : item.fees.toString(),
                              oneMintPrice:
                                  item.discountedFeesPerMinuteOfTenMinute != 0
                                      ? item.discountedFeesPerMinuteOfTenMinute!
                                          .toStringAsFixed(0)
                                      : item.feesPerMinuteOfTenMinute != 0
                                          ? item.feesPerMinuteOfTenMinute!
                                              .toStringAsFixed(0)
                                          : '',
                              discountPrice: item.discountedFees == 0
                                  ? ''
                                  : item.fees!.toStringAsFixed(0) == 0
                                      ? ''
                                      : item.fees!.toStringAsFixed(0),
                              theraPistCate: item.psychologistCategory,
                              theraPistSubCate: item.qualification,
                              image: item.profileImg,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              onCardTap: () {
                                Navigator.pushNamed(
                                    context, RoutesName.expertScreen,
                                    arguments: {
                                      'id': item.sId,
                                      "balance": value.walletModel!.balance
                                    });
                              },
                            );
                          },
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  String capitalizeName(String name) {
    return name
        .trim()
        .split(' ')
        .where((word) => word.isNotEmpty) // Filter out empty words
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String getDepressionLevel(int score) {
    if (score <= 7) {
      return 'Normal\n(No significant signs of depression)';
    } else if (score <= 13) {
      return 'Mild Depression';
    } else if (score <= 18) {
      return 'Moderate Depression';
    } else if (score <= 22) {
      return 'Severe Depression';
    } else {
      return 'Very Severe Depression';
    }
  }
}
