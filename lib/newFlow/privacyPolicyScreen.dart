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
                <h1>AIMENT PRIVATE LIMTED Privacy Policy</h1>
<p>Last Updated: May 1st, 2025</p>

<p>AIMENT PRIVATE LIMTED ("AIMENT," "We," "Us" or "Our") respects your privacy, and we want to inform you of how we collect, use, share and otherwise process Personal Data we collect about Users who use our websites or mobile applications, or otherwise interact with us online or offline (collectively, our "Websites and Services").</p>

<p><strong>• Personal Data</strong> means information that identifies, relates to, describes, is reasonably capable of being associated with, or could reasonably be linked, directly or indirectly, with a particular living person or household. The type of Personal Data we collect depends on the nature of your interactions with us and our Websites and Services.</p>

<p><strong>• We do not knowingly collect or solicit Personal Information from Minors</strong> or knowingly allow Minors to access the Applications, register for the Services, without prior consent of the Minor's legal guardian or parent. If you are a Minor, we will only allow you to access the Applications and register for the Services with a duly filled in consent form signed by your legal guardian or parent ("Consent Form"). In the event that we are informed that we have collected Personal Information from a Minor without a Consent Form, we will verify such Personal Information internally and delete that Personal Information as quickly as possible. If you believe that we might have any Personal Information from or about a Minor (without due consent), please contact us through our website.</p>

<p><strong>• AIMENT may collect, use and otherwise process the following categories of Personal Data:</strong></p>

<p><strong>• Name, Contact Information, and Unique Identifiers</strong> – Identifiers, such as a real name, alias, postal address, unique personal identifier, online identifier, internet protocol (IP) address, phone number, email address, account name and login credentials, driver's license number, or other government-issued identifiers.</p>
<p><strong>• Financial Information</strong> – Financial information, including bank account number, credit or debit card number, or other financial information.</p>
<p><strong>• Medical Information</strong> – Medical Information such as any information in possession of or derived from yourself, a healthcare provider, healthcare insurer, healthcare service plan, pharmaceutical company, or contractor regarding an individual's medical history, mental or physical condition, or treatment. This includes an individual's insurance policy number or subscriber identification number, any unique identifier used by a health insurer to identify the individual, or any information in the individual's application and claims history (including prescription information).</p>
<p><strong>• Protected Characteristics</strong> – Characteristics of protected classifications under Indian law, such as race, gender, physical or mental disability, and religion.</p>
<p><strong>• Commercial Information</strong> – Commercial information, including records of personal property, products or services purchased, obtained, or considered, or other purchasing or consuming histories or tendencies.</p>
<p><strong>• Biometric Information</strong> – Biometric information, including an individual's physiological, biological, or behavioural characteristics to the extent it can be used to establish individual identity. Biometric information consists of, but is not limited to, imagery of the iris, retina, fingerprint, face, hand, palm, and voice recordings, from which an identifier template (such as a faceprint, a minutiae template, or a voiceprint) can be extracted, and keystroke patterns or rhythms, gait patterns or rhythms, and sleep, health, or exercise data that contain identifying information.</p>
<p><strong>• Network Activity Data</strong> – Internet or other electronic network activity information, such as browsing history, search history, and information regarding an individual's interaction with an internet website, application, or advertisement.</p>
<p><strong>• Geolocation Data</strong> – An individual's approximate or precise geolocation data.</p>
<p><strong>• Electronic and Sensory Data</strong> – Audio, electronic, visual, thermal, olfactory, or similar information (e.g., a recording of a customer service call or profile photograph). This also includes the contents of your messages, chats, or other communications that you send to us or through the website.</p>
<p><strong>• Professional and Educational Information</strong> – An individual's professional or employment-related information, including academic information and records, licenses, professional or employment-related information, and professional interactions with AIMENT.</p>
<p><strong>• Inferences</strong> – Inferences drawn from any of the categories of Personal Data listed in to create a profile about a consumer reflecting the consumer's preferences, characteristics, psychological trends, predispositions, behavior, attitudes, intelligence, abilities, and aptitudes.</p>
<p><strong>• Sensitive Personal Data</strong> –Types of Personal Data that may be considered "sensitive" such as biometric information, communications or messages content, financial information, login credentials, government-issued identifiers, health insurance and medical information, and protected characteristics. Further, We may also collect and process Personal Data that under certain laws may be defined as "Consumer Data."</p>

<p><strong>• We will only process Sensitive Personal Data</strong> when we have either your express consent or permitted under applicable law. We will also process your Personal Data if required for example, when necessary to comply with applicable law, respond to legitimate requests from government authorities, to protect or defend our legal interests, and if necessary, to protect the safety of our employees and other stakeholders.</p>

