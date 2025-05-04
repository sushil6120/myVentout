import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/components.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/viewModel/sessionViewModel.dart';
import 'package:overcooked/newFlow/viewModel/utilsClass.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class RatingDialog extends StatefulWidget {
  String? token, therapist;
  RatingDialog({
    super.key,
    required this.token,
    required this.therapist,
  });
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 0;
  bool _isTextEntered = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.only(
          left: Platform.isAndroid ? 12 : 20,
          right: Platform.isAndroid ? 12 : 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .54,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xff111111),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 14,
            ),
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close))),
            Text(
              "Rate your experiance",
              style: TextStyle(fontSize: context.deviceHeight * .05),
            ),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: primaryColor,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller,
              maxLines: 4,
              onChanged: (value) {
                setState(() {
                  _isTextEntered = value.isNotEmpty;
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Write a review',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
            if (_isTextEntered || _rating != 0)
              Consumer<SessionViewModel>(
                builder: (context, value, child) {
                  return Align(
                      alignment: Alignment.bottomLeft,
                      child: value.isLoading == true
                          ? LoadingAnimationWidget.waveDots(
                              color: Colors.white,
                              size: 28,
                            )
                          : customButton(() {
                              value.createRevieweAPi(
                                  widget.token.toString(),
                                  widget.therapist.toString(),
                                  controller.text,
                                  _rating.toInt());
                              Navigator.of(context).pop();
                            }, context.deviceWidth * .28,
                              context.deviceHeight * .05, 'Submit', false));
                },
              )
          ],
        ),
      ),
    );
  }
}
