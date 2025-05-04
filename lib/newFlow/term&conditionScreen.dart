import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

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
                <h1>TERMS AND CONDITIONS</h1>
                
<p>Effective Date: 1st MAY 2025</p>
                
<p>Website Covered: www.overcooked.in</p>
                
<p>The Site is owned or controlled by AIMENT PRIVATE LIMITED, or its affiliates (collectively, "AIMENT," "we," "us," or "our"). For purposes of these Terms of Use, "affiliates" means any entity or person, directly or indirectly, owning a controlling interest in, owned by, or under common ownership control with, AIMENT. These Terms of Use constitute a legally binding agreement between you, the person using the Site ("you" or "your"), and AIMENT. If you are entering into these terms on behalf of an entity, you hereby represent and warrant that you have the requisite authority to bind such entity.</p>
                
<p>The use of this website and services by You, the User or the Client, of this website provided by AIMENT PRIVATE LIMITED (hereinafter referred to as "Owner") are subject to the following Terms & Conditions (hereinafter the "Terms of Service"), all parts and sub-parts of which are specifically incorporated by reference here together with the Privacy Policy.</p>
                
<p>Please read these Terms of Use carefully before using this Site. BY ACCESSING THIS SITE IN ANY WAY, YOU ACCEPT AND ARE BOUND BY THESE TERMS OF USE AND ALL APPLICABLE LAWS AND REGULATIONS. THESE TERMS OF USE CONTAIN DISCLAIMERS OF WARRANTIES AND LIABILITY, A MANDATORY INDIVIDUAL ARBITRATION PROVISION, AND A WAIVER. IF YOU DO NOT AGREE TO THESE TERMS OF USE, THEN YOU ARE NOT PERMITTED TO USE THIS SITE. THESE TERMS OF SERVICE APPLY TO ALL USERS OF THE SITE, INCLUDING WITHOUT LIMITATION VENDORS, BUYERS, CUSTOMERS, MERCHANTS, BROWSERS AND/ OR CONTRIBUTORS OF CONTENT.</p>
                
<p>Following are the Terms of Service governing your use of www.overcooked.in (the "Website"), all pages on the Website and any services provided by or on this Website ("Services").</p>
                
<h2>DEFINITION</h2>
                
<p>The parties referred to in these Terms of Service shall be defined as follows:</p>
                
<ul>
  <li>Owner, Us, We: The Owner, as the creator, operator, and publisher of the Website, makes the Website, and certain Services on it, available to users. Sharada Psychological Services India Private Limited, Owner, Us, We, Our, Ours and other first-person pronouns will refer to the Owner, as well as all employees and affiliates of the Owner.</li>
  <li>You, the User, the Client: You, as the user of the Website, will be referred to throughout these Terms of Service with second-person pronouns such as You, Your, Yours, or as User or Client. For the purpose of these Terms of Service, the term "User" or "you" shall mean any natural or legal person who person is accessing the Website. The term "Your" shall be construed accordingly.</li>
</ul>
                
<p>Parties: Collectively, the parties to these Terms of Service (the Owner and You) will be referred to as Parties.</p>
                
<h2>ASSENT AND ACCEPTANCE</h2>
                
<p>By using the Website, You warrant that You have read and reviewed these Terms of Service and that You agree to be bound by it. If You do not agree to be bound by these Terms of Service, please leave the Website immediately. The Owner only agrees to provide use of this Website and Services to You if You assent to these Terms of Service. Further, based on the Services obtained by a User, additional terms and conditions in respect of the specific Services may apply, which shall be deemed an agreement between the Users and the Owner.</p>
                
<h2>ABOUT THE SITE</h2>
                
<ul>
  <li>The Website is an online marketplace that enables users to browse, connect with, and book personalized mental health and psychological services through independent psychologists and healthcare professionals listed on the Website. We reserve the right to refuse service or refuse to sell the products on the Website at our sole discretion to anyone for any reason at any time.</li>
  <li>The Website does not screen or censor the users who register on and access the Website. You assume all risks associated with dealing with other users with whom you come in contact through the Website. You agree to use the Website only for lawful purposes without infringing the rights of or restricting the use of this Website by any third party.</li>
</ul>
                
<h2>ACCESSING THE SITE AND ACCOUNT SECURITY</h2>
                
