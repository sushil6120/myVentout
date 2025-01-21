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
                <h1>Ventout Privacy Policy</h1>
                <p>Last Updated: [05/09/2024]</p>
                <p>Welcome to Ventout’s Privacy Policy. This document outlines how we collect, store, protect, and share your information, as well as your rights and choices regarding your data. We encourage you to read this Privacy Policy alongside our Terms and Conditions of Use.</p>
                <p>Your privacy is of paramount importance to us. This Privacy Policy explains our practices in clear, straightforward language to help you understand how we handle your information.</p>
                <p>This Privacy Policy applies from [Date].</p>
                <h2>1. Who Are We?</h2>
                <p>Ventout is a digital platform designed to connect users with licensed psychologists and therapists. For any queries about our data practices, you can reach us at ventoutright@gmail.com.</p>
                <h2>2. Where This Policy Applies</h2>
                <p>This Privacy Policy applies to all services provided by Ventout, including our website, mobile app, and any other services we operate. For certain services, a separate privacy policy may apply. In such cases, that specific policy will take precedence over this Privacy Policy.</p>
                <h2>3. Information We Collect</h2>
                <h3>Personal Information</h3>
                <p>At Ventout, we collect and use the following types of information to enhance your experience while respecting your privacy:</p>
                <ul>
                  <li>Nickname: Used to maintain your anonymity and personalize your interactions on the app.</li>
                  <li>Date of Birth and Age Group: Helps therapists provide age-appropriate care and support.</li>
                  <li>Phone Number: Ensures unique account identification and facilitates communication with you.</li>
                </ul>
                <h3>Profile Information</h3>
                <p>You may choose to add additional information to your profile. We advise against including sensitive details such as email addresses, phone numbers, or financial information.</p>
                <h3>Geolocation Information</h3>
                <p>If you enable location services, we collect information about your geographical location to enhance features and improve your app experience.</p>
                <h3>Communication Data</h3>
                <p>We gather information from interactions with our customer support team and from messages and content shared on the app.</p>
                <h3>Technical Data</h3>
                <p>When using our services, we automatically collect:</p>
                <ul>
                  <li>Usage Information: Details about your app usage, including features accessed and interactions with other users.</li>
                  <li>Device Information: Data about your device, such as IP address, device ID, and app settings.</li>
                  <li>Cookies and Similar Technologies: To recognize you and track usage patterns.</li>
                </ul>
                <h2>4. How We Use Your Information</h2>
                <h3>A. To Provide and Manage Our Services</h3>
                <ul>
                  <li>Create and manage your account</li>
                  <li>Offer customer support and respond to inquiries</li>
                  <li>Communicate about updates and changes</li>
                  <li>Personalize your experience and complete transactions</li>
                </ul>
                <h3>B. To Facilitate User Connections</h3>
                <ul>
                  <li>Recommend users to each other</li>
                  <li>Enable profile visibility and interactions</li>
                </ul>
                <h3>C. To Operate Advertising and Marketing Campaigns</h3>
                <ul>
                  <li>Measure the effectiveness of ads</li>
                  <li>Inform you about relevant products and services</li>
                </ul>
                <h3>D. To Improve and Develop Our Services</h3>
                <ul>
                  <li>Conduct surveys and analyze feedback</li>
                  <li>Enhance app features based on user behavior</li>
                </ul>
                <h3>E. To Prevent and Address Fraud and Illegal Activities</h3>
                <ul>
                  <li>Monitor for and address policy violations</li>
                  <li>Enforce our rights and assist law enforcement</li>
                </ul>
                <h3>F. To Ensure Legal Compliance</h3>
                <ul>
                  <li>Comply with legal requirements and regulations</li>
                </ul>
                <h3>Legal Bases for Processing</h3>
                <ul>
                  <li>Contractual Necessity: To fulfill our contract with you, such as managing your account.</li>
                  <li>Legitimate Interests: For purposes like service improvement, advertising, and fraud prevention.</li>
                  <li>Compliance with Laws: To meet legal obligations.</li>
                  <li>Consent: For processing sensitive data and specific requests (you can withdraw consent at any time).</li>
                </ul>
                <h2>5. How We Share Your Information</h2>
                <p>We share your information with:</p>
                <ul>
                  <li>Other Users: To facilitate connections and interactions.</li>
                  <li>Service Providers: Third parties that assist with app operations.</li>
                  <li>Legal Authorities: When required by law or to protect our rights.</li>
                </ul>
                <h2>6. Your Rights and Choices</h2>
                <h3>Access and Update</h3>
                <p>You can review, update, or delete your information through your account settings. For additional help, contact our support team.</p>
                <h3>Device Permissions</h3>
                <p>Adjust device settings to control data collection, such as location services or notifications.</p>
                <h3>Account Closure</h3>
                <p>Uninstalling the app stops data collection but does not delete your account. To close your account, use the app’s functionality.</p>
                <h2>7. How Long We Retain Your Information</h2>
                <p>We retain your data only as long as necessary for legitimate business purposes:</p>
                <h3>General Retention</h3>
                <p>Data is deleted after account closure, with additional safety windows for potential investigations.</p>
                <h3>Legal and Compliance</h3>
                <p>Retain records to comply with legal requirements.</p>
                <h2>8. No Children Allowed</h2>
                <p>Our services are for individuals 18 years of age or older. If you suspect a user is underage, please report them via the app.</p>
                <h2>9. Privacy Policy Changes</h2>
                <p>We may update this Privacy Policy periodically. We will notify you of significant changes, allowing time for you to review and understand the updates.</p>
                <h2>10. How to Contact Us</h2>
                <p>For questions about this Privacy Policy, contact us at ventoutright@gmail.com.</p>
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
