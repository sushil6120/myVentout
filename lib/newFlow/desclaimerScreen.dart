import 'package:flutter/material.dart';
import 'package:overcooked/Utils/colors.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        surfaceTintColor: Colors.black,
        title: const Text(
          'DISCLAIMER',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildDisclaimerSection(
                        "General Disclaimer",
                        "All information, products, services and related graphics are provided on this site is \"as is\" and \"as available\" basis with without warranty of any kind, either expressed or implied. The Website disclaims all warranties, expressed or implied including, without limitation, all implied warranties of merchantability, fitness for a particular purpose, title and non-infringement or arising from a course of dealing, usage, or trade practice. The company makes no representation about the suitability of the information, software, products, and services contained on this Website for any purpose, and the inclusion or offering of any products or services on this Website does not constitute any endorsement or recommendation of such products or services.",
                      ),
                      _buildDisclaimerSection(
                        "Service Reliability",
                        "The Website makes no warranty that the use of the Website will be uninterrupted, timely, secure, without defect or error-free. You expressly agree that use of the site is at your own risk. The Website shall not be responsible for any content found on the Website.",
                      ),
                      _buildDisclaimerSection(
                        "Risk Assumption",
                        "Your use of any information or materials on this site or otherwise obtained through use of this Website is entirely at your own risk, for which we shall not be liable. It shall be your own responsibility to ensure that any products, services or information available through this website meet your specific requirements.",
                      ),
                      _buildDisclaimerSection(
                        "Accuracy of Information",
                        "The Website assumes no responsibility for the accuracy, currency, completeness or usefulness of information, views, opinions, or advice in any material contained on the Website. Any information from third parties or advertisers is made available without making any changes and so the Website cannot guarantee accuracy and is not liable for any inconsistencies arising thereof. All postings, messages, advertisements, photos, sounds, images, text, files, video, or other materials posted on, transmitted through, or linked from the Website, are solely the responsibility of the person from whom such Content originated, and the Website does not control and is not responsible for Content available on the Website.",
                      ),
                      _buildDisclaimerSection(
                        "Errors and Corrections",
                        "There may be instances when incorrect information is published inadvertently on our Website or in the Service such as typographical errors, inaccuracies or omissions that may relate to product descriptions, pricing, promotions, offers, product shipping charges, transit times and availability. Any errors, inaccuracies, or omissions may be corrected at our discretion at any time, and we may change or update information or cancel orders if any information in the Service or on any related website is inaccurate at any time without prior notice (including after you have submitted your order).",
                      ),
                      _buildDisclaimerSection(
                        "Information Updates",
                        "We undertake no obligation to update, amend or clarify information in the Service or on any related website, including without limitation, pricing information, except as required by law. No specified update or refresh date applied in the Service or on any related website should be taken to indicate that all information in the Service or on any related website has been modified or updated.",
                      ),
                      _buildDisclaimerSection(
                        "User Interactions",
                        "The Website shall not be responsible for any interaction between you and the other users of the Website. Under no circumstances will the Website be liable for any goods, services, resources, or content available through such third-party dealings or communications, or for any harm related thereto. The Website is under no obligation to become involved in any disputes between you and other users of the Website or between you and any other third parties. You agree to release the Website from any and all claims, demands, and damages arising out of or in connection with such dispute.",
                      ),
                      _buildDisclaimerSection(
                        "Security",
                        "You agree and understand that while the Website has made reasonable efforts to safeguard the Website, it cannot and does not ensure or make any representations that the Website or any of the information provided by You cannot be hacked by any unauthorised third parties. You specifically agree that the Website shall not be responsible for unauthorized access to or alteration of Your transmissions or data, any material or data sent or received or not sent or received, or any transactions entered into through the Website.",
                      ),
                      _buildDisclaimerSection(
                        "Third Party Content",
                        "You hereby agree and confirm that the Website shall not be held liable or responsible in any manner whatsoever for such hacking or any loss or damages suffered by you due to unauthorized access of the Website by third parties or for any such use of the information provided by You or any spam messages or information that You may receive from any such unauthorised third party (including those which are although sent representing the name of the Website but have not been authorized by the Website) which is in violation or contravention of this Terms of Service or the Privacy Policy. You specifically agree that the Website is not responsible or liable for any threatening, defamatory, obscene, offensive, or illegal content or conduct of any other party or any infringement of another's rights, including intellectual property rights. You specifically agree that the Website is not responsible for any content sent using and/or included on the Website by any third party.",
                      ),
                      _buildDisclaimerSection(
                        "Force Majeure",
                        "The Website has no liability and will make no refund in the event of any delay, cancellation, strike, force majeure, or other causes beyond their direct control, and they have no responsibility for any additional expense omissions delays or acts of any government or authority.",
                      ),
                      _buildDisclaimerSection(
                        "System Damage",
                        "You will be solely responsible for any damage to your computer system or loss of data that results from the download of any information and/or material. Some jurisdictions do not allow the exclusion of certain warranties, so some of the above exclusions may not apply to you.",
                      ),
                      _buildDisclaimerSection(
                        "Liability Limitation",
                        "In no event shall the Website be liable for any direct, indirect, punitive, incidental, special, consequential damages or any damages whatsoever including, without limitation, damages for loss of use, data or profits, arising out of or in any way connected with the use or performance of the site, with the delay or inability to use the site or related services, the provision of or failure to provide Services, or to deliver the products or for any information, software, products, services and related graphics obtained through the site, or any interaction between you and other participants of the Website or otherwise arising out of the use of the Website, damages resulting from use of or reliance on the information present, whether based on contract, tort, negligence, strict liability or otherwise, even if the Website or any of its affiliates/suppliers has been advised of the possibility of damages. If despite the limitation above, the Company is found liable for any loss or damage which arises out of or in any way connected with the use of the Website and/ or provision of Services, then the liability of the Company will in no event exceed, 50% (Fifty percent) of the amount you paid to the Company in connection with such transaction(s) on this Website.",
                      ),
                      _buildDisclaimerSection(
                        "Indemnification",
                        "You accept all responsibility for and hereby agree to indemnify and hold harmless the company from and against, any actions taken by you or by any person authorized to use your account, including without limitation, disclosure of passwords to third parties. By using the Website, you agree to defend, indemnify, and hold harmless the indemnified parties from any and all liability regarding your use of the site or participation in any site's activities. If you are dissatisfied with the Website, or the Services or any portion thereof, or do not agree with these terms, your only recourse and exclusive remedy shall be to stop using the site.",
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisclaimerSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: colorLightWhite,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: colorLight3,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class DisclaimerApp extends StatelessWidget {
  const DisclaimerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disclaimer Example',
      theme: ThemeData.dark(),
      home: const DisclaimerScreen(),
    );
  }
}

void main() {
  runApp(const DisclaimerApp());
}