<ul>
  <li>In order to access certain pages and features on our Website, you may be asked to register by creating a username and selecting a password. You agree that all information you provide to register with this Website or otherwise, including, but not limited to, through the use of any interactive features on the Website, is governed by our Privacy Statement, and you consent to all actions we take with respect to your information consistent with our Privacy Statement. It is a condition of your use of the Website that all the information you provide on the Website is correct, current, and complete. If you elect not to provide such information, you may not be able to access certain content or participate in certain features of the Site, or any features at all.</li>
  <li>You may not select or use as a username: (i) a name of another person with the intent to impersonate that person; or (ii) a name subject to any rights of a person other than you without appropriate authorization. You are responsible for safeguarding your username and password. If you believe that your password has been compromised, lost, or stolen, or that someone may attempt to use your account without your consent, promptly notify us.</li>
</ul>
                
<h2>LICENSE TO USE WEBSITE</h2>
                
<ul>
  <li>We do not permit individuals under 18 years of age to become registered users of the Website. By using the Website, you represent and warrant that: (i) you are at least 18 years of age; and (ii) you have the right, authority, and capacity to enter into and to abide by the terms and conditions of these Terms of Use.</li>
  <li>We may provide You with certain information as a result of Your use of the Website or Services. Such information may include but is not limited to, documentation, data, or information developed by Us, and other materials which may assist in Your use of the Website or Services ("Owner Materials"). Subject to these Terms of Service, the Owner grants You a non-exclusive, limited, non-transferable and revocable license to use the Owner Materials solely in connection with Your use of the Website and Services. The Owner Materials may not be used for any other purpose and this license terminates upon Your cessation of use of the Website or Services or at the termination of these Terms of Service.</li>
  <li>You agree not to collect contact information of other Users from the Website or download or copy any information by means of unsolicited access so as to communicate directly with them or for any reason whatsoever.</li>
  <li>Any unauthorized use by you shall terminate the permission or license granted to you by the Website and You agree that you shall not bypass any measures used by the Owner to prevent or restrict access to the Website.</li>
</ul>
                
<h2>HEALTH AND MEDICAL SERVICE DISCLAIMER</h2>
                
<ul>
  <li>Our Website may contain from time-to-time information related to various health, medical and fitness conditions and their treatment (collectively, the "Content"). This Content is not intended to be a substitute for the advice, treatment or recommendations of a health care professional. You should always consult a physician for diagnosing and treating a health or fitness problem, and before using any drug product discussed on this Website. We are not engaged in rendering medical advice or services. Your use of this Site does not create a doctor-patient relationship between you and AILMENT. In the event of a medical emergency, please call emergency services immediately.</li>
  <li>The Content is presented in summary form, is general in nature, and is provided for informational purposes only. The Content is not intended in any way to be a substitute for professional medical advice and should not be interpreted as treatment recommendations. Only a physician who has had an opportunity to interact with the patient in person, with access to the patient's records and the opportunity to conduct appropriate follow-up, can provide recommendations for treatment.</li>
</ul>
                
<h2>INTELLECTUAL PROPERTY</h2>
                
<p>You understand, acknowledge and agree that the Website and all Services provided by the Owner are the property of the Owner, including all copyrights, trademarks, trade secrets, patents, and other intellectual property ("Owner IP"). You agree that the Owner owns all rights, title, and interest in and to the Owner IP and that You will not use the Owner IP for any unlawful or infringing purpose. You agree not to reproduce or distribute the Owner IP in any way, including electronically or via registration of any new trademarks, trade names, service marks or Uniform Resource Locators (URLs), without express written permission from the Owner.</p>
                
<h2>PAYMENT & FEES</h2>
                
<ul>
  <li>Should You register for any of the paid Services on this website or purchase any product or service on this website, You agree to pay Us the specific monetary amounts required for that product or those Services. These monetary amounts ("Fees") will be described to You during Your account registration and/or confirmation process. The final amount required for payment will be shown to You immediately prior to purchase.</li>
  <li>The session fee will be communicated to you at the time of enquiry and is fixed and non-negotiable. We reserve the right to periodically revise the fee structure. Any changes will be notified to you via email. Payment must be made in advance at the time of booking. Appointments for which payment has not been received 48 hours in advance will be automatically cancelled. We reserve the right to cancel any appointment that has not been paid for in accordance with our policy.</li>
  <li>Each individual therapy session is scheduled for 60 minutes or such minutes as booked by You through the Website. If your session extends beyond this by more than 10 minutes, the additional time will be charged on a prorated basis, and the extra payment will be collected at the end of the session.</li>
