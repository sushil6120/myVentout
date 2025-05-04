import 'package:flutter/material.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:shimmer/shimmer.dart';

class BannerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey,
          period: Duration(seconds: 2),
          child: Container(
            width: context.deviceWidth,
            height: context.deviceHeight * .22,
            margin: EdgeInsets.symmetric(vertical: 8,horizontal: 2),
            padding: EdgeInsets.only(left: 14, right: 14, top: 2, bottom: 2),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }
}
