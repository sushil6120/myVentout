import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:overcooked/Utils/components.dart';
import 'package:overcooked/newFlow/login/assessmentScreen.dart';

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
  bool _consentAccepted = false;
  
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
        title: Text(
          "Informed Consent",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              HtmlWidget(
                '''
                <h2>Informed Consent Form for Individual Therapy</h2>
                <p>
                This informed consent form is designed to provide you with important information about the therapy process and ensure that you fully understand your rights and responsibilities as a client. Please read this form carefully and let us know if you have any questions or concerns before proceeding with therapy.
                </p>
                
                <h3>About Therapy</h3>
                <p>
                Psychotherapy is a collaborative process between you and your therapist aimed at addressing psychological concerns, promoting personal growth, and improving overall well-being. The therapy sessions will involve discussing and exploring various aspects of your life, emotions, thoughts, and behaviours to help you gain insight, develop coping strategies, and work towards your therapeutic goals.
                </p>
                
                <h3>Risks of Therapy & Waiver</h3>
                <p>
                While therapy offers significant benefits, it is important to understand the potential risks associated with the process before beginning your journey. Therapy may involve emotional discomfort, as discussing difficult emotions, memories, or experiences can lead to temporary feelings of sadness, anger, anxiety, or other distressing emotions. In some cases, therapy can intensify existing psychological symptoms or bring up new ones, such as increased anxiety, depression, or intrusive thoughts. Engaging in therapy might also lead to unforeseen personal discoveries or realizations that can be unsettling or disruptive to one's worldview or self-identity. Additionally, personal growth achieved through therapy may impact existing relationships with family, friends, or romantic partners, potentially creating new conflicts or challenges. Emotional dependence on the therapist can develop, making the termination of therapy difficult and possibly requiring additional support. It is important to recognize that therapy does not always produce immediate results; progress may be gradual, nonlinear, and some issues may remain unresolved, requiring ongoing or additional treatment and the development of coping strategies rather than complete resolution.
                </p>
                
                <h3>Consent, Responsibility & Waiver</h3>
                <p>
                By choosing to work with AIMENT, you agree that you have been briefed in detail about the risks and benefits of therapy and are signing up for this service with full information and understanding. In an unfortunate situation, if you choose to take your own life, you agree that you or your family/friends will not hold AIMENT or its employees liable. You also agree to take full responsibility for the therapy outcome and for the outcome of any action undertaken by you—whether with or without therapist recommendation—that could potentially be risky or harmful by any means. By registering for our service, you confirm that you have read and understood this full document. You further agree to comply with all the terms and conditions mentioned above, including the cancellation and confidentiality clauses, and provide full consent for us to contact your emergency contacts if needed. You also confirm that the contact details of the emergency contact shared are accurate to the best of your knowledge.
                </p>
                
                <h3>Client's Obligations</h3>
                <p>
                Clients are expected to attend sessions sober and not under the influence of any substance. If a therapist suspects that a client is intoxicated, the session will be immediately terminated, and the full session fee will still be applicable. For the safety of all parties, therapists reserve the right to terminate a session if they feel unsafe at any point. Regarding our social media policy, clients are encouraged to follow AIMENT's professional pages on Facebook, Pinterest, and Instagram for mental health content and updates about our work. However, to maintain professional boundaries and preserve the objectivity crucial to effective therapy, clients and therapists are discouraged from following each other's personal social media accounts or engaging in personal relationships outside the therapeutic context.
                </p>
                
                <h3>Letter of Recommendation & Record Keeping</h3>
                <p>
                Your therapist will maintain session notes to track your discussions and therapeutic progress. These notes are private and accessible only to your therapist and their supervisors alone. They are considered confidential clinical records and will not be released to you under any circumstances. Regarding letters of recommendation (LOR), AIMENT does not issue LORs unless you are a regular client who has completed at least ten sessions, and only if the therapist deems it necessary for your wellbeing. Issuance of an LOR is entirely at the therapist's discretion, and they reserve the right to refuse such a request if it does not align with their professional judgment. Additionally, AIMENT does not provide client testimonials in court proceedings nor engage with any legal teams regarding discussions held during therapy.
                </p>
                
                <h3>Termination of Sessions, Complaints & Transfer of Case</h3>
                <p>
                While it is recommended that you participate in all planned sessions for optimal benefit, you have the flexibility to discontinue, pause, or terminate therapy at any time. You are welcome to restart therapy after a break, whether for the same concern or a different issue, and you may also request a change of therapist if you feel the current therapeutic fit is not ideal. We encourage feedback and will periodically request it to help us maintain the quality of our services. If you have any complaints regarding your therapist or any staff member of AIMENT, please email us. In the event that your therapist resigns from AIMENT, you will be informed in advance and given the option to either terminate your sessions or transfer to another therapist. Any advance payments made will be duly carried forward.
                </p>
                
                <h3>Contact Between Sessions</h3>
                <p>
                To encourage healthy boundaries and minimize dependency on therapy, clients are discouraged from contacting their therapist between sessions. However, we understand that emergencies may arise. In such cases, please contact our office, and we will arrange a 10-minute call with your therapist depending on their availability. Our office is accessible for calls and messages between 10 AM and 7 PM. In the event of a psychological or psychiatric emergency outside of office hours, please contact an emergency helpline or visit the nearest hospital, as AIMENT is not equipped to provide crisis support.
                </p>
                
                <h3>Terms of Counselling</h3>
                <ul>
                <li>Depending on the type of professional you have chosen, your experience of therapy will differ. Clinical Psychologists are more focused on diagnosis & symptom management. They adopt a directive, goal-oriented approach to therapy. A Counselling Psychologist is more wellness and strength focused, they are gentle and non-directive, giving client adequate space for reflection and deep introspective work. Our recommendation is for you to consult a counselling psychologist for therapy UNLESS you are looking for a formal assessment for a mental health condition or have been advised by a doctor to meet a clinical psychologist.</li>
                <br>
                <li>We are not a medical establishment and your therapist is not a medical doctor. Therefore, no medication/medical advice will be provided.</li>
                <br>
                <li>We offer assessment services for certain mental health concerns. These assessments will have to be purchased as a separate service and will not be included as a part of the regular therapy session.</li>
                <br>
                <li>Your therapist is dedicated to providing you with the best possible care. In some instances, they may determine that your specific needs require support or expertise beyond their scope of practice. If it is determined that additional expertise is beneficial for your therapeutic journey, your therapist may refer you to another professional. This referral could involve either consulting with the other professional alongside your current therapist or consulting with them after terminating your current therapy.</li>
                <br>
                <li>Therapy is a collaborative partnership between you and your therapist. While your therapist serves as a facilitator and guide, the ultimate responsibility for change and growth lies with you. Your active participation is essential for achieving positive outcomes.</li>
                <br>
                <li>Our therapists are dedicated to working with you in a sustainable manner. They will not offer simplistic or instant solutions to your problems. It is important to have realistic expectations about therapy. If you are seeking immediate, quick guidance or a ready-made solution without investing time and effort into the process, our platform may not align with your expectations. Therapy requires a genuine commitment to self-exploration and growth.</li>
                <br>
                <li>It is normal for disagreements or misunderstandings to arise during therapy. If there is something your therapist said that you disagree with or find challenging, we encourage you to express your thoughts and concerns. Your feedback allows for a deeper understanding and growth within the therapeutic relationship.</li>
                <br>
                <li>Therapy has proven benefits but we cannot give 100% guarantee as success depends on factors outside the therapist's control.</li>
                </ul>
                
                <h3>Declaration</h3>
                <p>
                I, confirm that I have read and understand this document. I acknowledge the potential risks of therapy and agree to the terms outlined above. I provide my consent to proceed with therapy under these conditions.
                </p>
                ''',
                textStyle: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              SizedBox(height: 20),
          
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
          child: customButton(
            () {
           
                Get.to(AssessmentScreen(), transition: Transition.rightToLeft);
            
            },
            width * 0.9,
            height * 0.057,
            'I Agree',
            false,
          ),
        ),
      ),
    );
  }
}