</ul>
                
<h2>CANCELATION AND REFUND</h2>
                
<ul>
  <li>We have a 24-hour cancellation policy. To reschedule or cancel your appointment (rescheduling is treated as a cancellation), please notify us at least 24 hours before the scheduled session time, by way of email of telephone mentioned under these terms. If you fail to provide this notice or do not attend the session, you will be charged 100% of the session fee. No refunds will be issued in such cases. We understand that emergencies may arise, but please note that the cancellation fee applies regardless of the reason.</li>
  <li>Cancellations can be made with a 24-hour notice and a 100 % refund will be offered. Any cancellation or reschedule made without 24-hour notice will be counted as a used session and no refund will be offered. All refunds will be processed and credited to the customer's bank account within 5 – 7 bank working days.</li>
  <li>We make every effort to honour scheduled appointments. However, if a therapist is unwell or encounters an emergency, we will promptly inform you of the situation. In these instances, we will offer you the option to reschedule or provide a full refund, depending on your preference. We kindly ask for your understanding and flexibility in these unforeseen situations. If you arrive 30 minutes late for your session, the appointment will be automatically cancelled. This is because 30 minutes is insufficient for a productive therapeutic session, and the cancellation fee will apply.</li>
</ul>
                
<h2>ACCEPTABLE USE</h2>
                
<ul>
  <li>You agree not to use the Website or Services for any unlawful purpose or any purpose prohibited under this clause. You agree not to use the Website or Services in any way that could damage the Website, Services or general business of the Owner.</li>
  <li>You further agree not to use the Website or Services:
    <ul>
      <li>To harass, abuse, or threaten others or otherwise violate any person's legal rights;</li>
      <li>To violate any intellectual property rights of the Owner or any third party;</li>
      <li>To upload or otherwise disseminate any computer viruses or other software that may damage the property of another;</li>
      <li>To perpetrate any fraud;</li>
      <li>To engage in or create any unlawful gambling, sweepstakes, or pyramid scheme;</li>
      <li>To publish or distribute any obscene or defamatory material;</li>
      <li>To publish or distribute any material that incites violence, hate or discrimination towards any group;</li>
      <li>To unlawfully gather information about others.</li>
    </ul>
  </li>
  <li>You are prohibited from using the site or its content: 
    <ul>
      <li>for any unlawful purpose;</li>
      <li>to solicit others to perform or participate in any unlawful acts;</li>
      <li>to infringe on any third party's intellectual property or proprietary rights, or rights of publicity or privacy, whether knowingly or unknowingly;</li>
      <li>to violate any local, federal or international law, statute, ordinance or regulation;</li>
      <li>to harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate based on gender, sexual orientation, religion, ethnicity, race, age, national origin, or disability;</li>
      <li>to submit false or misleading information or any content which is defamatory, libellous, threatening, unlawful, harassing, indecent, abusive, obscene, or lewd and lascivious or pornographic, or exploits minors in any way or assists in human trafficking or content that would violate rights of publicity and/or privacy or that would violate any law;</li>
      <li>to upload or transmit viruses or any other type of malicious code that will or may be used in any way that will affect the functionality or operation of the Service or of any related website, other websites, or the Internet;</li>
      <li>to collect or track the personal information of others;</li>
      <li>to damage, disable, overburden, or impair the Website or any other party's use of the Website;</li>
      <li>to spam, phish, pharm, pretext, spider, crawl, or scrape;</li>
      <li>for any obscene or immoral purpose; or (k) to interfere with or circumvent the security features of the Service or any related website, other websites, or the Internet;</li>
      <li>to personally threaten or has the effect of personally threatening other Users.</li>
    </ul>
  </li>
</ul>

<h2>COMMUNICATION</h2>

