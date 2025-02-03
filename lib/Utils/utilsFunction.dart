import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overcooked/Utils/valueConstants.dart';
import 'colors.dart';
import 'package:intl/intl.dart';


class Utils {
  static void toastMessage(String message, {ToastGravity gravity = ToastGravity.BOTTOM}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void flushBarErrorMessage({
    required String message,
    required BuildContext context,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18.5),
        shouldIconPulse: false,
        icon: Icon(
          icon,
          color: color,
        ),
        isDismissible: true,
        message: message,
        messageColor: color,
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
        flushbarPosition: FlushbarPosition.TOP,
      )..show(context),
    );
  }

  static void flushBarErrorMessageWithButton({
    required String message,
    required BuildContext context,
    required String buttonText,
    void Function(Flushbar<dynamic>)? onTap,
  }) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18.5),
        shouldIconPulse: false,
        icon: const Icon(
          Icons.error_outline_rounded,
          color: colorLightWhite,
        ),
        mainButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: colorLightWhite,
                  decoration: TextDecoration.underline,
                  decorationColor: primaryColor,
                ),
          ),
        ),
        onTap: onTap,
        isDismissible: true,
        message: message,
        duration: const Duration(seconds: 20),
        flushbarPosition: FlushbarPosition.BOTTOM,
      )..show(context),
    );
  }

  static void flushBarErrorMessageBottom({
    required String message,
    required BuildContext context,
  }) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        backgroundColor: primaryColor,
        messageColor: colorLightWhite,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 65),
        borderRadius: BorderRadius.circular(radiusValue),
        shouldIconPulse: false,
        isDismissible: true,
        message: message,
        duration: const Duration(seconds: 4),
        flushbarPosition: FlushbarPosition.BOTTOM,
      )..show(context),
    );
  }

  static void snackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: colorLightWhite),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusValue))),
      backgroundColor: primaryColorDark,
    ));
  }

  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}



extension CustomDateFormat on DateTime {
  String get intDate {
    return DateFormat('dd').format(this);
  }

  String get getDay {
    return DateFormat.E().format(this);
  }

  String get getMonth {
    return DateFormat('MMM').format(this);
  }

  String get getYear {
    return DateFormat('yyyy').format(this);
  }

  String get wellFormattedDate {
    return DateFormat('MMM E dd, hh:mm a').format(this);
  }

String get wellDated {
    return DateFormat('dd MMM yyyy').format(this);
  }

  String get time {
    return DateFormat('hh:mm a').format(this);
  }

  String get endTime {
    return DateFormat('h:mm a').format(this);
  }

  String get eventTime {
    return DateFormat('dd MMM | h:mm a').format(this);
  }
}

List<String> reachMeOutList = [
  'Students',
  'Young Adults',
  'Working Professionals',
  'Teenagers',
  'Parents',
  'Married Couples',
  'Artists',
  'LGBTQ+ Community',
  'Elderly Individuals',
  'Entrepreneurs',
  'Athletes',
  'Single Parents',
  'Veterans',
  'Immigrants',
  'Individuals with Disabilities',
  'People with Chronic Illnesses',
  'Survivors of Abuse',
  'Grieving Individuals',
  'Substance Abusers',
  'Divorcees',
];

