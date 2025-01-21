import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ventout/Utils/colors.dart';
import 'package:ventout/Utils/responsive.dart';
import 'package:ventout/newFlow/bottomNaveBar.dart';
import 'package:ventout/newFlow/prefrencesScreen/prefs_gender.dart';
import 'package:ventout/newFlow/routes/routeName.dart';
import 'package:ventout/newFlow/viewModel/authViewModel.dart';
import 'package:ventout/newFlow/viewModel/homeViewModel.dart';
import 'package:ventout/newFlow/viewModel/questionsProvider.dart';
import 'package:ventout/newFlow/viewModel/utilsClass.dart';

import 'widgets/therapistDialog.dart';

class TherapistPreferencesScreen extends StatefulWidget {
  String selectedGender,
      selectedLanguages,
      selectedExpertise,
      selectedReachMeOut,
      token;
  bool isRegisterScreen;
  TherapistPreferencesScreen({
    super.key,
    required this.selectedGender,
    required this.selectedLanguages,
    required this.selectedExpertise,
    required this.selectedReachMeOut,
    required this.token,
    required this.isRegisterScreen,
  });
  @override
  State<TherapistPreferencesScreen> createState() =>
      _TherapistPreferencesScreenState();
}

class _TherapistPreferencesScreenState
    extends State<TherapistPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestionProvider>(context);
    final currentQuestion = provider.questions[provider.currentIndex];

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            "Find Your Psychologist",
            style: TextStyle(color: Colors.white),
          ),
          elevation: .5,
          shadowColor: colorLight3,
          surfaceTintColor: Colors.black,
          actions: [
            if (widget.isRegisterScreen == true)
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorLightWhite),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RoutesName.bottomNavBarView, (route) => false);
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        fontSize: 12,
                        color: colorDark1,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              )
          ],
        ),
        body: Consumer<AuthViewModel>(
          builder: (context, value, child) => Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Q${provider.currentIndex + 5}: ${currentQuestion['question']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Select one option",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentQuestion['options'].length,
                        itemBuilder: (context, index) {
                          final option = currentQuestion['options'][index];
                          final isSelected =
                              provider.getSelectedAnswer() == option;

                          return GestureDetector(
                            onTap: () => provider.saveAnswer(option),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected ? Color(0xff003D2A) : popupColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    option,
                                    style: TextStyle(
                                      color: isSelected
                                          ? primaryColor
                                          : Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
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
                              : Get.back,
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

                                    final authData = Provider.of<AuthViewModel>(
                                        context,
                                        listen: false);
                                    authData
                                        .prefrencesApis(
                                      widget.selectedGender,
                                      widget.selectedLanguages,
                                      widget.selectedExpertise,
                                      widget.selectedReachMeOut,
                                      widget.token,
                                      [apiData],
                                      context,
                                    )
                                        .then(
                                      (value) {
                                        final homeData =
                                            Provider.of<HomeViewModel>(context,
                                                listen: false);
                                        homeData
                                            .fetchFilterTherapistAPi(
                                                widget.token)
                                            .then(
                                          (value) {
                                            showDialog(
                                              context: context,
                                              useSafeArea: false,
                                              builder: (context) {
                                                return TherapistListDialog(
                                                    therapists: homeData
                                                        .filterTherapistData);
                                              },
                                            ).then(
                                              (value) {
                                                provider.clearAnswers();

                                                if (widget.isRegisterScreen ==
                                                    true) {
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                    context,
                                                    RoutesName.bottomNavBarView,
                                                    (route) => false,
                                                  );
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      pageBuilder: (context,
                                                              animation,
                                                              secondaryAnimation) =>
                                                          BottomNavBarView(
                                                        index: 1,
                                                      ),
                                                      transitionsBuilder:
                                                          (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) {
                                                        const begin =
                                                            Offset(1.0, 0.0);
                                                        const end =
                                                            Offset(0.0, 0.0);
                                                        const curve =
                                                            Curves.easeInOut;

                                                        var tween = Tween(
                                                                begin: begin,
                                                                end: end)
                                                            .chain(CurveTween(
                                                                curve: curve));
                                                        var offsetAnimation =
                                                            animation
                                                                .drive(tween);

                                                        return SlideTransition(
                                                          position:
                                                              offsetAnimation,
                                                          child: child,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
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
        ));
  }
}
