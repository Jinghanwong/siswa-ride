import 'package:flutter/material.dart';

class Faq1Page extends StatefulWidget {
  const Faq1Page({super.key});

  @override
  State<Faq1Page> createState() => _Faq1PageState();
}

class _Faq1PageState extends State<Faq1Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAQ',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 48, 98, 207),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2962FF), Color(0xFF64B5F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 10),
              buildFaqTile(
                question: 'How do I create an account?',
                answer:
                    'To sign up as a customer, choose customer, click on the "Register" button, fill out the registration form, and submit the necessary documents. Our team will review your application and get back to you.',
              ),
              buildDivider(),
              buildFaqTile(
                question: 'How do I book a ride?',
                answer:
                    'To book a ride, open the book ride page, choose your pickup and drop-off locations and other details, then confirm your booking. You’ll receive details about your driver.',
              ),
              buildDivider(),
              buildFaqTile(
                question: 'What should I do if I need to cancel my ride?',
                answer:
                    'To cancel a ride, go to the "Current Trip" section in the app and select "Cancel Ride." Be aware of any cancellation fees that may apply.',
              ),
              buildDivider(),
              buildFaqTile(
                question: 'What should I do if I encounter a problem with Siswa Ride?',
                answer:
                    'If you experience any issues with the app, please contact our support team by emailing us at siswaride@ukm.com.',
              ),
              buildDivider(),
              buildFaqTile(
                question: 'How do I view my ride history?',
                answer:
                    'You can view your ride history by going to the "Activity" section in the app. Here you’ll find details about your past trips, including dates, locations, and costs.',
              ),
              buildDivider(),
              buildFaqTile(
                question: 'Can I rate and leave feedback about my ride?',
                answer:
                    'You can add feedback for your ride history by going to the "Activity" section. You can also report a scammer in the "Scammer List" section.',
              ),
              buildDivider(),
              buildFaqTile(
                question: 'What is Phishing?',
                answer:
                    'Phishing is a type of cyberattack where scammers pretend to be legitimate services (like Siswa Ride) to steal your personal information via fake emails or messages.',
              ),
              buildDivider(),
              buildFaqTile(
                question: 'How to Spot a Scammer',
                answer:
                    'Signs of a scam:\n\n'
                    '1. Poor spelling or grammar\n'
                    '2. Urgent threats or promises of rewards\n'
                    '3. Mismatched or misleading domains\n'
                    '4. Unexpected attachments or links',
              ),
              buildDivider(),
              buildFaqTile(
                question: 'How to Protect Yourself',
                answer:
                    'Signs of a scam:\n\n'
                    '1. Verify sender details\n'
                    '2. Use a secure PIN\n'
                    '3. Never share OTPs\n'
                    '4. Regularly monitor your accounts',
              ),
              buildDivider(),
              buildFaqTile(
                question: 'If You Have Been Compromised',
                answer:
                    'If you have shared sensitive information or noticed irregular activities, contact your bank to block your card, reset your Siswa Ride credentials, and file a report.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFaqTile({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(
            Icons.question_answer,
            color: Colors.white.withOpacity(0.8),
          ),
          title: Text(
            question,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          iconColor: Colors.white,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Divider buildDivider() {
    return Divider(
      color: Colors.white.withOpacity(0.3),
      thickness: 1,
      height: 20,
      indent: 20,
      endIndent: 20,
    );
  }
}

