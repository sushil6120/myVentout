// Import the necessary packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
// Import the intl package
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AlertDialogTimer extends StatefulWidget {
  String fees,
      token,
      id,
      channelName,
      image,
      name,
      sessiontime,
      userId,
      targatedUserId,
      targatedUserName;
  double perMintFee;
  bool isSessionScreen;
  AlertDialogTimer(
      {super.key,
      required this.fees,
      required this.token,
      required this.id,
      required this.channelName,
      required this.sessiontime,
      required this.userId,
      required this.targatedUserId,
      required this.targatedUserName,
      required this.image,
      required this.name,
      required this.perMintFee,
      required this.isSessionScreen});

  @override
  State<AlertDialogTimer> createState() => _AlertDialogTimerState();
}

class _AlertDialogTimerState extends State<AlertDialogTimer> {
  String _selectedGender = 'Call';
  TimeOfDay selectedTime = TimeOfDay.now();

  TimeOfDay get minimumSelectableTime {
    final now = DateTime.now();
    final twoHoursLater = now.add(Duration(hours: 2));
    return TimeOfDay(hour: twoHoursLater.hour, minute: twoHoursLater.minute);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: minimumSelectableTime,
      builder: (BuildContext context, Widget? child) {
        return Localizations.override(
          context: context,
          locale: Locale('en', 'US'),
          child: Theme(
            data: ThemeData(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Colors.black,
                hourMinuteTextColor: Colors.white,
                dialHandColor: Colors.green,
                dayPeriodColor: Colors.green,
                hourMinuteColor: Colors.grey.shade800,
                dialBackgroundColor: Colors.grey.shade800,
                dialTextColor: MaterialStateColor.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.black;
                  }
                  return Colors.white;
                }),
                entryModeIconColor: Colors.green,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null && _isValidTime(picked)) {
      setState(() {
        selectedTime = picked;
      });
    } else if (picked != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a time at least 2 hours later than now.')),
      );
    }
  }

  bool _isValidTime(TimeOfDay picked) {
    final now = DateTime.now();
    final pickedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      picked.hour,
      picked.minute,
    );

    // Add 2 hours to current time
    final twoHoursLater = now.add(Duration(hours: 2));
    return pickedDateTime.isAfter(twoHoursLater);
  }

  String getPeriodString(TimeOfDay time) {
    return time.period == DayPeriod.am ? 'AM' : 'PM';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: popupColor),
      color: backgroundColor2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.close),
            ),
          ),
          widget.image == null || widget.image.isEmpty
              ? CircleAvatar(
                  radius: MediaQuery.of(context).size.width * .12,
                  backgroundImage: AssetImage('assets/img/acc.png'),
                )
              : CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: MediaQuery.of(context).size.width * .12,
                  backgroundImage: NetworkImage(widget.image),
                ),
          SizedBox(height: 10),
          Text(
            widget.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * .044,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'This offer at ₹ ${widget.perMintFee.toStringAsFixed(2)}/min is for ${widget.sessiontime} mins only.',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * .036,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (var amount in ['Call', 'Video',])
                ChoiceChip(
                  padding: EdgeInsets.zero,
                  label: Container(
                    decoration: BoxDecoration(
                      color: _selectedGender == amount
                          ? Color(0xff003D2A)
                          : popupColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 9, horizontal: 24),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          amount == 'Call'
                              ? Icons.call
                              : amount == 'Video'
                                  ? Icons.videocam
                                  : CupertinoIcons.chat_bubble_fill,
                          color: _selectedGender == amount
                              ? greenColor
                              : Colors.white,
                          size: MediaQuery.of(context).size.width *
                              .036, // You can adjust the icon size
                        ),
                        SizedBox(width: 4), // Space between icon and text
                        Text(
                          '$amount',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * .034,
                            color: _selectedGender == amount
                                ? greenColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  showCheckmark: false,
                  side: BorderSide(
                      color: _selectedGender == amount
                          ? Color(0xff003D2A)
                          : Colors.white,
                      width: 0.7),
                  selected: _selectedGender == amount,
                  labelPadding: EdgeInsets.zero,
                  backgroundColor:
                      _selectedGender == amount ? popupColor : popupColor,
                  onSelected: (selected) {
                    setState(() {
                      _selectedGender = (selected ? amount : null)!;
                      print(_selectedGender);
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              _selectTime(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Your\nsession',
                    style: GoogleFonts.inter(
                        fontSize: MediaQuery.of(context).size.width * .03),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .14,
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xff202020),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50))),
                        child: Center(
                          child: Text(
                            selectedTime.hourOfPeriod.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 1,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .14,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: Color(0xff202020),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50),
                                bottomRight: Radius.circular(50))),
                        child: Center(
                          child: Text(
                            selectedTime.minute.toString().padLeft(2, '0'),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                  Text(
                    '${getPeriodString(selectedTime)} ▾',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 18),
          Consumer<SessionViewModel>(
            builder: (context, value, child) {
              return GestureDetector(
                onTap: () {
                  DateTime now = DateTime.now();
                  DateTime selectedDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  value.createSessionApis(
                    widget.fees,
                    widget.sessiontime,
                    selectedDateTime.toIso8601String(),
                    widget.token,
                    widget.id,
                    false,
                    widget.channelName,
                    _selectedGender,
                    widget.name,
                    widget.image,
                    widget.userId,
                    widget.targatedUserId,
                    widget.targatedUserName,
                    widget.isSessionScreen,
                    context,
                  );
                  Get.back();
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    margin: EdgeInsets.only(right: 16, left: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: primaryColor),
                        color: primaryColor),
                    child: Center(
                      child: value.isLoading == true
                          ? LoadingAnimationWidget.waveDots(
                              color: Colors.white,
                              size: 30,
                            )
                          : Text(
                              'Start $_selectedGender @ ${widget.perMintFee.toStringAsFixed(1)}/min ',
                              style: GoogleFonts.inter(
                                  fontSize:
                                      MediaQuery.of(context).size.width * .034,
                                  color: Colors.black),
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
