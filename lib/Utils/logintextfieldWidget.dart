import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/colors.dart';

class LogintextFieldWidget extends StatefulWidget {
  double ?width;
  Color? color;
  bool? isPhone = false;
  String? label;
  String? hintText, dialCode;
  String? labelText;
  bool forgotPass = false;
  bool spaced = false;
  TextEditingController? controller;
  int multiline = 1;
  bool? enable;
  bool? padding = true;
  VoidCallback? onDialPadTap;
  BuildContext? context;
  TextInputType? inputType = TextInputType.text;

  LogintextFieldWidget(
      {super.key,
      required this.color,
      required this.context,
      required this.controller,
      required this.enable,
      required this.forgotPass,
      required this.hintText,
      required this.inputType,
      required this.isPhone,
      required this.dialCode,
      required this.label,
      required this.multiline,
      required this.padding,
      required this.spaced,
      this.onDialPadTap,
      required this.labelText,
       this.width});

  @override
  State<LogintextFieldWidget>createState() => _LogintextFieldWidgetState();
}

class _LogintextFieldWidgetState extends State<LogintextFieldWidget> {
    String countrycodes = "+91";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding!
          ? EdgeInsets.symmetric(horizontal: widget.width! * 0.05)
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (widget.label != null)
              ? Text(
                  widget.label.toString(),
                  style: TextStyle(
                      color: (widget.color == null) ? Colors.black : widget.color,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter'),
                )
              : const SizedBox(),
          SizedBox(height: widget.spaced ? widget.width! * 0.02 : 0),
          Row(
            children: [
              widget.isPhone!
                  ? Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: widget.width! * 0.025,
                              vertical: widget.width! * 0.015),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: widget.onDialPadTap,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                 widget.dialCode.toString(),
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                       ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 40,
                        //   child: VerticalDivider(
                        //     color: Colors.grey[700],
                        //     thickness: 1.5,
                        //   ),
                        // ),
                      ],
                    )
                  : const SizedBox(),
                  SizedBox(width: 10,),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: widget.width! * 0.05),
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.grey),
                  //   color: Colors.black,
                  //   borderRadius: BorderRadius.circular(15),
                  // ),
                  child: TextField(
                    autofocus: widget.isPhone!? true : false,
                    enabled: widget.enable,
                    controller: widget.controller,
                    onChanged: (value) {
                      widget.controller!.text = value;
                    },
                    maxLines:  widget.multiline,
                    cursorColor: buttonColor,
                    decoration: InputDecoration(
                      hintText:  "Enter Phone Number",
                      border: InputBorder.none,
                      counterText: '',
                      hintStyle: ( widget.isPhone!)
                          ? TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.2))
                          : null,
                    ),
                    keyboardType:  widget.inputType,
                    inputFormatters:
                         widget.isPhone! ? [FilteringTextInputFormatter.digitsOnly] : [],
                    maxLength:  widget.isPhone! ? 10 : null,
                    style: ( widget.isPhone!)
                        ? const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w700)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: widget.width! * 0.02),
           widget.forgotPass
              ? const Text(
                  'Resend OTP?',
                  style: TextStyle(
                      color: Color(0xFFA1D02A),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter'),
                )
              : const SizedBox(),
        ],
      ),
    );
    ;
  }
}
