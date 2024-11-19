import 'package:flutter/material.dart';

class Faq2Page extends StatefulWidget {
  const Faq2Page({super.key});

  @override
  State<Faq2Page> createState() => _Faq2PageState();
}

class _Faq2PageState extends State<Faq2Page> {
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
                question: 'How do I sign up as a driver?',
                answer:
                    'To sign up as a driver, choose "Driver" and click on the "Register" button on our app. Fill out the registration form, submit the necessary documents, and our team will review your application and get back to you.',
              ),
              buildDivider(),
              buildFaqTile(
                question: 'What is the criteria for becoming a Siswa Ride driver-partner?',
                answer:
                    'To qualify, you need to fulfill the following criteria:\n\n'
                    '1. UKM student\n'
                    '2. Own a smartphone\n'
                    '3. Hold a valid driving license\n'
                    '4. Meet our car eligibility criteria',
              ),
              buildDivider(),
              buildFaqTile(
                question: 'How can I check my earnings?',
                answer:
                    'You can view your earnings through the driver app. Go to the "Earnings" section to see a breakdown of your daily and historical earnings.',
              ),
              buildDivider(),
              buildFaqTile(
                question: 'What should I do if I encounter a problem with Siswa Ride?',
                answer:
                    'If you experience any issues with the app, please contact our support team by emailing us at siswaride@ukm.com.',
              ),
              buildDivider(),
              buildFaqTile(
                question: 'How do I update my vehicle information?',
                answer:
                    'To update your vehicle information, go to the "Account" section and select "Edit Profile." Enter the new details and save the changes.',
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
