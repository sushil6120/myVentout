// Import the necessary packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/utilsFunction.dart';
import 'package:overcooked/newFlow/callScreens/callScreen.dart';
import 'package:overcooked/newFlow/callScreens/videoCallScreen.dart';
import 'package:overcooked/newFlow/callScreens/chatScreen.dart';
import 'package:overcooked/newFlow/viewModel/homeViewModel.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilsClass.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AlertDialogWithoutTimer extends StatefulWidget {
  String fees,
      token,
      id,
      channelName,
      image,
      name,
      sessionTime,
      userId,
      targatedUserId,
      targatedUserName;
  double perMintFee;
  bool isSessionScreen;
  AlertDialogWithoutTimer({
    super.key,
    required this.fees,
    required this.token,
    required this.id,
    required this.sessionTime,
    required this.userId,
    required this.targatedUserId,
    required this.targatedUserName,
    required this.channelName,
    required this.image,
    required this.name,
    required this.perMintFee,
    required this.isSessionScreen,
  });

  @override
  State<AlertDialogWithoutTimer> createState() =>
      _AlertDialogWithoutTimerState();
}

class _AlertDialogWithoutTimerState extends State<AlertDialogWithoutTimer> {
  String _selectedGender = 'Call';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: backgroundColor2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 30, top: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close),
              ),
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
          widget.isSessionScreen == true
              ? Text(
                  'Book a 45-minute session for ₹${widget.fees} rupees.',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * .036,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )
              : Text(
                  'This offer at ₹ ${widget.perMintFee.toStringAsFixed(2)}/min is for ${widget.sessionTime} mins only.',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * .036,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (var amount in [
                'Call',
                'Video',
              ])
                ChoiceChip(
                  padding: EdgeInsets.zero,
                  label: Container(
                    decoration: BoxDecoration(
                      color: _selectedGender == amount
                          ? Color(0xff003D2A)
                          : popupColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 9, horizontal: 20),
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
                          size: MediaQuery.of(context).size.width * .036,
                        ),
                        SizedBox(width: 4),
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
                    width: 0.7,
                  ),
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
                    now.hour,
                    now.minute,
                  );

                  // value.createSessionApis(
                  //   widget.fees,
                  //   widget.sessionTime,
                  //   selectedDateTime.toIso8601String(),
                  //   widget.token,
                  //   widget.id,
                  //   true,
                  //   widget.channelName,
                  //   _selectedGender,
                  //   widget.name,
                  //   widget.image,
                  //   widget.userId,
                  //   widget.targatedUserId,
                  //   widget.targatedUserName,
                  //   widget.isSessionScreen,
                  //   context,
                  // );
                  Get.back();
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    margin: EdgeInsets.only(right: 40, left: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: primaryColor),
                      color: primaryColor,
                    ),
                    child: Center(
                      child: value.isLoading == true
                          ? LoadingAnimationWidget.waveDots(
                              color: Colors.white,
                              size: 30,
                            )
                          : Text(
                              widget.isSessionScreen == true
                                  ? 'Start Session'
                                  : 'Start mini session @ ₹ ${widget.perMintFee.toStringAsFixed(2)}/min ',
                              style: GoogleFonts.inter(
                                fontSize:
                                    MediaQuery.of(context).size.width * .034,
                                color: Colors.black,
                              ),
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
