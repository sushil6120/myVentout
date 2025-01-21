import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventout/newFlow/widgets/color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BookingBottomBarWidget extends StatefulWidget {
  final VoidCallback onCancelTap;
  final String? image, name, fee, callType, bookingStatus;
  final bool? status;

  BookingBottomBarWidget({
    Key? key,
    required this.onCancelTap,
    this.callType,
    this.fee,
    this.bookingStatus,
    this.image,
    this.name,
    this.status,
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
        padding:
            const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 26.0, top: 10),
        decoration: const BoxDecoration(
          color: Color(0xff2B284C),
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
                  children: [
                    Text(
                      widget.name!,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * .035,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '₹ ${widget.fee} ',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * .032,
                          ),
                        ),
                        Text(
                          '(${widget.callType})',
                          style: GoogleFonts.inter(
                            color: greenColor,
                            fontSize: MediaQuery.of(context).size.width * .032,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Tap to chat',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: Colors
                            .white, // Green for "Confirming with the Expert", white for others
                        fontSize: MediaQuery.of(context).size.width * .034,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.status == true
                ? LoadingAnimationWidget.waveDots(
                    color: Colors.white,
                    size: 30,
                  )
                : GestureDetector(
                    onTap: widget.onCancelTap,
                    child: const SizedBox(
                      width: 60,
                      height: 60,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.clear_circled,
                              color: Color(0xff626262),
                              size: 28,
                            ),
                            Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xff676767),
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
