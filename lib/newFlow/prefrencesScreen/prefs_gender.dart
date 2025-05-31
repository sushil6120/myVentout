import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overcooked/Utils/responsive.dart';
import 'package:overcooked/Utils/utilsFunction.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';

import '../../Utils/colors.dart';

class PrefsGender extends StatefulWidget {
  
  const PrefsGender({super.key});

  @override
  State<PrefsGender> createState() => _PrefsGenderState();
}

class _PrefsGenderState extends State<PrefsGender> {
  String _selectedGender = ''; // To store the selected gender

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
      print(_selectedGender);
    });
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Row(
              children: [
                Text(
                  'Gender ',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      height: 1,
                      fontSize: context.deviceWidth * .094,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  'assets/img/gender.png',
                  height: 35,
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    if (_selectedGender.isNotEmpty || _selectedGender != '') {
                    } else {
                      Utils.toastMessage('Select Gender');
                    }
                  },
                  child: _buildGenderOption('Male', Icons.male)),
              SizedBox(width: 16),
              GestureDetector(
                  onTap: () {
                    if (_selectedGender.isNotEmpty || _selectedGender != '') {
                    } else {
                      Utils.toastMessage('Select Gender');
                    }
                  },
                  child: _buildGenderOption('Female', Icons.female)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    if (_selectedGender.isNotEmpty || _selectedGender != '') {
                    } else {
                      Utils.toastMessage('Select Gender');
                    }
                  },
                  child: _buildGenderOption('Other', Icons.transgender)),
              SizedBox(width: 16),
              GestureDetector(
                  onTap: () {
                    if (_selectedGender.isNotEmpty || _selectedGender != '') {
                    } else {
                      Utils.toastMessage('Select Gender');
                    }
                  },
                  child: _buildGenderOption(
                      'Prefer Not to Say', Icons.not_interested)),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
