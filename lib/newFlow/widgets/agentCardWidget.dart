import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventout/Utils/colors.dart';
import 'package:ventout/Utils/responsive.dart';
import 'package:ventout/newFlow/homeScreen.dart';
import 'package:ventout/newFlow/routes/routeName.dart';
import 'package:ventout/newFlow/viewModel/utilsClass.dart';
import 'package:ventout/newFlow/widgets/color.dart';

class AgentCardWidget extends StatefulWidget {
  final VoidCallback? onTap, onCardTap, onCallTap;
  String? image, name, theraPistCate, theraPistSubCate;
  String? discountPrice, price, oneMintPrice, normalPrice;
  int rating;
  List<String>? language;
  bool? isFree;
  bool? isAvailble;
  bool? isHomeScreen;
  bool? isRisingStar; // Added this parameter
  AgentCardWidget(
      {super.key,
      required this.onTap,
      this.discountPrice,
      this.language,
      this.name,
      this.price,
      this.image,
      this.theraPistCate,
      this.isFree,
      this.isAvailble,
      this.isHomeScreen,
      this.oneMintPrice,
      this.onCardTap,
      this.onCallTap,
      required this.rating,
      required this.normalPrice,
      this.theraPistSubCate,
      this.isRisingStar // Default to false if not provided
      });

  @override
  State<AgentCardWidget> createState() => _AgentCardWidgetState();
}

class _AgentCardWidgetState extends State<AgentCardWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: widget.onCardTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 0, right: 0, bottom: 22),
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.12),
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                )
              ],
              color: const Color(0xff111111),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              height: height * 0.146, // Responsive height
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10,
                                top: widget.isRisingStar == true ? 0 : 0,
                                bottom: 0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryColor),
                              ),
                              child: widget.image == null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius:
                                          height * 0.044, // Responsive radius
                                      backgroundImage: const AssetImage(
                                          'assets/img/acc.png'),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius:
                                          height * 0.05, // Responsive radius
                                      backgroundImage:
                                          NetworkImage(widget.image!),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.name!,
                            style: TextStyle(
                              fontSize: height * 0.018, // Responsive font size
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: .14),
                          SizedBox(
                            width: width * 0.4,
                            child: Text(
                              widget.theraPistCate!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize:
                                    height * 0.014, // Responsive font size
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 1.4,
                              ),
                              SvgPicture.asset(
                                'assets/img/ribbon.svg',
                                height: 14,
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: width * 0.34, // Responsive width
                                child: Text(
                                  widget.theraPistSubCate!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        height * 0.016, // Responsive font size
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/img/world.svg',
                                height: 14,
                              ),
                              const SizedBox(width: 3.5),
                              ...List.generate(
                                widget.language!.length >= 3
                                    ? 2
                                    : widget.language!.length,
                                (index) => Text(
                                  "${widget.language![index]}${index != (widget.language!.length >= 3 ? 2 : widget.language!.length) - 1 ? ', ' : ''}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize:
                                        height * 0.016, // Responsive font size
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              widget.isFree == false &&
                                      widget.discountPrice != 0 &&
                                      widget.discountPrice!.isNotEmpty
                                  ? Text(
                                      '₹${widget.normalPrice}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: height * 0.018,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : const SizedBox(),
                              const SizedBox(width: 4),
                              widget.isFree == true
                                  ? Text(
                                      'Free',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: height * 0.018,
                                        color: const Color(0xffFF5C5C),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Text(
                                      widget.isHomeScreen == true
                                          ? '₹ ${widget.oneMintPrice}/min'
                                          : widget.discountPrice != 0
                                              ? '₹${widget.discountPrice}'
                                              : '₹${widget.price}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: height *
                                            0.018, // Responsive font size
                                        color: primaryColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: Platform.isAndroid ? 28 : 14,
                          ),
                          child: Icon(
                            CupertinoIcons.checkmark_seal_fill,
                            size: height * 0.03, // Responsive icon size
                            color: primaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onCallTap,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.04,
                                    vertical:
                                        height * 0.0048), // Responsive padding
                                margin: EdgeInsets.only(
                                    right: Platform.isAndroid ? 14 : 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: widget.isAvailble == false
                                          ? Colors.grey
                                          : primaryColor),
                                  color: const Color(0xff111111),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      widget.isHomeScreen == true
                                          ? Icon(
                                              Icons.call,
                                              size: widget.isHomeScreen == true
                                                  ? 20
                                                  : 18,
                                              color: widget.isAvailble == false
                                                  ? Colors.grey
                                                  : primaryColor,
                                            )
                                          : SvgPicture.asset(
                                              'assets/img/session.svg',
                                              width: widget.isHomeScreen == true
                                                  ? 18
                                                  : 16,
                                              color: widget.isAvailble == false
                                                  ? Colors.grey
                                                  : const Color(0xff1DB954),
                                            ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          widget.isHomeScreen == true
                                              ? 'Call'
                                              : 'Session',
                                          style: TextStyle(
                                            fontSize: widget.isHomeScreen ==
                                                    true
                                                ? height * 0.02
                                                : height *
                                                    0.016, // Responsive font size
                                            color: widget.isAvailble == false
                                                ? Colors.grey
                                                : primaryColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              widget.isAvailble == false
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        widget.isAvailble == false
                                            ? 'Offline'
                                            : 'Online',
                                        style: TextStyle(
                                            fontSize: height *
                                                0.01, // Responsive font size
                                            color: widget.isAvailble == false
                                                ? Colors.grey
                                                : Colors.transparent),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.isRisingStar == true)
            Positioned(
              top: 0,
              left: 4,
              child: Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 2, bottom: 2),
                  decoration: BoxDecoration(
                      color: Color(0xff2B284C), // Badge background color
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Center(
                    child: Text(
                      'Top Choice',
                      style: TextStyle(
                          fontSize: context.deviceHeight * .014,
                          color: primaryColor),
                    ),
                  )),
            ),
          // widget.rating == 0
          //     ? const SizedBox()
          //     : Positioned(
          //         bottom: context.deviceHeight * .035,
          //         left: context.deviceWidth * .04,
          //         child: Container(
          //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          //           decoration: BoxDecoration(
          //               color: primaryColor,
          //               borderRadius: BorderRadius.circular(5)),
          //           child: Row(
          //             children: [
          //               Text(
          //                 "${widget.rating} ",
          //                 style: const TextStyle(color: colorLightWhite),
          //               ),
          //               const Icon(
          //                 Icons.star,
          //                 size: 15,
          //                 color: colorLightWhite,
          //               )
          //             ],
          //           ),
          //         ),
          //       ),

          widget.rating == 0
              ? Positioned(
                  bottom: context.deviceHeight * .028,
                  left: context.deviceWidth * .12,
                  child: Text(
                    'New',
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: primaryColor),
                  ))
              : Positioned(
                  bottom: context.deviceHeight * .028,
                  left: context.deviceWidth * .08,
                  child: RatingBar.builder(
                    initialRating: widget.rating.toDouble(),
                    ignoreGestures: true,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 15,
                    itemPadding: EdgeInsets.zero,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: primaryColor,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
