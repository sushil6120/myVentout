import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/assetConstants.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/Utils/valueConstants.dart';
import 'package:overcooked/newFlow/model/storyModel.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';
import 'package:overcooked/newFlow/viewModel/utilsClass.dart';

class StoryWidget extends StatelessWidget {
  final List<StoryModel> storyList;
  StoryWidget({super.key, required this.storyList});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return PageView.builder(
        //shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: storyList.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: () {
              // Navigator.pushNamed(context, RoutesName.StoryScreen,
              //     arguments: {
              //       'cateid': data.categoryId![0].toString(),
              //       'id': data.sId
              //     });
              Navigator.pushNamed(context, RoutesName.StoryScreen,
                  arguments: {
                    'cateid': storyList[index].categoryId![0].sId.toString(),
                    'id': storyList[index].sId
                  });

              print("'cateid': ${storyList[index].categoryId![0].sId.toString()},\n 'id': ${storyList[index].sId}");
            },
            child: Container(
              width: context.deviceWidth,
              height: context.deviceHeight - (context.safeAreaHeight + context.appBarHeight+ 170) ,
              margin: EdgeInsets.symmetric(
                  horizontal: Platform.isAndroid ? 14 : 20.0, vertical: 20),
              padding: EdgeInsets.only(
                  left: 10,
                  bottom: 20,
                  right: 10,
                  top: 30),
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
                borderRadius: BorderRadius.circular(60),
                border: Border.all(color: colorLightWhite, width: .9),
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 14, right: 14),
                    child: Text(
                      storyList[index].title.toString(),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * .054,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 14, right: 14, top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            "${storyList[index].image.toString()}",
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, e, t){
                              return SizedBox(
                                width: 150,
                                height: 150,
                                child: SvgPicture.asset(
                                    AppAssets.ocLogo),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                storyList[index].shortDescription !=
                                    null
                                    ? '"${storyList[index].shortDescription}"'
                                    : '',
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize:
                                  MediaQuery.of(context).size.width *
                                      .038,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: verticalSpaceSmall),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white.withOpacity(.1)),
                                child: Text(
                                  storyList[index].categoryId![0] ==
                                      null
                                      ? ''
                                      : "${storyList[index]
                                      .categoryId![0].emoji
                                      .toString()} ${storyList[index]
                                      .categoryId![0].categoryName
                                      .toString()}",
                                  style:
                                  const TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 14, right: 14, top: 5),
                    child: Text(
                      "${storyList[index].description.toString()}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 12,
                      style: TextStyle(
                          fontSize:
                          MediaQuery.of(context).size.width * .041,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 26.0),
                ],
              ),
            ),
          );
        },
        // separatorBuilder: (context, index){
        //   return SizedBox(height: 0);
        // }
        );
  }
}
