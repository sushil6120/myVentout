import 'package:flutter/material.dart';
import 'package:ventout/newFlow/routes/routeName.dart';

class AppBarWidget extends StatelessWidget {
  String title, subtitle, filterTitle;

  AppBarWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.filterTitle,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      decoration: BoxDecoration(color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 38,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
          ),
          // SizedBox(
          //   height: 8,
          // ),
          // Text(
          //   subtitle,
          //   style: TextStyle(
          //       fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),
          // ),
          SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }
}
