import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overcooked/Utils/components.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/resultScreen.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:overcooked/newFlow/viewModel/slotsViewModel.dart';
import 'package:overcooked/newFlow/widgets/selectSlotBottomSheet.dart';
import 'package:provider/provider.dart';
import 'package:overcooked/newFlow/model/allTherapistModel.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:overcooked/newFlow/viewModel/homeViewModel.dart';
import 'package:overcooked/newFlow/widgets/filterAgentCards.dart';

import '../../Utils/colors.dart';
import '../screens/questionsScreen/widget/testButtonWidget.dart';
import '../therapistChatscreens/widgets/chatHomeCardWidget.dart';

class TherapistListScreen extends StatefulWidget {
  final List<AllTherapistModel> therapists;
  int totalPonts;
  bool isRegistered;

  TherapistListScreen(
      {Key? key,
      required this.therapists,
      required this.isRegistered,
      required this.totalPonts})
      : super(key: key);

  @override
  State<TherapistListScreen> createState() => _TherapistListScreenState();
}

class _TherapistListScreenState extends State<TherapistListScreen> {
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();
  final scrollController = ScrollController();
  bool freeStatus = false;
  String token = '', userId = '', signUpToken = '';

  @override
  void initState() {
    super.initState();
    Future.wait([sharedPreferencesViewModel.getFreeStatus()]).then((value) {
      freeStatus = value[0] ?? false;
      print("sl ${freeStatus}");
    });

    Future.wait([
      sharedPreferencesViewModel.getFreeStatus(),
      sharedPreferencesViewModel.getUserId()
    ]).then((value) {
      userId = value[1]?.toString() ?? '';
      print("sl ${freeStatus}");
    });

    Future.wait([
      sharedPreferencesViewModel.getSignUpToken(),
      sharedPreferencesViewModel.getToken(),
      sharedPreferencesViewModel.getUserId(),
    ]).then(
      (value) {
        signUpToken = value[0] ?? '';
        token = value[1] ?? '';
        userId = value[2] ?? '';

        if (token.isEmpty) {
          token = signUpToken;
        }
      },
    );
  }

  String capitalizeName(String name) {
    if (name.isEmpty) return '';

    return name
        .trim()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final sessionData = Provider.of<SessionViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, RoutesName.bottomNavBarView, (route) => false);
          },
        ),
        title: Text(
          'My Psychologist',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, value, child) {
          return Column(
            children: [
              widget.totalPonts > 7
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 20),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                              text: "With your given scores,",
                            ),
                            TextSpan(
                              text:
                                  " we strongly recommend you to try therapy.",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text:
                                  " We've shared your Overcooked Depression Screening results with our psychologists:",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              Consumer<HomeViewModel>(
                builder: (context, value, child) {
                  return widget.totalPonts > 7
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: TestResultButton(
                            testName: "Depression Screening Result",
                            resultStatus: getDepressionLevel(
                                value.userProfileModel?.totalValue ?? 0),
                            onTap: () {
                              Get.to(UserResultNameScreen(
                                  totalScroe: widget.totalPonts.toString()));
                            },
                          ),
                        )
                      : SizedBox.shrink();
                },
              ),
              ChatHomeCardWidget(
                userId: userId,
                iconColor: colorLightWhite,
              ),
              Expanded(
                child: widget.therapists.isEmpty
                    ? Center(
                        child: Text(
                        "No therapists available",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ))
                    : widget.totalPonts < 7
                        ? Center(
                            child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "No significant need of therapy. You're absolutely alright. Enjoy your day.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.therapists.length,
                            itemBuilder: (context, index) {
                              var item = widget.therapists[index];
                              String formattedName = capitalizeName(
                                  item.name?.trimLeft().trimRight() ?? '');
                              return Consumer<SlotsViewModel>(
                                builder: (context, value2, child) {
                                  return FilterAgentCardWidget(
                                    normalPrice:
                                        item.feesPerMinuteOfTenMinute != null
                                            ? item.feesPerMinuteOfTenMinute!
                                                .toStringAsFixed(0)
                                            : '0',
                                    rating: item.avgRating?.toInt() ?? 0,
                                    isRisingStar: item.risingStar ?? false,
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
                                      String day = days[now.weekday % 7];
                                      value2.updateIndex(now.weekday % 7);

                                      var discountedFees =
                                          item.discountedFees ?? 0;
                                      var fees = item.fees ?? 0;

                                      var selectedFee =
                                          discountedFees.toString().isNotEmpty
                                              ? discountedFees
                                              : fees;

                                      double feesValue = selectedFee is String
                                          ? double.tryParse(
                                                  selectedFee.toString()) ??
                                              0.0
                                          : selectedFee.toDouble();

                                      double balanceValue = double.tryParse(
                                              value.walletModel?.balance
                                                      ?.toString() ??
                                                  '0') ??
                                          0.0;

                                      double finalAmount =
                                          feesValue > balanceValue
                                              ? feesValue - balanceValue
                                              : 0.0;

                                      value2.fetchAvailableSlotsAPi(
                                          item.sId ?? '', day);

                                      SelectSlotBottomSheet(
                                          finalAmount.toString(),
                                          userId: userId,
                                          item.sId ?? '',
                                          finalAmount,
                                          token,
                                          scrollController,
                                          context);
                                    },
                                    isHomeScreen: true,
                                    isAvailble: item.isAvailable ?? false,
                                    isFree: (item.isFree == true &&
                                        freeStatus == true),
                                    name: formattedName,
                                    language:
                                        item.language?.reversed.toList() ?? [],
                                    price: item.discountedFees != null &&
                                            item.discountedFees
                                                .toString()
                                                .isNotEmpty
                                        ? item.discountedFees.toString()
                                        : item.fees?.toString() ?? '0',
                                    oneMintPrice: item
                                                    .discountedFeesPerMinuteOfTenMinute !=
                                                null &&
                                            item.discountedFeesPerMinuteOfTenMinute !=
                                                0
                                        ? item
                                            .discountedFeesPerMinuteOfTenMinute!
                                            .toStringAsFixed(0)
                                        : item.feesPerMinuteOfTenMinute !=
                                                    null &&
                                                item.feesPerMinuteOfTenMinute !=
                                                    0
                                            ? item.feesPerMinuteOfTenMinute!
                                                .toStringAsFixed(0)
                                            : '0',
                                    discountPrice: item.discountedFees ==
                                                null ||
                                            item.discountedFees == 0
                                        ? ''
                                        : item.fees == null || item.fees == 0
                                            ? ''
                                            : item.fees!.toStringAsFixed(0),
                                    theraPistCate:
                                        item.psychologistCategory ?? '',
                                    theraPistSubCate: item.qualification ?? '',
                                    image: item.profileImg ?? '',
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    onCardTap: () {
                                      Navigator.pushNamed(
                                          context, RoutesName.expertScreen,
                                          arguments: {
                                            'id': item.sId ?? '',
                                            "balance":
                                                value.walletModel?.balance ?? 0
                                          });
                                    },
                                  );
                                },
                              );
                            },
                          ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: customButton(() {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RoutesName.bottomNavBarView, (route) => false);
                }, context.deviceWidth, 50, 'Return to home screen', false),
              ),
              SizedBox(
                height: 8,
              ),
              Center(
                  child: Text(
                "Check your Results instantly above.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: colorLight2),
              )),
              SizedBox(
                height: 28,
              )
            ],
          );
        },
      ),
    );
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
