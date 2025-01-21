import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ventout/Utils/components.dart';
import 'package:ventout/Utils/responsive.dart';
import 'package:ventout/newFlow/routes/routeName.dart';
import 'package:ventout/newFlow/viewModel/authViewModel.dart';

import '../../Utils/colors.dart';

// ignore: must_be_immutable
class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({
    super.key,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController textController = TextEditingController();

  bool autoValidate = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter'),
            ),
            content: Text(
              'Do You Want To Exit The App',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter'),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Container(
                        width: width * 0.25,
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: const Center(
                            child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        exit(0);
                      },
                      child: Container(
                        width: width * 0.25,
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: const Center(
                            child: Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded)),
   
            elevation: 0.0,
            toolbarHeight: height * 0.08,
            backgroundColor: Colors.transparent,
            centerTitle: true,
          ),
          body: Form(
            key: formKey,
            autovalidateMode: autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //     'Psychologist registration',
                      //     style: TextStyle(
                      //         fontFamily: 'LeagueSpartan',
                      //         color: Colors.white,
                      //         fontSize: 26,
                      //         fontWeight: FontWeight.w600),
                      //   ),
                      SizedBox(height: height * 0.02),
                      Text(
                        'What do we call you?',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            height: 1,
                            fontSize: context.deviceWidth * .094,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: height * 0.06),
                      FormField<String?>(
                        validator: (value) {
                          var valueText = textController.text;
                          if (valueText.isEmpty) {}
                          return null;
                        },
                        builder: (state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: width * .6,
                                child: TextFormField(
                                  controller: textController,
                                  cursorColor: buttonColor,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter name';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                      color: colorLightWhite,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                        color: errorColor,
                                        fontSize: context.deviceWidth * .028),
                                    hintText: 'Name',
                                    hintStyle: GoogleFonts.inter(
                                      color: colorDark3.withOpacity(.4),
                                      fontSize: context.deviceWidth * .07,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: errorColor),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: colorLightWhite),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: colorLightWhite),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: colorLightWhite),
                                    ),
                                  ),
                                ),
                              ),
                              if (state.hasError)
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.2, bottom: 10),
                                  child: Text(
                                    state.errorText!,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Inter'),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: height * 0.04),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: Consumer<AuthViewModel>(
            builder: (context, value, child) {
              return customButton(() async {
                FocusScope.of(context).unfocus();

                if (formKey.currentState!.validate()) {
                  Navigator.pushNamed(context, RoutesName.genderSelectionScreen,
                      arguments: {'name': textController.text});
                }
              }, width * 0.9, height * 0.057, 'Continue', value.isLoading);
            },
          )),
    );
  }
}