<p>You understand that each time uses the Website in any manner, you agree to these Terms. By agreeing to these Terms, you acknowledge that you are interested in availing and purchasing the Services that you have selected and consent to receive communications via phone or electronic records from the Website including e-mail messages telling you about products and services offered by the Website (or its affiliates and partners) and understanding your requirements. Communication can also be by posting any notices on the Website. You agree that the communications sent to You by the Website shall not be construed as spam or bulk under any law prevailing in any country where such communication is received.</p>

<h2>PRIVACY INFORMATION</h2>

<ul>
  <li>We are committed to maintaining the confidentiality and privacy of all clients. All personal details, session content, and related information shared during therapy will be kept strictly confidential. However, there are specific exceptions to this confidentiality policy, which are necessary to ensure the safety of individuals and comply with legal obligations.</li>
  <li>Confidentiality will be breached, and your emergency contact or relevant authorities may be informed, without your consent, under the following circumstances:
    <ul>
      <li>Risk of Harm: If your therapist assesses that you are at high risk of suicide, self-harm, or pose a serious threat to your own or someone else's safety.</li>
      <li>Intent to Harm Others: If you disclose an active or malicious plan to harm another individual, directly or indirectly.</li>
      <li>Legal Requirement: If your case history, records, or therapist testimony is demanded by a court of law under legal compulsion.</li>
      <li>Mandatory Reporting: If you disclose incidents involving child sexual abuse, drug trafficking, or other activities that are legally reportable under Indian law.</li>
      <li>Client Consent: If you explicitly request your therapist to share information with another person, organization, or professional (e.g., a family member, psychiatrist, or institution), a signed consent or email confirmation will be required.</li>
    </ul>
  </li>
  <li>To ensure quality of care, your therapist may discuss your case with their supervisor or peer support group. In such cases, all personally identifying information will be removed or anonymized. For scheduling, billing, and operational reasons, certain members of AIMENT's administrative staff may have access to your personal information. These individuals are also bound by strict confidentiality agreements and protocols. All client records and data are stored securely in encrypted digital systems or locked physical storage (if applicable). Only authorized personnel have access to this information. If therapy sessions are conducted online, please note that we use secure, encrypted platforms to ensure confidentiality. However, clients are advised to also take precautions at their end, such as using private networks and avoiding public/shared devices. Your emergency contact details will only be used in urgent situations, as outlined above. Please ensure this information is accurate and kept up to date.</li>
  <li>Through Your Use of the Website and Services, You may provide Us with certain information. By using the Website or the Services, You authorize the Owner to use Your information in India and any other country where We may operate.</li>
  <li>Depending on how You use Our Website or Services, We may receive information from external applications You use to access Our Website, or We may receive information through various web technologies, such as cookies, log files, clear gifs, web beacons or others.</li>
  <li>We use the information gathered from You to ensure Your continued good experience on Our website. We may also track certain of the passive information received to improve Our marketing and analytics, and for this, We may work with third-party providers, including other marketers.</li>
  <li>If You would like to disable Our access to any passive information We receive from the use of various technologies, You may choose to disable cookies in Your web browser.</li>
</ul>

<h2>ASSUMPTION OF RISK</h2>

<p>The Website and Services are provided for communication purposes only. You acknowledge and agree that any information posted on Our Website is not intended to be legal advice, medical advice, or financial advice, and no fiduciary relationship has been created between You and the Owner. You further agree that Your purchase of any of the products on the Website is at Your own risk. The Owner does not assume responsibility or liability for any advice or other information given on the Website.</p>

<h2>SALE OF GOODS/SERVICES</h2>

<ul>
  <li>We may sell goods or services or allow third parties to sell goods or services on the Website. We undertake to be as accurate as possible with all information regarding the goods and services, including product descriptions and images. However, the Owner does not guarantee the accuracy or reliability of any product information and You acknowledge and agree that You purchase such products at Your own risk.</li>
  <li>We will make reimbursements for returns without undue delay, and not later than:
    <ul>
      <li>30 days after the day we received back from you any goods supplied; or</li>
      <li>(If earlier) 30 days after the day you provide evidence that you have returned the goods; or;</li>
      <li>If there were no goods supplied, 30 days after the day on which we are informed about your decision to cancel this contract.</li>
    </ul>
  </li>
  <li>We will make the reimbursement using the same means of payment as you used for the initial transaction unless you have expressly agreed otherwise; in any event, you will not incur any fees as a result of the reimbursement.</li>
