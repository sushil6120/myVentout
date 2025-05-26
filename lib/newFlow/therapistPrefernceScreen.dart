import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overcooked/newFlow/services/sharedPrefs.dart';
import 'package:provider/provider.dart';
import 'package:overcooked/Utils/colors.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/newFlow/viewModel/authViewModel.dart';
import 'package:overcooked/newFlow/viewModel/homeViewModel.dart';
import 'package:overcooked/newFlow/viewModel/questionsProvider.dart';

import 'widgets/therapistDialog.dart';

class TherapistPreferencesScreen extends StatefulWidget {
  String token;
  bool isRegisterScreen;
  TherapistPreferencesScreen({
    super.key,
    required this.token,
    required this.isRegisterScreen,
  });
  @override
  State<TherapistPreferencesScreen> createState() =>
      _TherapistPreferencesScreenState();
}

class _TherapistPreferencesScreenState
    extends State<TherapistPreferencesScreen> {
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();
  String? signUpToken;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.wait([sharedPreferencesViewModel.getSignUpToken()]).then(
      (value) {
        signUpToken = value[0];
        print("Singup token = $signUpToken");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestionProvider>(context);
    final currentQuestion = provider.questions[provider.currentIndex];

    return WillPopScope(
      onWillPop: () async {
        provider.updateIndex();
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: widget.isRegisterScreen == false
                ? GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios_new_rounded))
                : SizedBox.shrink(),
            title: const Text(
              "Depression Screening Test (HAM-D Based)",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            elevation: .5,
            shadowColor: colorLight3,
            surfaceTintColor: Colors.black,
            // actions: [
            //   if (widget.isRegisterScreen == true)
            //     Padding(
            //       padding:
            //           const EdgeInsets.only(right: 10, top: 10, bottom: 10),
            //       child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //             backgroundColor: colorLightWhite),
            //         onPressed: () {
            //           Navigator.pushNamedAndRemoveUntil(context,
            //               RoutesName.bottomNavBarView, (route) => false);
            //         },
            //         child: Text(
            //           "Skip",
            //           style: TextStyle(
            //               fontSize: 12,
            //               color: colorDark1,
            //               fontWeight: FontWeight.w600),
            //         ),
            //       ),
            //     )
            // ],
          ),
          body: Consumer<AuthViewModel>(
            builder: (context, value, child) => Stack(
              children: [
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(20),
                  color: primaryColor,
                  value: provider.progressBar,
                  backgroundColor: colorDark2,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Q${provider.currentIndex + 1}: ${currentQuestion['question']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      if (provider.currentIndex == 0) ...[
                        const SizedBox(height: 10),
                        const Text(
                          "Select one option",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: currentQuestion['options'].length,
                          itemBuilder: (context, index) {
                            final option = currentQuestion['options'][index];
                            final isSelected =
                                provider.getSelectedAnswer() == option;

                            return GestureDetector(
                              onTap: () {
                                provider.saveAnswer(option);
                                if (provider.currentIndex == 9) {
                                  final apiData = provider.prepareApiData();
                                  print("Sending to API: $apiData");

                                  final authData = Provider.of<AuthViewModel>(
                                      context,
                                      listen: false);
                                  authData.setLoading(true);

                                  authData
                                      .prefrencesApis(
                                    widget.isRegisterScreen == true
                                        ? signUpToken!
                                        : widget.token,
                                    apiData,
                                    context,
                                  )
                                      .then((value) {
                                    final homeData = Provider.of<HomeViewModel>(
                                        context,
                                        listen: false);

                                    homeData
                                        .fetchFilterTherapistAPi(
                                            widget.isRegisterScreen == true
                                                ? signUpToken!
                                                : widget.token)
                                        .then(
                                      (value) {
                                        // Set loading state to false when done
                                        authData.setLoading(false);

                                        // Navigate to TherapistListScreen
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return TherapistListScreen(
                                                totalPonts:
                                                    provider.totalPoints,
                                                isRegistered:
                                                    widget.isRegisterScreen,
                                                therapists: homeData
                                                    .filterTherapistData);
                                          },
                                        ));
                                      },
                                    );
                                  });
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Color(0xff003D2A)
                                      : backgroundColor2,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  option,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: isSelected
                                        ? primaryColor
                                        : Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: provider.currentIndex > 0
                                ? () => provider.previousQuestion()
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              "Previous",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Consumer<HomeViewModel>(
                            builder: (context, value, child) => ElevatedButton(
                              onPressed: provider.currentIndex <
                                      provider.questions.length - 1
                                  ? () => provider.nextQuestion()
                                  : () {
                                      final apiData = provider.prepareApiData();
                                      print("Sending to API: $apiData");

                                      final authData =
                                          Provider.of<AuthViewModel>(context,
                                              listen: false);
                                      authData
                                          .prefrencesApis(
                                        widget.isRegisterScreen == true
                                            ? signUpToken!
                                            : widget.token,
                                        [apiData],
                                        context,
                                      )
                                          .then(
                                        (value) {
                                          final homeData =
                                              Provider.of<HomeViewModel>(
                                                  context,
                                                  listen: false);
                                          homeData
                                              .fetchFilterTherapistAPi(
                                                  widget.isRegisterScreen ==
                                                          true
                                                      ? signUpToken!
                                                      : widget.token)
                                              .then(
                                            (value) {
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return TherapistListScreen(
                                                      totalPonts:
                                                          provider.totalPoints,
                                                      isRegistered: widget
                                                          .isRegisterScreen,
                                                      therapists: homeData
                                                          .filterTherapistData);
                                                },
                                              ));
                                            },
                                          );
                                        },
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  provider.currentIndex <
                                          provider.questions.length - 1
                                      ? "Next"
                                      : "Submit",
                                  style: TextStyle(
                                      color: colorDark1,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                value.isLoading == true
                    ? Container(
                        width: context.deviceWidth,
                        height: context.deviceHeight,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.5),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: colorLightWhite,
                          ),
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ),
          )),
    );
  }
}
