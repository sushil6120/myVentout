import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
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
                <h1>VO Privacy Policy</h1>
<p>Last Updated: [25/01/2025]</p>
<p>Welcome to the VO Privacy Policy. This document explains how we collect, handle, protect, and share your information, along with the rights and choices you have regarding your data. We recommend reviewing this Privacy Policy in conjunction with our Terms of Use.</p>
<p>Your privacy matters greatly to us. This Privacy Policy is designed to clearly explain how we manage your information in a straightforward manner.</p>
<p>This Privacy Policy is effective from [Date].</p>

<h2>1. About Us</h2>
<p>VO is a digital platform aimed at connecting users with licensed psychologists and therapists. If you have questions about our data practices, feel free to contact us at ventoutright@gmail.com.</p>

<h2>2. Scope of This Policy</h2>
<p>This Privacy Policy applies to all services provided by VO, including our website, mobile app, and related offerings. In certain cases, specific services may have their own privacy policies, which will take precedence over this document.</p>

<h2>3. Information We Collect</h2>

<h3>Personal Data</h3>
<p>We collect the following information to enhance your experience while safeguarding your privacy:</p>
<ul>
  <li><strong>Nickname:</strong> To maintain anonymity and personalize your experience.</li>
  <li><strong>Date of Birth and Age Group:</strong> To enable age-appropriate support from therapists.</li>
  <li><strong>Phone Number:</strong> For account identification and communication purposes.</li>
</ul>

<h3>Profile Details</h3>
<p>You may optionally add information to your profile. Please avoid sharing sensitive details like financial information or personal contact details.</p>

<h3>Location Data</h3>
<p>If location services are enabled, we collect geolocation data to improve functionality and personalize your experience.</p>

<h3>Communication Records</h3>
<p>We collect data from customer support interactions and messages exchanged on the platform.</p>

<h3>Technical Information</h3>
<p>Automatically collected data includes:</p>
<ul>
  <li><strong>Usage Data:</strong> Insights into how you use our app and interact with others.</li>
  <li><strong>Device Data:</strong> Details like your device type, IP address, and app preferences.</li>
  <li><strong>Cookies and Similar Technologies:</strong> To recognize users and analyze app usage trends.</li>
</ul>

<h2>4. How We Use Your Information</h2>

<h3>A. Delivering and Managing Services</h3>
<ul>
  <li>Account creation and management</li>
  <li>Providing customer support</li>
  <li>Sending updates and notifications</li>
  <li>Personalizing user experience</li>
</ul>

<h3>B. Facilitating Connections</h3>
<ul>
  <li>Recommending compatible users</li>
  <li>Allowing profile visibility and interaction</li>
</ul>

<h3>C. Advertising and Marketing</h3>
<ul>
  <li>Assessing the effectiveness of advertisements</li>
  <li>Informing users about relevant services</li>
</ul>

<h3>D. Improving Services</h3>
<ul>
  <li>Conducting surveys and analyzing feedback</li>
  <li>Enhancing app features and functionality</li>
</ul>

<h3>E. Ensuring Security</h3>
<ul>
  <li>Monitoring and addressing policy violations</li>
  <li>Assisting law enforcement when necessary</li>
</ul>

<h3>F. Legal Compliance</h3>
<ul>
  <li>Meeting legal and regulatory requirements</li>
</ul>

<h3>Legal Basis for Data Processing</h3>
<ul>
  <li><strong>Contractual Obligation:</strong> To provide the agreed-upon services.</li>
  <li><strong>Legitimate Interests:</strong> For improving services, advertising, and fraud prevention.</li>
  <li><strong>Legal Compliance:</strong> To meet legal obligations.</li>
  <li><strong>Consent:</strong> For specific purposes, such as sharing sensitive data (can be withdrawn at any time).</li>
</ul>

<h2>5. Sharing Your Information</h2>
<p>We may share your information with:</p>
<ul>
  <li><strong>Other Users:</strong> To enable meaningful connections.</li>
  <li><strong>Service Providers:</strong> Trusted third parties supporting app operations.</li>
  <li><strong>Legal Entities:</strong> When legally required or to safeguard our rights.</li>
</ul>

<h2>6. Your Rights and Options</h2>

<h3>Access and Modify</h3>
<p>Update or delete your data through account settings. Contact support for assistance.</p>

<h3>Device Permissions</h3>
<p>Control data collection (e.g., location or notifications) through device settings.</p>

<h3>Close Your Account</h3>
<p>Deleting the app doesn’t delete your account. Use in-app options for account closure.</p>

<h2>7. Data Retention</h2>

<h3>Retention Period</h3>
<p>We keep data only as long as necessary for business purposes or legal compliance.</p>

<h3>Legal Requirements</h3>
<p>Certain records may be retained to fulfill legal obligations.</p>

<h2>8. Age Restrictions</h2>
<p>Our services are intended for users 18 years or older. Report underage users via the app.</p>

<h2>9. Updates to This Policy</h2>
<p>We may revise this policy occasionally and will notify you of significant changes.</p>

<h2>10. Contact Us</h2>
<p>Questions? Reach us at ventoutright@gmail.com.</p> 
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