<p><strong>• We may combine the Personal Data</strong> we collect about you online with the Personal Data we collect about you from our offline interactions with you (for example, our interactions by telephone or in person). We may also combine any of the information we collect about you with information we lawfully obtain from other sources, such as public records or websites, or other third parties (e.g., health care professionals, patient groups, government agencies).</p>

<h2>PURPOSES FOR PROCESSING PERSONAL DATA</h2>

<p><strong>• We collect, use, and disclose Personal Data for the following purposes:</strong></p>

<p><strong>• We may collect Personal Data directly from you</strong>, such as when you disclose Personal Data to us to receive information, opportunities, updates, or special offers from AIMENT and its business partners. You can also ask us about our products or services, or someone can ask for them for you. You may want to join one of our programs or be part of a community that we support. Also, some of our Websites and Services offer interactive content, like education and support. Users of our Websites and Services may provide Personal Data to AIMENT to experience these features. We also collect Personal Data from our vendors and from third parties when they disclose Personal Data to us, as well as from joint marketing partners, publicly-available sources, and social media.</p>

<p><strong>• In order to provide a personalised browsing experience</strong>, We may use your Personal Information to improve our marketing and promotional efforts, to analyse usage, improve the content of our Website and Services, product offerings, and to customize content, layout, and services, in order to improve Website and Services with a view to optimize We for you and better tailor it to meet your needs.</p>

<p><strong>• We may track the IP address</strong> of your device and save certain User Data on your device in the form of cookies. We use this data only to customize the Application to your interests and to measure traffic within the Application. User data of a general nature such as information relating to user demographics may however be revealed to third parties.</p>

<p><strong>• With your express consent</strong>, we may share information regarding your geographical location to third-party advertisers to display more relevant advertisements to you on the Application.</p>

<p><strong>• We use certain information</strong> provided by you in order to facilitate communications between you and other users.</p>

<p><strong>• To ensure a seamless experience</strong> on the Application for you and to ensure your maximum benefit and comfort, we use or may use the data collected through cookies, log file, and clear gifs information to:</p>

<p><strong>• remember information</strong> so that you will not have to re-enter it during your visit or the next time you visit the site;</p>
<p><strong>• provide custom, personalized content and information</strong>, including relevant advertising;</p>
<p><strong>• provide and monitor the effectiveness</strong> of our Services;</p>
<p><strong>• monitor aggregate metrics</strong> such as total number of visitors, traffic, usage, and demographic patterns on our Application and our Services;</p>
<p><strong>• diagnose or fix technology problems</strong> on the Application; and</p>
<p><strong>• otherwise plan for and enhance our Services</strong>.</p>

<p><strong>• We use certain third-party analytics tools</strong> to help us measure traffic and usage trends for the Services. These tools collect information, which is not personal or sensitive in nature sent by your device or our Services, including the web pages you visit, add-ons, and other information that assists us in improving the Services. We collect and use this analytics information with analytics information from other Users in the form of anonymized logs, so that it cannot be used to identify any particular individual user.</p>

<p><strong>• We may anonymize your Personal Information</strong> and Consultation Information so that you cannot be individually identified, and provide that information to our partners. We may combine this information with information received from our other users in a way that it is no longer identifiable to a particular individual, for inter alia research and development purposes in order to enhance the quality of our Services.</p>

<h2>WE COLLECT YOUR INFORMATION IN THE FOLLOWING WAYS:</h2>

<p><strong>• You may collect Personal Information when you:</strong></p>
<p><strong>• access the Application;</strong></p>
<p><strong>• request, purchase and use the Services;</strong></p>
<p><strong>• communicate with us</strong> via phone calls, chat, email, web forms, social media and other methods of communication through the Application or otherwise, and</p>
<p><strong>• subscribe to our proprietary material.</strong></p>

<p><strong>• We may receive certain information</strong> that is stored or processed by third parties, about you via cookies, web beacons and other similar technologies, or when you use third-party sign-in services through Google etc. We use these technologies for different reasons, such as to provide, improve, measure, personalize, or share online services with you and to improve website functionality, performance, and other cookies to remember your preferences or to show relevant content. You can review, modify, or revoke your consent to cookies by customizing your preferences in our Cookie Preference Centre which can be accessed by any of our Websites.</p>

<p><strong>• We may collect certain Personal Information</strong> about you from your employers, educational institutions or other entities that provide you access to our Services.</p>

<p><strong>• We may collect your Personal Information</strong> through your interactions with our Experts and you hereby consent to the same.</p>

