import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/newFlow/viewModel/slotsViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilsClass.dart';
import 'package:provider/provider.dart';

SelectSlotBottomSheet(
String   amountFees, id, fee, token, ScrollController scrollController, BuildContext context,
    {required String userId}) {
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
                            children: List.generate(daysToUse.length, (index) {
                              final originalIndex = value.days.indexWhere(
                                  (day) =>
                                      day["key"] == daysToUse[index]["key"]);

                              bool isToday = false;
                              if (daysToUse[index].containsKey("dayIndex")) {
                                isToday = daysToUse[index]["dayIndex"] ==
                                    currentDayOfWeek;
                              } else if (daysToUse[index].containsKey("day")) {
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
                              } else if (daysToUse[index].containsKey("key") &&
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
                                    print("dyssss :${daysToUse[index]["key"]}");
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
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
                                        borderRadius: BorderRadius.circular(2),
                                        color: colorDark2.withOpacity(.5)),
                                  ),
                                  Text(
                                    "Booked",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
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
                                                  DateTime selectedDate = DateTime
                                                      .parse(value.days[value
                                                              .daysTappedIndex]
                                                          ["key"]);
                                                  DateTime todayDate = DateTime(
                                                      now.year,
                                                      now.month,
                                                      now.day);
                                                  isToday = selectedDate
                                                      .isAtSameMomentAs(
                                                          todayDate);
                                                } else {
                                                  String dayName = value.days[
                                                          value.daysTappedIndex]
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

                                                  String timeOnly = startTimeStr
                                                      .replaceAll("AM", "")
                                                      .replaceAll("am", "")
                                                      .replaceAll("PM", "")
                                                      .replaceAll("pm", "");

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
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: (isSlotPassed ||
                                                              value
                                                                      .availableSlotsList[
                                                                          index]!
                                                                      .status ==
                                                                  false)
                                                          ? Colors.grey
                                                              .withOpacity(0.3)
                                                          : (value.slotId ==
                                                                  value
                                                                      .availableSlotsList[
                                                                          index]!
                                                                      .slotId!
                                                                      .sId)
                                                              ? popupColor
                                                              : colorDark4,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
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
                                                              .withOpacity(0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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

                                  if (fee == 0) {
                                    finalAmount = 0;
                                  } else {
                                    int tenPercent =
                                        ((double.tryParse(fee.toString()) ??
                                                    0.0) *
                                                (value.commissionValue! / 100))
                                            .toInt();

                                    finalAmount =
                                        (double.tryParse(fee.toString()) ?? 0.0)
                                                .toInt() +
                                            tenPercent;
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
                                child: Container(
                                  width: double.infinity,
                                  height: 52,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: greenColor,
                                      borderRadius: BorderRadius.circular(60)),
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
