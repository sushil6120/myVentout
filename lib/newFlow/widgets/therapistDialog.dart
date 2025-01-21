import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ventout/Utils/colors.dart';
import 'package:ventout/Utils/responsive.dart';
import 'package:ventout/newFlow/model/allTherapistModel.dart';
import 'package:ventout/newFlow/routes/routeName.dart';
import 'package:ventout/newFlow/services/sharedPrefs.dart';
import 'package:ventout/newFlow/viewModel/homeViewModel.dart';
import 'package:ventout/newFlow/widgets/agentCardWidget.dart';
import 'package:ventout/newFlow/widgets/filterAgentCards.dart';

import '../viewModel/utilsClass.dart';

class TherapistListDialog extends StatefulWidget {
  List<AllTherapistModel> therapists; // List of therapists to display

  TherapistListDialog({required this.therapists});

  @override
  State<TherapistListDialog> createState() => _TherapistListDialogState();
}

class _TherapistListDialogState extends State<TherapistListDialog> {
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();

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

    Future.wait([
      sharedPreferencesViewModel.getSignUpToken(),
      sharedPreferencesViewModel.getToken(),
      sharedPreferencesViewModel.getUserId(),
    ]).then(
      (value) {
        token = value[1];
        userId = value[2];
        signUpToken = value[0];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.only(left: 0, right: 0, top: 50, bottom: 10),
      contentPadding: EdgeInsets.only(top: 20),
      backgroundColor: Colors.black,
      title: Row(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, RoutesName.bottomNavBarView, (route) => false);
              },
              child: Icon(Icons.arrow_back_ios_new_rounded)),
          SizedBox(
            width: 8,
          ),
          Text(
            'My Psychologist',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      content: SizedBox(
          width: double.maxFinite,
          height: context.deviceHeight,
          child: Consumer<HomeViewModel>(
            builder: (context, value, child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 0),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text:
                                "Based on your recent evaluation, these are the ",
                          ),
                          TextSpan(
                            text:
                                "top ${widget.therapists.length} psychologist",
                            style: TextStyle(
                              color: Color(0xff00ECCA),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " we recommend you to interact with:",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.therapists.length,
                      itemBuilder: (context, index) {
                        var item = widget.therapists[index];
                        String capitalizeName(String name) {
                          return name
                              .trim()
                              .split(' ')
                              .where((word) =>
                                  word.isNotEmpty) // Filter out empty words
                              .map((word) =>
                                  word[0].toUpperCase() + word.substring(1))
                              .join(' ');
                        }

                        String formattedName =
                            capitalizeName(item.name!.trimLeft().trimRight());

                        if (widget.therapists.isEmpty == false) {
                          return FilterAgentCardWidget(
                            normalPrice: item.feesPerMinuteOfTenMinute!
                                .toStringAsFixed(0),
                            rating: item.avgRating!.toInt(),
                            isRisingStar: item.risingStar,
                            onCallTap: () {
                              int? balances =
                                  item.discountedFeesForTenMinute != 0
                                      ? item.discountedFeesForTenMinute
                                      : item.feesForTenMinute!;

                              if (value.walletModel!.balance! < balances! &&
                                  freeStatus == false) {
                                UtilsClass().showRatingBottomSheet(
                                  context,
                                  item.discountedFeesForTenMinute != 0
                                      ? item.discountedFeesForTenMinute!.toInt()
                                      : item.feesForTenMinute!.toInt(),
                                  token.toString(),
                                  '10',
                                );
                              } else if (item.isAvailable == false) {
                                UtilsClass().showCustomDialog(
                                  context,
                                  item.isFree == true && freeStatus == true
                                      ? '0'
                                      : item.feesForTenMinute == null
                                          ? '0'
                                          : item.discountedFeesForTenMinute == 0
                                              ? item.feesForTenMinute.toString()
                                              : item.discountedFeesForTenMinute
                                                  .toString(),
                                  token,
                                  item.sId,
                                  item.name,
                                  item.profileImg,
                                  item.name,
                                  item.discountedFeesPerMinuteOfTenMinute != 0
                                      ? item.feesPerMinuteOfTenMinute
                                      : item.feesPerMinuteOfTenMinute,
                                  '10',
                                  userId,
                                  item.sId,
                                  item.name,
                                  true,
                                );
                              } else {
                                UtilsClass().showDialogWithoutTimer(
                                  context,
                                  item.isFree == true && freeStatus == true
                                      ? '0'
                                      : item.feesForTenMinute == 0
                                          ? '0'
                                          : item.discountedFeesForTenMinute == 0
                                              ? item.feesForTenMinute.toString()
                                              : item.discountedFeesForTenMinute
                                                  .toString(),
                                  token,
                                  item.sId,
                                  item.name,
                                  item.profileImg,
                                  item.name,
                                  item.discountedFeesPerMinuteOfTenMinute != 0
                                      ? item.discountedFeesPerMinuteOfTenMinute
                                      : item.feesPerMinuteOfTenMinute,
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
                            isFree: item.isFree == true && freeStatus == true
                                ? true
                                : false,
                            name: formattedName,
                            language: item.language!.reversed.toList(),
                            price: item.discountedFeesForTenMinute == 0
                                ? item.feesForTenMinute!.toStringAsFixed(2)
                                : item.discountedFeesForTenMinute!
                                    .toStringAsFixed(2),
                            oneMintPrice:
                                item.discountedFeesPerMinuteOfTenMinute != 0
                                    ? item.discountedFeesPerMinuteOfTenMinute!
                                        .toStringAsFixed(0)
                                    : item.feesPerMinuteOfTenMinute != 0
                                        ? item.feesPerMinuteOfTenMinute!
                                            .toStringAsFixed(0)
                                        : '',
                            discountPrice:
                                item.isFree == true && freeStatus == true
                                    ? '0'
                                    : item.discountedFeesForTenMinute == 0
                                        ? ''
                                        : item.discountedFeesForTenMinute!
                                            .toStringAsFixed(0),
                            theraPistCate: item.psychologistCategory,
                            theraPistSubCate: item.qualification,
                            image: item.profileImg,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            onCardTap: () {
                              Navigator.pushNamed(
                                  context, RoutesName.expertScreen, arguments: {
                                'id': item.sId,
                                "balance": value.walletModel!.balance
                              });
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          )),
      actions: [
        Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          decoration: BoxDecoration(
              color: colorLightWhite, borderRadius: BorderRadius.circular(10)),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text(
              'Close',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: colorDark1),
            ),
          ),
        ),
      ],
    );
  }
}