<p><strong>• Each time you visit the Application</strong>; we may automatically collect information including User Data about you through automated means.</p>

<h2>SHARING AND DISCLOSURE OF PERSONAL DATA</h2>

<p><strong>• In certain circumstances</strong> we may share the Personal Data described above without further notice to you, unless required by applicable law, with the following categories of third parties:</p>

<p><strong>• AIMENT subsidiaries and corporate affiliates.</strong></p>
<p><strong>• Service providers</strong>, who work on AIMENT's behalf to provide certain services.</p>
<p><strong>• Third parties</strong>, including for marketing and advertising purposes, such as to conduct online targeted advertising.</p>
<p><strong>• Business partners</strong> with whom we collaborate regarding our investigational products and programs, such as scientific advisors, joint venture partners, and strategic collaboration partners.</p>
<p><strong>• We may also disclose Personal Data</strong> listed in Section A in the following contexts:</p>

<p><strong>• To legal, regulatory, or other enforcement authorities</strong> and other third parties if required to comply with law, regulation, or judicial process, or to protect the security, rights, and property of AIMENT or of users of our Websites and Services;</p>
<p><strong>• To third parties</strong> in the event AIMENT is involved in an actual or contemplated merger, acquisition, or sale of a portion of its assets, or in the unlikely event of bankruptcy. If this occurs, we will seek assurances that the Personal Data will be processed in accordance with this Privacy Statement;</p>
<p><strong>• To third parties</strong> to protect rights and interests, such as when needed for corporate audits, to investigate or respond to a complaint or threat, or to exercise our legal rights.</p>

<p><strong>• We may share Personal Information</strong> (including but not limited to, information from cookies, log files, and usage data and excluding any Consultation Information) with businesses that are legally part of the same group of companies that AIMENT is part of, or that become part of that group ("Affiliates"). Our Affiliates may only use this information to help provide, understand, and improve the Services (including by providing analytics) and Affiliates' own services (including by providing you with better and more relevant experiences).</p>

<p><strong>• We may also share your Personal Information</strong> and Consultation Information with Affiliates, service providers and other third-parties who process Personal Information on our behalf in relation to providing you with access to the Application and the Services.</p>

<p><strong>• We also may share your Personal Information</strong> as well as information from tools like cookies, log files, and Consultation Information with third-party organizations that help us provide the Services to you. Our service providers will only be given access to your information as is reasonably necessary to provide the Services. All the service providers and third parties engaged by AIMENT for providing the Services shall be bound by adequate confidentiality terms to protect the Consultation Information (that may be shared with such service provider/third party only to the extent allowed by this Privacy Policy) and the Personal Information of the User so that such information is not used in any manner not specified in this Privacy Policy.</p>

<p><strong>• Please note</strong> that Personal Information or content that you voluntarily disclose and consent to posting to the Application, or post to any social media account owned and operated by AIMENT, will become available to the public. No other information provided by you is otherwise shared with the public. Once you have shared such information or made it public, the same may be re-shared by others, re-posted by AIMENT, or used by AIMENT for the purposes of promotion, analysis, research or studies.</p>

<p><strong>• We may share information about you</strong> with your employer, institution or other entity that enables your access to our Services, after ensuring that such information has been anonymised to ensure that your identity cannot be determined. We will not share your Personal Information or Consultation Information with your employer, educational institution or other entity that enables your access to our Services, except if permitted under applicable laws or based on your consent or in circumstances identified in Clause.</p>

<p><strong>• AIMENT may disclose your Personal Information</strong> in the circumstances permitted under applicable laws. We disclose or transfer your Personal Information in the manner set out under this Privacy Policy only to those third parties (including Affiliates) who comply with applicable data protection laws and adhere to same standards of data protection as maintained by us.</p>

<h2>PERSONAL DATA RETENTION AND MINIMIZATION</h2>

<p>AIMENT uses the minimum amount of Personal Data reasonably necessary to accomplish the purpose for which it was collected. Further, we retain your Personal Data for as long as necessary to fulfil the purposes for which they are collected or to satisfy a legal obligation imposed on AIMENT. Personal Data that are no longer needed for the above purposes may be deleted or deidentified. Whenever we de-identify Personal Data, we take reasonable measures to ensure that the information cannot be associated with a consumer or household, and we maintain and use the information in deidentified form. We will not attempt to reidentify the information, except that we may attempt to reidentify the information solely for the purpose of determining whether our deidentification processes satisfy applicable legal requirements.</p>

<h2>PROTECTING PERSONAL DATA</h2>

