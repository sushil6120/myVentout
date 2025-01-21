import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ventout/Utils/responsive.dart';
import 'package:ventout/Utils/valueConstants.dart';
import 'package:ventout/newFlow/services/sharedPrefs.dart';
import 'package:ventout/newFlow/viewModel/authViewModel.dart';
import 'package:ventout/newFlow/viewModel/utilViewModel.dart';
import 'package:ventout/newFlow/viewModel/utilsClass.dart';

import '../Utils/colors.dart';

class ReportProblemScreen extends StatefulWidget {
  @override
  _ReportProblemScreenState createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  SharedPreferencesViewModel sharedPreferencesViewModel =
      SharedPreferencesViewModel();

  String? token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.wait([sharedPreferencesViewModel.getToken()]).then((value) {
      token = value[0];
    });
  }

  void _submitReport() {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      // Show a snackbar or alert if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
    } else {
      final report = Provider.of<UtilsViewModel>(context, listen: false);
      report.reportApis(token.toString(), title, description, context);
      // Show success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Problem reported successfully!')),
      );

      // Clear the fields after submission
      _titleController.clear();
      _descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/back-designs.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Report a Problem'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: verticalSpaceMedium,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                decoration: BoxDecoration(
                    color: const Color(0xff202020),
                    borderRadius: BorderRadius.circular(20)),
                child: SizedBox(
                  width: context.deviceWidth,
                  height: context.deviceHeight * .04,
                  child: TextField(
                    controller: _titleController,
                    cursorColor: buttonColor,
                    cursorHeight: 15,
                    style: const TextStyle(color: colorLightWhite),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                          color: colorLight3,
                          fontSize: context.deviceWidth * .03,
                          fontWeight: FontWeight.w700),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0), // Add padding inside the TextField
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(
                    bottom: 4, left: 14, right: 14, top: 14),
                decoration: BoxDecoration(
                    color: const Color(0xff202020),
                    borderRadius: BorderRadius.circular(20)),
                child: SizedBox(
                  width: context.deviceWidth * .9,
                  child: TextFormField(
                    cursorColor: buttonColor,
                    controller: _descriptionController,
                    maxLines: 7,
                    cursorHeight: 15,
                    style: const TextStyle(color: colorLightWhite),
                    decoration: InputDecoration(
                      hintText: 'Description..',
                      hintStyle: TextStyle(
                          color: colorLight3,
                          fontSize: context.deviceWidth * .04,
                          fontWeight: FontWeight.w300),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0), // Add padding inside the TextField
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Consumer<UtilsViewModel>(
                builder: (context, value, child) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: _submitReport,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          backgroundColor: buttonColor,
                          minimumSize: Size(context.deviceWidth * 0.9, 50)),
                      child: value.isLoading
                          ? LoadingAnimationWidget.waveDots(
                              color: Colors.black,
                              size: 40,
                            )
                          : Text(
                              'Submit',
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
