import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:provider/provider.dart';
import 'package:ventout/newFlow/bottomNaveBar.dart';
import 'package:ventout/newFlow/homeScreen.dart';
import 'package:ventout/newFlow/model/allTherapistModel.dart';
import 'package:ventout/newFlow/viewModel/homeViewModel.dart';
import 'package:ventout/newFlow/viewModel/utilViewModel.dart';
import 'package:ventout/newFlow/widgets/color.dart';

class SortFilterScreen extends StatefulWidget {
  Map<String, dynamic>? arguments;

  SortFilterScreen({super.key, this.arguments});
  @override
  _SortFilterScreenState createState() => _SortFilterScreenState();
}

class _SortFilterScreenState extends State<SortFilterScreen> {
  // Sort by options
  String _selectedSortBy = 'Recommended';
  bool? isHome;

  // Expertise options
  final List<String> _expertiseOptions = [
    'Offers',
    'Love',
    'Marriage',
    'Career',
    'Relationships',
    'Education',
    'Health',
    'Wealth',
    'Friends',
    'Parents',
    'Kids'
  ];
  String _selectedExpertise = '';

  // Language options
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
  String _selectedLanguages = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isHome = widget.arguments!['isHome'];

    final getUtilsData = Provider.of<UtilsViewModel>(context, listen: false);

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
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: const Text(
            'Sort & Filter',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
        body: Consumer<UtilsViewModel>(
          builder: (context, value, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sort By',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w400),
                      ),
                      ...[
                        'Recommended',
                        'Experience: high to low',
                        'Experience: low to high',
                        'Price: high to low',
                        'Price: low to high',
                        'Ratings'
                      ]
                          .map((sortByOption) => RadioListTile<String>(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0), // Reduce vertical padding
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
                                title: Text(sortByOption,
                                    style: const TextStyle(fontSize: 16)),
                                value: sortByOption,
                                groupValue: isHome == true
                                    ? value.selectedSort
                                    : value.selectedSessionSort,
                                activeColor: greenColor,
                                onChanged: (values) {
                                  if (isHome == true) {
                                    value.setSort(values.toString());
                                  } else {
                                    value.setSessionSort(values.toString());
                                  }
                                },
                              ))
                          .toList(),
                      const SizedBox(height: 20),
                      const Text(
                        'Expertise',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 15,
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
                                bool isSelected = isHome == true
                                    ? value.selectedExpertise == expertise.sId
                                    : value.selectedSessionExpertise ==
                                        expertise.sId;
                                return FilterChip(
                                  elevation: 0,
                                  side: BorderSide.none,
                                  backgroundColor: const Color(0xff202020),
                                  selectedColor: const Color(0xff003D2A),
                                  showCheckmark: false,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide.none,
                                    borderRadius: BorderRadius.circular(90.0),
                                  ),
                                  label: Text(
                                    expertise.categoryName.toString(),
                                    style: TextStyle(
                                      color: isHome == true
                                          ? isSelected
                                              ? greenColor
                                              : Colors.white
                                          : isSelected
                                              ? greenColor
                                              : Colors.white,
                                    ),
                                  ),
                                  selected: isHome == true
                                      ? value.selectedExpertise == expertise.sId
                                      : value.selectedSessionExpertise ==
                                          expertise.sId,
                                  onSelected: (selected) {
                                    if (isHome == true) {
                                      value.setExpertise(selected
                                          ? expertise.sId.toString()
                                          : '');
                                    } else {
                                      value.setSessionexpertise(selected
                                          ? expertise.sId.toString()
                                          : '');
                                    }
                                  },
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Language',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: _languageOptions.map((language) {
                          bool isSelected = isHome == true
                              ? value.selectedLanguage == language
                              : value.selectedSessionExpertise == language;

                          return FilterChip(
                            elevation: 0,
                            label: Text(
                              language,
                              style: TextStyle(
                                color: isHome == true
                                    ? isSelected
                                        ? greenColor
                                        : Colors.white
                                    : isSelected
                                        ? greenColor
                                        : Colors.white,
                              ),
                            ),
                            side: BorderSide.none,
                            backgroundColor: const Color(0xff202020),
                            selectedColor: const Color(0xff003D2A),
                            showCheckmark: false,
                            shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            selected: isHome == true
                                ? value.selectedLanguage == language
                                : value.selectedSessionLanguage == language,
                            onSelected: (selected) {
                              if (isHome == true) {
                                value.setLanguage(
                                  selected ? language : '', // Toggle selection
                                );
                              } else {
                                value.setSessionLanguage(
                                  selected ? language : '', // Toggle selection
                                );
                              }
                              // Debug output
                            },
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Consumer<UtilsViewModel>(
          builder: (context, value, child) {
            return Container(
                height: height * .094,
                width: width,
                padding: const EdgeInsets.only(bottom: 35, left: 14, right: 14),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(color: Colors.transparent),
                child: ElevatedButton(
                  onPressed: () {
                    // final getHomeData =
                    //     Provider.of<HomeViewModel>(context, listen: false);
                    // Stream<List<AllTherapistModel>>? _theraPistStream;

                    // _theraPistStream = getHomeData.therapistStream(
                    //     _selectedSortBy == 'Experience: high to low'
                    //         ? 'high'
                    //         : _selectedSortBy == 'Experience: low to high'
                    //             ? 'low'
                    //             : _selectedSortBy == 'Price: high to low'
                    //                 ? 'high'
                    //                 : _selectedSortBy == 'Price: low to high'
                    //                     ? 'low'
                    //                     : _selectedSortBy == 'Rating'
                    //                         ? 'high'
                    //                         : '',
                    //     _selectedExpertise,
                    //     _selectedLanguages,
                    //     _selectedSortBy == 'Rating' ? 'high' : '',
                    //     '');
                    // Navigator.pop(context, 'sushil');

                    if (isHome == true) {
                      Get.to(BottomNavBarView(
                        index: 0,
                        isFilter: isHome == true ? true : false,
                        categories: value.selectedExpertise,
                        language: value.selectedLanguage,
                        sortByFee: value.selectedSort ==
                                'Experience: high to low'
                            ? 'high'
                            : _selectedSortBy == 'Experience: low to high'
                                ? 'low'
                                : _selectedSortBy == 'Price: high to low'
                                    ? 'high'
                                    : _selectedSortBy == 'Price: low to high'
                                        ? 'low'
                                        : _selectedSortBy == 'Rating'
                                            ? 'high'
                                            : '',
                      ));
                    } else {
                      Get.to(BottomNavBarView(
                        index: 1,
                        isFilter: isHome == true ? true : false,
                        categories: value.selectedSessionExpertise,
                        language: value.selectedSessionLanguage,
                        sortByFee: value.selectedSessionSort ==
                                'Experience: high to low'
                            ? 'high'
                            : _selectedSortBy == 'Experience: low to high'
                                ? 'low'
                                : _selectedSortBy == 'Price: high to low'
                                    ? 'high'
                                    : _selectedSortBy == 'Price: low to high'
                                        ? 'low'
                                        : _selectedSortBy == 'Rating'
                                            ? 'high'
                                            : '',
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xffA2D9A0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ));
          },
        ),
      ),
    );
  }
}
