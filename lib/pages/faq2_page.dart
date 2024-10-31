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
        title: const Text('FAQ'),
        backgroundColor: const Color.fromARGB(255, 48, 98, 207),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF82B1FF), Color(0xFF2962FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: const [
              ExpansionTile(
                title: Text(
                  'How do I sign up as a driver?',
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'To sign up as a driver, chhoose for driver and click on the "Register" button on our app, fill out the registration form, and submit the necessary documents. Our team will review your application and get back to you.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white),
              ExpansionTile(
                title: Text(
                  'What is the criteria for becoming a Siswa Ride driver-partner?',
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'To qualify you need to fulfill the following criteria:\n\n'
                      '1. UKM’s student\n'
                      '2. Must have a smartphone\n'
                      '3. Must have a driving license\n'
                      '4. Fulfill our car eligibility criteria\n',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white),
              ExpansionTile(
                title: Text(
                  'How can I check my earnings?',
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'You can view your earnings through the driver app. Go to the "Earnings" section to see a breakdown of your daily and history earnings.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white),
              ExpansionTile(
                title: Text(
                  'What should I do if I encounter a problem with Siswa Ride?',
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'If you experience any issues with the app, please contact our support team through email us at siswaride@ukm.com.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white),
              ExpansionTile(
                title: Text(
                  'How do I update my vehicle information?',
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'To update your vehicle information, go to the "Account" section and select "Edit Profile." Enter the new details and update the changes.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
