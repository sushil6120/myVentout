import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

class TermAndConditionScreen extends StatefulWidget {
  const TermAndConditionScreen({super.key});

  @override
  State<TermAndConditionScreen> createState() => _TermAndConditionScreenState();
}

class _TermAndConditionScreenState extends State<TermAndConditionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Term & Condition"),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              HtmlWidget(
                '''
                <h1>Terms and Conditions for Ventout</h1>
                <p>Last Updated: [05/09/2024]</p>
                <p>Welcome to Ventout! These Terms and Conditions govern your access to and use of the Ventout app. By using the app, you agree to abide by these Terms and Conditions in full. If you do not agree with any part of these Terms and Conditions, you must not use the app.</p>
                <h2>Introduction</h2>
                <p>Ventout is a digital platform designed to connect users with licensed psychologists and therapists. Our role is limited to facilitating the connection between users and therapy professionals; Ventout does not provide therapy services directly.</p>
                <h2>User Responsibilities</h2>
                <p>By using Ventout, you agree to:</p>
                <ul>
                  <li>Not hold Ventout liable for the quality, effectiveness, or outcomes of the therapy services provided by therapists through the platform.</li>
                  <li>Keep your account information confidential and not share your login credentials with anyone.</li>
                  <li>Provide accurate and truthful information during the registration process.</li>
                  <li>Refrain from soliciting direct contact details from therapists or attempting to bypass the platform to contact them directly.</li>
                  <li>Avoid creating multiple accounts for the same user.</li>
                  <li>Comply with all relevant laws and regulations while using the app.</li>
                  <li>Not harass or otherwise mistreat therapists or other users of the platform.</li>
                  <li>Not copy, replicate, or otherwise misuse the app’s content or functionality.</li>
                </ul>
                <h2>Privacy Policy</h2>
                <p>Your privacy is of paramount importance to us. We collect and use the following information:</p>
                <ul>
                  <li>Nickname: To maintain your anonymity and personalize your experience.</li>
                  <li>Date of Birth and Age Group: To assist therapists in providing age-appropriate care.</li>
                  <li>Phone Number: To ensure unique account identification and facilitate communication.</li>
                </ul>
                <p>This data helps us improve your user experience while respecting your desire for anonymity. For more details on how we handle your information, please refer to our Privacy Policy.</p>
                <h2>User Restrictions</h2>
                <p>Users agree to:</p>
                <ul>
                  <li>Pay for therapy services as detailed within the app.</li>
                  <li>Not seek or use direct contact details of therapists.</li>
                  <li>Not engage in harassment or misuse of the platform.</li>
                </ul>
                <h2>Payment Terms</h2>
                <p>Payments are processed to credit your in-app wallet. All transactions are final and non-refundable.</p>
                <p>Payments are secured through end-to-end encryption and an integrated payment gateway.</p>
                <p>For any payment disputes, please contact us at ventoutright@gmail.com.</p>
                <h2>Termination</h2>
                <p>Ventout reserves the right to terminate or suspend your account immediately, without notice, for:</p>
                <ul>
                  <li>Breaching these Terms and Conditions.</li>
                  <li>Using foul language or exhibiting inappropriate behavior.</li>
                  <li>Harassing or attempting to poach therapists.</li>
                  <li>Attempting to steal data or otherwise misuse the platform.</li>
                </ul>
                <h2>Liability</h2>
                <p>Ventout disclaims any liability for:</p>
                <ul>
                  <li>The quality or outcomes of therapy services provided by therapists.</li>
                  <li>Any direct or indirect damages or losses resulting from the use of the app or therapy services.</li>
                  <li>Technical issues with the app or unauthorized access to user accounts.</li>
                </ul>
                <h2>Governing Law</h2>
                <p>These Terms and Conditions are governed by and construed in accordance with the laws of India. Any disputes arising out of or related to the use of the app will be subject to the exclusive jurisdiction of the courts in Delhi, India.</p>
                <h2>Dispute Resolution</h2>
                <p>If you have any issues or disputes, please contact us via email to discuss and resolve the matter. We will make reasonable efforts to address your concerns before proceeding to arbitration.</p>
                <h2>User-Generated Content</h2>
                <p>The app does not host or display user-generated content. All content within the app is provided by therapists and is governed by these Terms and Conditions.</p>
                <h2>Indemnification</h2>
                <p>By using Ventout, you agree to indemnify, defend, and hold harmless Ventout, its affiliates, directors, officers, employees, and agents from and against any claims, liabilities, damages, losses, or expenses (including reasonable legal fees) arising from or related to your use of the app or violation of these Terms and Conditions.</p>
                <h2>Changes to Terms and Conditions</h2>
                <p>Ventout reserves the right to modify these Terms and Conditions at any time. Changes will take effect immediately upon posting on the app. Users are encouraged to review the Terms and Conditions regularly. Continued use of the app after changes constitutes acceptance of the revised terms.</p>
                <h2>Contact Information</h2>
                <p>For any questions or concerns regarding these Terms and Conditions, please contact us at:</p>
                <ul>
                  <li>Email: ventoutright@gmail.com</li>
                  <li>Address: [Your Contact Address]</li>
                </ul>
                <h2>Intellectual Property</h2>
                <p>All content, trademarks, service marks, logos, and intellectual property rights appearing on the app are the property of Ventout or their respective owners. Users are not permitted to use, copy, distribute, or create derivative works from any content found on the app without express written permission from Ventout.</p>
                <h2>User Conduct</h2>
                <p>Users agree to use the app responsibly and ethically. This includes, but is not limited to:</p>
                <ul>
                  <li>Not engaging in any form of harassment, abuse, or offensive behavior towards therapists or other users.</li>
                  <li>Not uploading, sharing, or distributing any content that is illegal, harmful, or violates the rights of others.</li>
                  <li>Not attempting to access or interfere with the app’s systems, data, or networks without authorization.</li>
                </ul>
                <h2>Disclaimer of Warranties</h2>
                <p>Ventout provides the app and services on an "as is" and "as available" basis. We do not guarantee that the app will be uninterrupted, error-free, or free of viruses or other harmful components. Ventout disclaims all warranties, whether express or implied, including, but not limited to, implied warranties of merchantability and fitness for a particular purpose.</p>
                <h2>Limitation of Liability</h2>
                <p>To the maximum extent permitted by law, Ventout shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses, resulting from:</p>
                <ul>
                  <li>Your use or inability to use the app.</li>
                  <li>Any unauthorized access to or use of our servers and/or any personal information stored therein.</li>
                  <li>Any interruption or cessation of transmission to or from the app.</li>
                  <li>Any bugs, viruses, trojan horses, or the like that may be transmitted to or through our app by any third party.</li>
                  <li>Any errors or omissions in any content or for any loss or damage incurred as a result of the use of any content posted, emailed, transmitted, or otherwise made available through the app.</li>
                </ul>
                <h2>Severability</h2>
                <p>If any provision of these Terms and Conditions is found to be invalid or unenforceable by a court of competent jurisdiction, the remaining provisions shall continue to be valid and enforceable.</p>
                <h2>Entire Agreement</h2>
                <p>These Terms and Conditions, along with any other legal notices and agreements published by Ventout on the app, constitute the entire agreement between you and Ventout concerning the use of the app. They supersede all prior agreements and understandings, whether written or oral, regarding the use of the app.</p>
                <h2>Waiver</h2>
                <p>No waiver of any term of these Terms and Conditions shall be deemed a further or continuing waiver of such term or any other term, and Ventout's failure to assert any right or provision under these Terms and Conditions shall not constitute a waiver of such right or provision.</p>
                ''',
                textStyle: TextStyle(fontSize: 10.0, color: Colors.white),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
