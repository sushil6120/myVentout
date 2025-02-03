import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:overcooked/Utils/components.dart';
import 'package:overcooked/newFlow/login/assessmentScreen.dart';
import 'package:overcooked/newFlow/routes/routeName.dart';

class ConsentScreen extends StatefulWidget {
  final String? name;

  const ConsentScreen({
    super.key,
    this.name,
  });

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HtmlWidget(
                '''
                <h2>Consent Form for Online Therapy</h2>
    <p>
        I, ${widget.name}, understand that online therapy is a professional service aimed at supporting my mental well-being. I acknowledge that sessions are confidential, except in cases where:
    </p>
    <ul>
        <li>There is a risk of harm to myself or others.</li>
        <li>Abuse or neglect of a vulnerable person is suspected.</li>
        <li>Disclosure is required by law.</li>
    </ul>
    <p>
        I understand that therapy may involve discussing personal matters, and while it can be beneficial, results are not guaranteed. I have the right to stop therapy at any time. I acknowledge that online sessions rely on digital platforms, and while privacy measures are taken, complete security cannot be guaranteed. I agree to follow guidelines to maintain confidentiality on my end. 
    </p>
    <p>
        I confirm that I have read and understood this form and agree to proceed with online therapy under these terms.
    </p>
                ''',
                textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        elevation: 0,
        height: height * .1,
        child: Center(
            child: customButton(() {
              Navigator.pushNamedAndRemoveUntil(
                  context, RoutesName.bottomNavBarView, (route) => false);
              // Get.to(AssessmentScreen(),
              //     transition: Transition.rightToLeft);
            }, width * 0.9, height * 0.057, 'Done', false)),
      ),
    );
  }
}

