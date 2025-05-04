import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:provider/provider.dart';

import 'viewModel/homeViewModel.dart';

class UserResultNameScreen extends StatefulWidget {
  final String totalScroe;

  const UserResultNameScreen({
    Key? key,
    required this.totalScroe,
  }) : super(key: key);

  @override
  State<UserResultNameScreen> createState() => _UserResultNameScreenState();
}

class _UserResultNameScreenState extends State<UserResultNameScreen> {
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();

  String? token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final getHomeData = Provider.of<HomeViewModel>(context, listen: false);

    Future.wait([sharedPreferencesViewModel.getToken()]).then(
      (value) {
        token = value[0] ?? '';
        getHomeData.userResultApis(
            totalScore: widget.totalScroe, token: token!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorLightWhite,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        surfaceTintColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 8),
            child: Text(
              "Overcooked Clinic 🩺",
              style: TextStyle(
                  fontSize: context.deviceHeight * .04,
                  fontWeight: FontWeight.w900),
            ),
          ),
          Divider(
            color: colorDark4,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Consumer<HomeViewModel>(
                    builder: (context, value, child) {
                      if (value.statusLoading == true) {
                        return Center(
                          heightFactor: 18,
                          child: CircularProgressIndicator(
                            color: colorLightWhite,
                          ),
                        );
                      } else if (value.userResultData.isEmpty) {
                        return const Center(
                          heightFactor: 34,
                          child: Text(
                            "No result found",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 14, right: 8, top: 8),
                              child: Text(
                                "Mental Health Assessment Report",
                                style: TextStyle(
                                    fontSize: context.deviceHeight * .02,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 8, top: 6),
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Name: ',
                                    style: TextStyle(
                                        fontSize: context.deviceHeight * .019,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  TextSpan(
                                    text: '${value.userProfileModel!.name}',
                                    style: TextStyle(
                                        fontSize: context.deviceHeight * .019,
                                        fontWeight: FontWeight.w700),
                                  )
                                ]))),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       left: 8, right: 8, top: 0),
                            //   child: Html(
                            //     data: cleanHtml(
                            //         value.userResultData.first.description ??
                            //             "<p>No description</p>"),
                            //   ),
                            // ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Html(
                                data: cleanHtml(
                                    value.userResultData.first.description ??
                                        "<p>No description</p>"),
                                style: {
                                  "strong": Style(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  "p": Style(
                                    margin: Margins(bottom: Margin(0)),
                                  ),
                                  "ul": Style(
                                      margin: Margins(
                                          bottom: Margin(0), left: Margin(0))),
                                  "li": Style(
                                    margin: Margins(bottom: Margin(4)),
                                  ),
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String cleanHtml(String html) {
    if (html == null || html.isEmpty) {
      return "<p>No description</p>";
    }

    String cleanedHtml = html
        .replaceAll(RegExp(r'style="[^"]*"'), '')
        .replaceAll(RegExp(r'class="[^"]*"'), '');

    cleanedHtml = cleanedHtml.replaceAll('<span', '<!--SPANSTART-->');
    cleanedHtml = cleanedHtml.replaceAll('</span>', '<!--SPANEND-->');

    cleanedHtml = cleanedHtml
        .replaceAll(RegExp(r'<!--SPANSTART-->[^>]*>'), '')
        .replaceAll('<!--SPANEND-->', '');

    cleanedHtml = cleanedHtml
        .replaceAll(RegExp(r'font-family:[^;]*;'), '')
        .replaceAll('<p></p>', '')
        .replaceAll('<p><br></p>', '<br>')
        .replaceAll('  ', ' ');

    return cleanedHtml;
  }
}