</ul>

<h2>REVERSE ENGINEERING & SECURITY</h2>

<p>You agree not to undertake any of the following actions Reverse engineer, or attempt to reverse engineer or disassemble any code or software from or on the Website or Services. Violate the security of the Website or Services through any unauthorized access, circumvention of encryption or other security tools, data mining or interference to any host, user or network.</p>

<h2>INDEMNIFICATION</h2>

<p>You agree to defend and indemnify the Owner and any of its affiliates (if applicable) and hold Us harmless against any and all legal claims and demands, including reasonable attorney's fees, which may arise from or relate to Your use or misuse of the Website or Services, Your breach of these Terms of Service, or Your conduct or actions. You agree that the Owner shall be able to select its own legal counsel and may participate in its own defence if the Owner wishes.</p>

<h2>THIRD-PARTY LINKS & CONTENT</h2>

<p>The Owner may occasionally post links to third-party websites or other services. You agree that the Owner is not responsible or liable for any loss or damage caused as a result of Your use of any third-party services linked to from Our Website.</p>

<h2>MODIFICATION & VARIATION</h2>

<ul>
  <li>The Owner may, from time to time and at any time without notice to You, modify these Terms of Service. You agree that the Owner has the right to modify these Terms of Service or revise anything contained herein. You further agree that all modifications to these Terms of Service are in full force and effect immediately upon posting on the Website and that modifications or variations will replace any prior version of these Terms of Service unless prior versions are specifically referred to or incorporated into the latest modification or variation of these Terms of Service.</li>
  <li>To the extent any part or sub-part of these Terms of Service is held ineffective or invalid by any court of law, You agree that the prior, effective version of these Terms of Service shall be considered enforceable and valid to the fullest extent.</li>
  <li>You agree to routinely monitor these Terms of Service and refer to the Effective Date posted at the top of these Terms of Service to note modifications or variations. You further agree to clear Your cache when doing so to avoid accessing a prior version of these Terms of Service. You agree that Your continued use of the Website after any modifications to these Terms of Service is a manifestation of Your continued assent to these Terms of Service.</li>
  <li>In the event that You fail to monitor any modifications to or variations of these Terms of Service, You agree that such failure shall be considered an affirmative waiver of Your right to review the modified Agreement.</li>
</ul>

<h2>ENTIRE AGREEMENT</h2>

<p>This Agreement constitutes the entire understanding between the Parties with respect to any and all use of this Website. This Agreement supersedes and replaces all prior or contemporaneous agreements or understandings, written or oral, regarding the use of this Website.</p>

<h2>SERVICE INTERRUPTIONS</h2>

<p>The Owner may need to interrupt Your access to the Website to perform maintenance or emergency services on a scheduled or unscheduled basis. You agree that Your access to the Website may be affected by unanticipated or unscheduled downtime, for any reason, but that the Owner shall have no liability for any damage or loss caused as a result of such downtime.</p>

<h2>TERM, TERMINATION & SUSPENSION</h2>

<p>The Owner may terminate these Terms of Service with You at any time for any reason, with or without cause. The Owner specifically reserves the right to terminate these Terms of Service if You violate any of the terms outlined herein, including, but not limited to, violating the intellectual property rights of the Owner or a third party, failing to comply with applicable laws or other legal obligations, and/or publishing or distributing illegal material. If You have registered for an account with Us, You may also terminate these Terms of Service at any time by contacting Us and requesting termination. Please keep in mind that any outstanding fees will still be due even after termination of Your account. At the termination of these Terms of Service, any provisions that would be expected to survive termination by their nature shall remain in full force and effect.</p>

<h2>NO WARRANTIES</h2>

<p>You agree that Your use of the Website and Services is at Your sole and exclusive risk and that any Services provided by Us are on an "As Is" basis. The Owner hereby expressly disclaims any and all express or implied warranties of any kind, including, but not limited to the implied warranty of fitness for a particular purpose and the implied warranty of merchantability. The Owner makes no warranties that the Website or Services will meet Your needs or that the Website or Services will be uninterrupted, error-free, or secure. The Owner also makes no warranties as to the reliability or accuracy of any information on the Website or obtained through the Services. You agree that any damage that may occur to You, through Your computer system, or as a result of the loss of Your data from Your use of the Website or Services is Your sole responsibility and that the Owner is not liable for any such damage or loss.</p>

