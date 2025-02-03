import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:overcooked/Utils/colors.dart';

Widget notificationCard(
    {required double width,
    required String text1,
    required String text2,
    required String image1,
    required String image2,
    bool? isRead,
    String? image3,
    final VoidCallback? onPressed}) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color:
            isRead == false ? Colors.grey.withOpacity(.4) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: (image3 != null) ? width * 0.15 : width * 0.1,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage(image1))),
              ),
            ),
          ),
          SizedBox(width: width * 0.02),
          SizedBox(
            width: width * .6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text1,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'LeagueSpartan',
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: width * 0.01),
                Text(
                  text2,
                  style: const TextStyle(
                    fontFamily: 'LeagueSpartan',
                    color: Color(0xFF909090),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(image2))),
            ),
          )
        ],
      ),
    ),
  );
}

Widget commentCard(
    {required String? img, required String cmnt, required width}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 1.0, left: 5.0, top: 4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              img == null
                  ? "https://cdn-icons-png.flaticon.com/512/3237/3237472.png"
                  : img,
              width: width * 0.08,
              height: width * 0.08,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: width * 0.04, top: width * 0.05),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: width * 0.8,
            ),
            child: (cmnt != null) && cmnt!.endsWith('.gif') ||
                    cmnt!.endsWith('.jpg') ||
                    cmnt!.endsWith('.png') ||
                    cmnt!.endsWith('.jpeg')
                ? Image.network(
                    cmnt,
                    width: width * 0.6,
                    height: width * 0.55,
                    fit: BoxFit.cover,
                  )
                : Text(
                    cmnt,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ),
      ],
    ),
  );
}

Widget customButton(final VoidCallback onSaved, double width, double height,
    String label, bool isLoading) {
  return InkWell(
    onTap: onSaved,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: buttonColor,
      ),
      child: Center(
          child: isLoading
              ? LoadingAnimationWidget.waveDots(
                  color: Colors.black,
                  size: 40,
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )),
    ),
  );
}

Widget settingCard({
  required double width,
  required String text,
  required VoidCallback onPressed,
  required Icon icon0,
  // required icon,
  // required color
}) {
  return SizedBox(
    width: width * 0.9,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.02),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              width: width * 0.9,
              // constraints: BoxConstraints(minHeight: width * 0.08),
              decoration: const BoxDecoration(
                //  color: color,
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: width * 0.03),
                  icon0,
                  SizedBox(width: width * 0.05),
                  Text(
                    text,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  // IconButton(onPressed: onPressed,
                  //    // icon: icon
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget customTextField({
  required double width,
  Color? color,
  bool? isPhone = false,
  String? label,
  String? hintText,
  bool forgotPass = false,
  bool spaced = false,
  TextEditingController? controller,
  int multiline = 1,
  bool? enable,
  bool? padding = true,
  BuildContext? context,
  TextInputType? inputType = TextInputType.text,
}) {
  String countrycodes = "+91";
  return Padding(
    padding: padding!
        ? EdgeInsets.symmetric(horizontal: width * 0.05)
        : EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (label != null)
            ? Text(
                label.toString(),
                style: TextStyle(
                    color: (color == null) ? Colors.black : color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter'),
              )
            : const SizedBox(),
        SizedBox(height: spaced ? width * 0.02 : 0),
        Row(
          children: [
            isPhone!
                ? Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.025, vertical: width * 0.015),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showCountryPicker(
                                    context: context!,
                                    useSafeArea: true,
                                    countryListTheme: CountryListThemeData(
                                      flagSize: 25,
                                      backgroundColor: Colors.black,

                                      textStyle: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                      bottomSheetHeight: double
                                          .infinity, // Optional. Country list modal height
                                      //Optional. Sets the border radius for the bottomsheet.
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                      ),
                                      //Optional. Styles the search field.
                                      inputDecoration: InputDecoration(
                                        labelText: 'Search',
                                        hintText: 'Start typing to search',
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: const Color(0xFF8C98A8)
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onSelect: (Country country) {
                                      print(
                                          'Select country: ${country.displayName}');

                                      countrycodes =
                                          country.countryCode.toString();
                                    });
                              },
                              child: const Text(
                                '+91 ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Roboto'),
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
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.grey),
                //   color: Colors.black,
                //   borderRadius: BorderRadius.circular(15),
                // ),
                child: TextField(
                  autofocus: isPhone ? true : false,
                  enabled: enable,
                  controller: controller,
                  onChanged: (value) {
                    controller!.text = value;
                  },
                  maxLines: multiline,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    counterText: '',
                    hintStyle: (isPhone)
                        ? TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withOpacity(0.2))
                        : null,
                  ),
                  keyboardType: inputType,
                  inputFormatters:
                      isPhone ? [FilteringTextInputFormatter.digitsOnly] : [],
                  maxLength: isPhone ? 10 : null,
                  style: (isPhone)
                      ? const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w700)
                      : null,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: width * 0.02),
        forgotPass
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
}
