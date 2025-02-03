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
                <h1>VO Terms and Conditions</h1>  
<p>Last Updated: [25/01/2025]</p>  
<p>Welcome to VO! These terms govern your use of the VO app. By accessing or using our platform, you agree to comply with these terms fully. If you do not agree, you must discontinue using the app immediately.</p>  


<h2>Overview</h2>  
<p>VO is a platform designed to facilitate connections between users and licensed psychologists or therapists. VO itself does not provide therapy services directly; it acts solely as a bridge between users and professionals.</p>  


<h2>User Obligations</h2>  
<p>By accessing the VO platform, you agree to the following responsibilities:</p>  
<ul>  
  <li>VO will not be held accountable for the quality or effectiveness of therapy services offered through the app.</li>  
  <li>You will keep your login credentials confidential and not share them with others.</li>  
  <li>Provide accurate and truthful information during registration.</li>  
  <li>Avoid bypassing the platform to contact therapists directly.</li>  
  <li>Refrain from creating multiple accounts for the same user.</li>  
  <li>Comply with applicable laws and regulations when using VO services.</li>  
  <li>Treat therapists and other users respectfully and refrain from harassment.</li>  
  <li>Not copy, misuse, or manipulate any content or features on the app.</li>  
</ul>  


<h2>Privacy Practices</h2>  
<p>Your privacy is vital to us. VO collects and uses the following data:</p>  
<ul>  
  <li>Nickname: To preserve anonymity and enhance personalization.</li>  
  <li>Date of Birth and Age Group: To provide age-appropriate assistance.</li>  
  <li>Phone Number: For account verification and communication purposes.</li>  
</ul>  
<p>We prioritize anonymity while enhancing your experience. For more information, refer to our Privacy Policy.</p>  


<h2>Usage Restrictions</h2>  
<p>Users agree to:</p>  
<ul>  
  <li>Make payments for therapy services as outlined in the app.</li>  
  <li>Refrain from seeking direct contact with therapists outside of VO.</li>  
  <li>Avoid behavior that disrupts or misuses the platform.</li>  
</ul>  


<h2>Payment Policies</h2>  
<p>All payments are processed securely to credit your in-app wallet. Transactions are final and non-refundable.</p>  
<p>For payment-related concerns, please contact us at ventoutright@gmail.com.</p>  


<h2>Account Termination</h2>  
<p>VO reserves the right to suspend or terminate your account for:</p>  
<ul>  
  <li>Violating these terms.</li>  
  <li>Using inappropriate language or behavior.</li>  
  <li>Harassing or attempting to poach therapists.</li>  
  <li>Engaging in fraudulent activities or data misuse.</li>  
</ul>  


<h2>Limitation of Liability</h2>  
<p>VO is not liable for:</p>  
<ul>  
  <li>The quality or outcomes of therapy services provided by therapists.</li>  
  <li>Damages resulting from app use or technical issues.</li>  
  <li>Unauthorized access to your account.</li>  
</ul>  


<h2>Jurisdiction</h2>  
<p>These terms are governed by Indian law. Any disputes will fall under the exclusive jurisdiction of courts in Delhi, India.</p>  


<h2>Resolving Disputes</h2>  
<p>For any conflicts or complaints, reach out to us via email before considering legal action. We will work to resolve the issue amicably.</p>  


<h2>Intellectual Property</h2>  
<p>All content, trademarks, and materials on the app belong to VO or their respective owners. Unauthorized use is strictly prohibited.</p>  


<h2>Conduct Guidelines</h2>  
<p>Users must use VO responsibly by:</p>  
<ul>  
  <li>Avoiding offensive or harmful behavior.</li>  
  <li>Not sharing illegal or harmful content.</li>  
  <li>Refraining from unauthorized attempts to access the app’s systems or data.</li>  
</ul>  


<h2>Warranties Disclaimer</h2>  
<p>The VO platform is provided "as is," without guarantees of uninterrupted or error-free functionality. We disclaim all implied warranties, including suitability for a specific purpose.</p>  


<h2>Modifications</h2>  
<p>VO may update these terms at any time. Changes will take effect upon being posted on the app. Continuing to use the platform constitutes your acceptance of the revised terms.</p>  


<h2>Contact Details</h2>  
<p>For questions about these terms, contact us at:</p>  
<ul>  
  <li>Email: ventoutright@gmail.com</li>  
</ul>  


<h2>Severability</h2>  
<p>If any term is deemed invalid by a court, the remaining terms will remain in full effect.</p>  


<h2>Entire Agreement</h2>  
<p>These terms represent the complete agreement between you and VO regarding the use of the app, superseding prior agreements.</p>  


<h2>Waiver</h2>  
<p>Failure to enforce any term does not constitute a waiver of our rights to enforce it later.</p>
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
