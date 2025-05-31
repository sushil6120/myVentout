import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/newFlow/viewModel/utilsClass.dart';
import 'package:overcooked/newFlow/widgets/color.dart';
import 'package:stroke_text/stroke_text.dart';

class AmountButton extends StatelessWidget {
  final int amount;
  final bool isSelected;
  final bool isMostPopular;
  final VoidCallback onTap;

  AmountButton({
    required this.amount,
    required this.isSelected,
    this.isMostPopular = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .006,
            ),
            margin: EdgeInsets.only(
              right: Platform.isAndroid ? 20 : 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: .5,
                  color: isSelected ? Colors.transparent : colorLightWhite),
              color: isSelected ? Color(0xff003D2A) : Colors.transparent,
            ),
            child: Center(
                child: StrokeText(
              text: '₹ $amount',
              textStyle: GoogleFonts.inter(
                fontSize: MediaQuery.of(context).size.width * .048,
                fontWeight: FontWeight.w400,
                color: isSelected ? primaryColor : colorLightWhite,
              ),
              strokeWidth: 1.6,
              strokeColor: Colors.transparent,
            )),
          ),
        ),
        if (isMostPopular)
          Positioned(
            top: 0,
            left: 15,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                color: Color(0xffA7534D),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      size: 10,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      'Most Popular',
                      style: GoogleFonts.inter(
                          fontSize: 8.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
