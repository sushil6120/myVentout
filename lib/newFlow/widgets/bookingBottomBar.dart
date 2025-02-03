import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/callScreens/chatScreen.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:provider/provider.dart';

class BookingBottomBarWidget extends StatefulWidget {
  final VoidCallback onCancelTap;
  final String? image, name, fee, callType, bookingStatus;
  final bool? status;
  final String? slot;
  final String? day;

  BookingBottomBarWidget({
    Key? key,
    required this.onCancelTap,
    this.callType,
    this.fee,
    this.bookingStatus,
    this.image,
    this.name,
    this.status, this.slot, this.day,
  }) : super(key: key);

  @override
  _BookingBottomBarWidgetState createState() => _BookingBottomBarWidgetState();
}

class _BookingBottomBarWidgetState extends State<BookingBottomBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        height: 100,
        alignment: Alignment.center,
        padding:
            EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
        decoration: BoxDecoration(
          color: popupColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: greenColor),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 27,
                    backgroundImage: NetworkImage(widget.image!),
                  ),
                ),
                const SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.name!,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${widget.day}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        color: Colors
                            .white, // Green for "Confirming with the Expert", white for others
                        fontSize: 14,
                      ),
                    ),

                    // Row(
                    //   children: [
                    //     Text(
                    //       '₹ ${widget.fee} ',
                    //       style: GoogleFonts.inter(
                    //         color: Colors.white,
                    //         fontSize: MediaQuery.of(context).size.width * .032,
                    //       ),
                    //     ),
                    //     Text(
                    //       '(${widget.callType})',
                    //       style: GoogleFonts.inter(
                    //         color: greenColor,
                    //         fontSize: MediaQuery.of(context).size.width * .032,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Text(
                      '${widget.slot}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Colors
                            .white, // Green for "Confirming with the Expert", white for others
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Consumer<SessionViewModel> (
              builder: (context, value, child) => value.sessionDatas.isEmpty
                  ? SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                bookingStatus: value
                                    .sessionDatas.first.bookingStatus
                                    .toString(),
                                therapistCate: value
                                    .sessionDatas.first.therapistId!.name
                                    .toString(),
                                duration: value.sessionDatas.first.timeDuration
                                    .toString(),
                                chatId: value.sessionDatas.first.sId.toString(),
                                sessionId:
                                value.sessionDatas.first.sId.toString(),
                              ),
                            ));
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: darkModePrimaryTextColor,
                          shape: BoxShape.circle
                        ),
                        child: Icon(
                          size: 25,
                          CupertinoIcons.chat_bubble_fill,
                          color: primaryColorDark,
                        ),
                      )),
            )
            // widget.status == true
            //     ? LoadingAnimationWidget.waveDots(
            //         color: Colors.white,
            //         size: 30,
            //       )
            //     : GestureDetector(
            //         onTap: widget.onCancelTap,
            //         child: const SizedBox(
            //           width: 60,
            //           height: 60,
            //           child: Center(
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Icon(
            //                   CupertinoIcons.clear_circled,
            //                   color: Color(0xff626262),
            //                   size: 28,
            //                 ),
            //                 Text(
            //                   'Cancel',
            //                   style: TextStyle(
            //                     color: Color(0xff676767),
            //                     fontSize: 10.0,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
          ],
        ),
      ),
    );
  }
}