<h2>LIMITATION ON LIABILITY</h2>

<p>The Owner is not liable for any damage that may occur to You as a result of Your use of the Website or Services, to the fullest extent permitted by law. The maximum liability of the Owner arising from or relating to these Terms of Service is limited to the lesser of Rs. 1000 (Rupees One Thousand only) or the amount You paid to the Owner in the last three (3) Services. This section applies to any and all claims by You, including, but not limited to, lost profits or revenues, consequential or punitive damages, negligence, strict liability, fraud, or torts of any kind.</p>

<h2>GENERAL PROVISIONS</h2>

<ul>
  <li>All communications made or notices given pursuant to these Terms of Service shall be in the English language.</li>
  <li>Through Your use of the Website or Services, You agree that the laws of India shall govern any matter or dispute relating to or arising out of these Terms of Service, as well as any dispute of any kind that may arise between You and the Owner, with the exception of its conflict of law provisions. In case any litigation specifically permitted under these Terms of Service is initiated, the Parties agree to submit to the exclusive jurisdiction of the courts at New Delhi, India. The Parties agree that this choice of law, venue, and jurisdiction provision is not permissive, but rather mandatory in nature. You hereby waive the right to any objection of venue, including assertion of the doctrine of forum non-convenience or similar doctrine.</li>
  <li>You agree that whenever you have a disagreement with us arising out of, connected to, or in any way related to these Terms of Use, you will send a written notice to us (a "Demand"). You agree that the requirements of this section will apply even to disagreements that may have arisen before you accepted these Terms of Use. You must send this Demand to the following address (the "Notice Address"):
    <p>ATTENTION TO:<br>
    ADDRESS:<br>
    CC TO:</p>
    
    <p>You agree that you will not take any legal action, including filing a lawsuit or demanding arbitration, until ten (10) business days after you send this Demand. If we do not resolve this disagreement to your satisfaction within ten (10) business days, and you intend on taking legal action, you agree that you will file a demand for arbitration with the Arbitration Association (the "Arbitrator") in New Delhi. Review this section carefully. This arbitration provision limits your and AIMENT's ability to litigate claims in court and you and AIMENT each agree to waive your respective rights to a civil/ criminal litigation. You agree that you will not file any lawsuit against us in any court. You agree that if you do sue us in court, and we bring a successful petition to compel arbitration, you must pay all fees and costs incurred by us in court, including reasonable attorney's fees.</p>
  </li>
  <li>This Agreement, or the rights granted hereunder, may not be assigned, sold, leased or otherwise transferred in whole or part by You. Should these Terms of Service, or the rights granted hereunder, by assigned, sold, leased or otherwise transferred by the Owner, the rights and liabilities of the Owner will bind and inure to any assignees, administrators, successors and executors.</li>
  <li>If any part or sub-part of these Terms of Service is held invalid or unenforceable by a court of law or competent arbitrator, the remaining parts and sub-parts will be enforced to the maximum extent possible. In such condition, the remainder of these Terms of Service shall continue in full force.</li>
  <li>In the event that We fail to enforce any provision of these Terms of Service, this shall not constitute a waiver of any future enforcement of that provision or of any other provision. Waiver of any part or sub-part of these Terms of Service will not constitute a waiver of any other part or sub-part.</li>
  <li>Headings of parts and sub-parts under these Terms of Service are for convenience and organization, only. Headings shall not affect the meaning of any provisions of these Terms of Service.</li>
  <li>No agency, partnership, or joint venture has been created between the Parties as a result of these Terms of Service. No Party has any authority to bind the other to third parties.</li>
  <li>The Owner is not liable for any failure to perform due to causes beyond its reasonable control including, but not limited to, acts of God, acts of civil authorities, acts of military authorities, riots, embargoes, acts of nature and natural disasters, and other acts which may be due to unforeseen circumstances.</li>
  <li>Electronic Communications Permitted: Electronic communications are permitted to both Parties under these Terms of Service, including e-mail or fax. For any questions or concerns, please email Us at the following address: overcookedapp@gmail.com</li>
</ul>
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