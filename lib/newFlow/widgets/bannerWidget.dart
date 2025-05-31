import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/model/storyModel.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';
import 'package:overcooked/newFlow/viewModel/utilsClass.dart';

class BannerWidget extends StatelessWidget {
  List<StoryModel> storyList;
  BannerWidget({super.key, required this.storyList});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 0.86,
        autoPlay: true,
        aspectRatio: 2.0,
        enlargeCenterPage: false,
      ),
      items: storyList.map((data) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.StoryScreen,
                    arguments: {
                      'cateid': data.categoryId!.first.sId,
                      'id': data.sId
                    });
              },
              child: Container(
                width: context.deviceWidth,
                margin: EdgeInsets.symmetric(
                    horizontal: Platform.isAndroid ? 14 : 20.0, vertical: 14),
                padding: EdgeInsets.only(
                    left: 16,
                    bottom: context.deviceHeight * .01,
                    right: 10,
                    top: context.deviceHeight * .000),
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      blurRadius: 6,
                      offset: Offset(0, 6),
                      spreadRadius: 4
                    )
                  ],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: colorLightWhite, width: .9),
                  color: Colors.black,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    Text(
                      data.title.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * .05,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0, left: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              width: 95,
                              height: 95,
                              child: Image.network(
                                  fit: BoxFit.cover, data.image.toString()),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: Text(
                                style: GoogleFonts.inter(
                                  fontSize: height * .016,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                data.description.toString()))
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