<p><strong>• AIMENT implements technical, physical, and administrative protections</strong> to keep Personal Data secure. However, despite these protections, no organization, including AIMENT, can completely guarantee that your Personal Data are not accessed by unauthorized people/bad actors. If AIMENT becomes aware that Personal Data has been compromised, AIMENT will promptly take steps to resolve the incident in accordance with applicable laws and regulations.</p>

<p><strong>• Please make sure</strong> that you maintain the secrecy of your account information. For the safety and security of your information, we have implemented reasonable security measures and appropriate technical and organizational procedures pursuant to applicable laws, to help protect the information that you provide to us. We restrict access to information about you to those AIMENT employees and third parties who need to know that information as part of their responsibilities. We also educate our employees and such third-parties about the importance of confidentiality and customer privacy through standard operating protocols.</p>

<p><strong>• You are solely responsible</strong> for maintaining confidentiality of your password and user identification to access your User Account ("User Credentials"). You shall be solely responsible for all activities and transmission performed by you through your User Credentials. AIMENT assumes no responsibility or liability for your improper use of your Credentials or information contained in your User Account.</p>

<h2>EXERCISING DATA SUBJECT RIGHTS</h2>

<p><strong>• You, or an authorized agent</strong>, may have the right to request access to, modification, export or deletion of, your Personal Data under law. These rights are not absolute and may only apply in certain circumstances. This means that we may be unable (e.g., due to legal requirements) or not obligated to satisfy your request. In some cases, we may need to collect additional Personal Data from you in order to verify your identity before providing you access to or deleting your Personal Data, such as a government-issued identification. AIMENT will not discriminate against you for exercising your rights, but we may not be able to provide you with Services that you have requested if we are not able to use your Personal Data.</p>

<p><strong>• If you have provided permission (consent)</strong> to AIMENT to process your Personal Data, you have the right to withdraw your consent for such processing at any time by contacting us as outlined in our "Contact Us" section below.</p>

<p><strong>• You have the right to redress</strong> any grievances that you may have in relation to the processing of your Personal Information or exercising of any of your rights as provided below:</p>

<p><strong>• The right to access information</strong> pertaining to your Personal Information, the parties we share it with, and other information as the government may prescribe in this respect;</p>
<p><strong>• The right to correct, complete, update, and erase</strong> your Personal Information; and.</p>
<p><strong>• The right to nominate any other individual</strong> that will, in case of your death or incapacity, exercise your rights under the privacy notice;</p>

<h2>INTERNATIONAL TRANSFERS OF PERSONAL DATA</h2>

<p><strong>• Your Personal Data may be stored and processed</strong> in any country where we have facilities or in which we engage service providers. We will only transfer your Personal Data across international borders where (to the extent required by law) we have established a legal basis for such processing and put in place adequate measures to protect your Personal Data as may be required by local law. You should not use our Websites and Services if you do not want your Personal Data potentially transferred, or otherwise processed, in countries outside of your country of residence, which may have data protection laws that are different from those of your country. In certain circumstances, courts, law enforcement agencies, regulatory agencies, or security authorities in those other countries may be entitled to access your Personal Data.</p>

<p><strong>• If you are located in the European Economic Area</strong> ('EEA"), your Personal Data may be transferred to AIMENT and our affiliates, each a data controller, or to service providers in non-EEA countries that are not recognized by the European Commission as providing an adequate level of data protection according to EEA standards. For transfers from the EEA to countries not considered by the European Commission to have adequate protections, we implement measures to protect your Personal Data, such as standard contractual clauses adopted by the European Commission.</p>

<h2>CHANGES TO THIS NOTICE</h2>

<p>Our business, Websites and Services may change from time to time. As a result, we may change this Privacy Statement at any time. If we do make such changes, we will post an updated version on this page, unless another type of notice is required by the applicable law. Additionally, when required under applicable law, we will request additional consent to collect and process your Personal Data. We encourage you to visit this page periodically and to review our most current 1Privacy Statement and applicable effective date.</p>

<h2>CONTACT US</h2>

<p>If you have any questions about our Privacy Statement or data practices, want to receive this Privacy Statement in a different format, or want to exercise the data subject rights you have in connection with your Personal Data, you may contact us via email at overcookedapp@gmail.com.</p>

<p>BY CONTINUING THIS, YOU HEREBY ACKNOWLEDGE THAT YOU HAVE READ, UNDERSTOOD AND CONSENT TO THE PROCESSING (INCLUDING COLLECTION, STORING, DISCLOSURE, TRANSFER, SHARING) OF YOUR PERSONAL INFORMATION AND CONSULTATION INFORMATION FOR THE PURPOSES AND IN THE MANNER SET OUT UNDER THE PRIVACY POLICY.</p>
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