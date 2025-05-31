import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../Utils/colors.dart';

class SuccessfullWidget extends StatefulWidget {
  String image, name, userId, targatedUserId, targatedUserName;
  VoidCallback onTap;
  String bookingType;
  bool isSessionScreen;
  SuccessfullWidget(
      {super.key,
      required this.image,
      required this.name,
      required this.bookingType,
      required this.userId,
      required this.targatedUserId,
      required this.targatedUserName,
      required this.isSessionScreen,
      required this.onTap});

  @override
  State<SuccessfullWidget> createState() => _SuccessfullWidgetState();
}

class _SuccessfullWidgetState extends State<SuccessfullWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .45,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'You’re all set!',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.only(
                          left: 18, right: 18, top: 18, bottom: 18),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: greenColor)),
                      child: SvgPicture.asset('assets/img/crowns.svg')),
                  SizedBox(
                    height: 6,
                  ),
                  // Center(
                  //   child: SizedBox(
                  //       width: context.deviceWidth * .18,
                  //       child: Text(
                  //         'Kunal',
                  //         maxLines: 1,
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //             fontSize: 10, color: Colors.white),
                  //       )),
                  // )
                ],
              ),
              Center(
                child: SizedBox(
                  width: context.deviceWidth * .4,
                  child: DottedLine(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    lineLength: double.infinity,
                    lineThickness: 1.0,
                    dashLength: 4.0,
                    dashColor: Colors.black,
                    dashRadius: 0.0,
                    dashGapLength: 4.0,
                    dashGapColor: Colors.transparent,
                    dashGapGradient: [Colors.grey, Colors.grey],
                    dashGapRadius: 0.0,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.image == null || widget.image.isEmpty
                      ? CircleAvatar(
                          radius: MediaQuery.of(context).size.width * .068,
                          backgroundImage: AssetImage('assets/img/acc.png'),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: MediaQuery.of(context).size.width * .068,
                          backgroundImage: NetworkImage(widget.image),
                        ),
                  SizedBox(
                    height: 6,
                  ),
                  Center(
                    child: SizedBox(
                        width: context.deviceWidth * .16,
                        child: Text(
                          widget.name,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        )),
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 22, left: 26),
            child: Text(
              'You will be connecting with ${widget.name.toUpperCase()}',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3, left: 26),
            child: Text(
              widget.isSessionScreen == false ? '02:00 Min' : " once he accept the call.",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w400, color: widget.isSessionScreen == false ? greenColor:colorLightWhite),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, RoutesName.bottomNavBarView);
            },
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                margin: EdgeInsets.only(right: 16, left: 16, top: 18),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: greenColor),
                    color: greenColor),
                child: Center(
                  child: Text(
                    'Okay',
                    style: GoogleFonts.inter(
                        fontSize: MediaQuery.of(context).size.width * .032,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
