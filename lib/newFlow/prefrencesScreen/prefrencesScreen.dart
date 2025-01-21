import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ventout/Utils/responsive.dart';
import 'package:ventout/Utils/valueConstants.dart';
import 'package:ventout/newFlow/prefrencesScreen/prefs_gender.dart';
import 'package:ventout/newFlow/routes/routeName.dart';
import 'package:ventout/newFlow/services/sharedPrefs.dart';
import 'package:ventout/newFlow/therapistPrefernceScreen.dart';
import 'package:ventout/newFlow/viewModel/authViewModel.dart';

import '../../Utils/colors.dart';
import '../../Utils/utilsFunction.dart';
import '../viewModel/utilViewModel.dart';

class PreferenceScreen extends StatefulWidget {
  bool isRegisterScreen;
  PreferenceScreen({
    super.key,
    required this.isRegisterScreen,
  });
  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  final PageController _pageController = PageController();
  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();
  String _selectedGender = '';
  String _selectedLanguages = '';
  String _selectedExpertise = '';
  String _selectedReachMeOut = "";
  final List<String> _languageOptions = [
    "Hindi",
    "English",
    "Bengali",
    "Telugu",
    "Marathi",
    "Tamil",
    "Gujarati",
    "Urdu",
    "Kannada",
    "Odia",
    "Malayalam",
    "Punjabi",
    "Assamese",
    "Maithili",
    "Sanskrit"
  ];

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
      print(_selectedGender);
    });
    _nextPage();
  }

  int _currentIndex = 0;

  void _nextPage() {
    if (_currentIndex == 0) {
      if (_selectedGender.isEmpty) {
        Utils.toastMessage('Select Gender!');
      } else {
        _pageController.animateToPage(
          _currentIndex + 1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentIndex == 1) {
      if (_selectedLanguages.isEmpty) {
        Utils.toastMessage('Select Language!');
      } else {
        _pageController.animateToPage(
          _currentIndex + 1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentIndex == 2) {
      if (_selectedExpertise.isEmpty) {
        Utils.toastMessage('Select your topic!');
      } else {
        _pageController.animateToPage(
          _currentIndex + 1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentIndex == 3) {
      if (_selectedReachMeOut.isEmpty) {
        Utils.toastMessage('Select Category!');
      } else {
        Get.to(
            TherapistPreferencesScreen(
              isRegisterScreen: widget.isRegisterScreen,
              selectedExpertise: _selectedExpertise,
              selectedGender: _selectedGender,
              selectedLanguages: _selectedLanguages,
              selectedReachMeOut: _selectedReachMeOut,
              token: token!,
            ),
            transition: Transition.rightToLeft);
      }
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.animateToPage(
        _currentIndex - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context); // Navigate back to the previous screen
    }
  }

  String? token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final getUtilsData = Provider.of<UtilsViewModel>(context, listen: false);
    Future.wait([
      sharedPreferencesViewModel.getToken(),
      sharedPreferencesViewModel.getSignUpToken()
    ]).then((value) {
      token = value[0] == null ? value[1] : value[0];
    });
    getUtilsData.fetchCategoryAPi();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/back-designs.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              title: Text(
                'Find Your Psychologist',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width * .05),
              ),
              leading: IconButton(
                  onPressed: _previousPage,
                  icon: Icon(Icons.arrow_back_ios_new_rounded)),
              actions: [
                if (widget.isRegisterScreen == true)
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorLightWhite),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            RoutesName.bottomNavBarView, (route) => false);
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
            body: SafeArea(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: <Widget>[
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: verticalSpaceMedium,
                        ),
                        Text(
                          'Q1:-Gender of the psychologist',
                          style: GoogleFonts.openSans(
                              color: Colors.white,
                              height: 1,
                              fontSize: context.deviceWidth * .058,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  if (_selectedGender.isNotEmpty ||
                                      _selectedGender != '') {
                                  } else {
                                    Utils.toastMessage('Select Gender');
                                  }
                                },
                                child: _buildGenderOption('Male', Icons.male)),
                            SizedBox(width: 16),
                            GestureDetector(
                                onTap: () {
                                  if (_selectedGender.isNotEmpty ||
                                      _selectedGender != '') {
                                  } else {
                                    Utils.toastMessage('Select Gender');
                                  }
                                },
                                child:
                                    _buildGenderOption('Female', Icons.female)),
                          ],
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: verticalSpaceMedium,
                      ),
                      Text(
                        'Q2:- Language you prefer',
                        style: GoogleFonts.openSans(
                            color: Colors.white,
                            height: 1,
                            fontSize: context.deviceWidth * .058,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: _languageOptions
                              .map((language) => FilterChip(
                                    elevation: 0,
                                    label: Text(
                                      language,
                                      style: TextStyle(
                                          color: _selectedLanguages == language
                                              ? greenColor
                                              : Colors.white),
                                    ),
                                    side: BorderSide.none,
                                    backgroundColor: const Color(0xff202020),
                                    selectedColor: Color(0xff003D2A),
                                    showCheckmark: false,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    selected: _selectedLanguages == language,
                                    onSelected: (selected) {
                                      setState(() {
                                        _selectedLanguages =
                                            (selected ? language : '');
                                        print(_selectedLanguages);
                                      });
                                      _nextPage();
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: verticalSpaceMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 26, right: 16),
                        child: Text(
                          'Q3:- What do you wanna talk about?',
                          style: GoogleFonts.openSans(
                              color: Colors.white,
                              height: 1,
                              fontSize: context.deviceWidth * .058,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<UtilsViewModel>(
                        builder: (context, value, child) {
                          if (value.dataList.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: value.dataList.map((expertise) {
                                return FilterChip(
                                  elevation: 0,
                                  side: BorderSide.none,
                                  backgroundColor: const Color(0xff202020),
                                  selectedColor: Color(0xff003D2A),
                                  showCheckmark: false,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  label: Text(
                                    expertise.categoryName.toString(),
                                    style: TextStyle(
                                        color:
                                            _selectedExpertise == expertise.sId
                                                ? greenColor
                                                : Colors.white),
                                  ),
                                  selected: _selectedExpertise == expertise.sId,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedExpertise =
                                          (selected ? expertise.sId : null)!;
                                      print(_selectedExpertise);
                                    });
                                    _nextPage();
                                  },
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: verticalSpaceMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 26, right: 16),
                        child: Text(
                          'Q4:- Select the category you belong to:',
                          style: GoogleFonts.openSans(
                              color: Colors.white,
                              height: 1,
                              fontSize: context.deviceWidth * .058,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: reachMeOutList.map((expertise) {
                            return FilterChip(
                              elevation: 0,
                              side: BorderSide.none,
                              backgroundColor: Color(0xff202020),
                              selectedColor: Color(0xff003D2A),
                              showCheckmark: false,
                              shadowColor: Color(0xff049569),
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              label: Text(
                                expertise.toString(),
                                style: TextStyle(
                                  color: _selectedReachMeOut ==
                                          expertise.toString()
                                      ? Color(0xff1DB954)
                                      : colorLightWhite,
                                  fontSize: context.deviceWidth * .034,
                                ),
                              ),
                              selected:
                                  _selectedReachMeOut == expertise.toString(),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedReachMeOut = expertise.toString();
                                    print(_selectedReachMeOut);
                                  } else {
                                    _selectedReachMeOut = "";
                                  }
                                });
                                _nextPage();
                              },
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Consumer<AuthViewModel>(
              builder: (context, value, child) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 14, right: 14, bottom: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _previousPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Previous",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _nextPage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: colorDark1, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                // Container(
                //     width: width,
                //     padding:
                //         const EdgeInsets.only(bottom: 35, left: 14, right: 14),
                //     margin: const EdgeInsets.only(bottom: 10),
                //     decoration: const BoxDecoration(color: Colors.transparent),
                //     child: ElevatedButton(
                //       onPressed: () {
                //         _nextPage();
                //       },
                //       style: ElevatedButton.styleFrom(
                //         elevation: 0,
                //         backgroundColor: Color(0xffA2D9A0),
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(30)),
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 20, vertical: 5),
                //       ),
                //       child: value.isLoading
                //           ? LoadingAnimationWidget.waveDots(
                //               color: Colors.black,
                //               size: 40,
                //             )
                //           : const Text(
                //               'Next',
                //               style: TextStyle(
                //                   color: Colors.black,
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.w600),
                //             ),
                //     ));
              },
            )));
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => _selectGender(gender),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff003D2A) : popupColor,
          borderRadius: BorderRadius.circular(10),
        ),
        width: context.deviceWidth * .4,
        height: context.deviceHeight * .2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.white,
              size: 75,
            ),
            SizedBox(height: 8),
            Text(
              gender,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isSelected ? primaryColor : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
