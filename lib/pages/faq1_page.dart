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
                  'How do I create an account?',
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'To sign up as a customer, choose for customer and click on the "Register" button on our app, fill out the registration form, and submit the necessary documents. Our team will review your application and get back to you.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white),
              ExpansionTile(
                title: Text(
                  'How do I book a ride?',
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'To book a ride, open the book ride page, choose your pickup and drop-off locations and others details then confirm your booking. You’ll receive details about your driver.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white),
              ExpansionTile(
                title: Text(
                  'What should I do if I need to cancel my ride?',
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'To cancel a ride, go to the "Current Trip" section in the app and select "Cancel Ride." Be aware of any cancellation fees that may apply.',
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
                  'How do I view my ride history?',
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'You can view your ride history by going to the "Activity" section in the app. Here you’ll find details about your past trips, including dates, location, and costs.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white),
              ExpansionTile(
                title: Text(
                  'Can I rate and leave feedback about my ride?',
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'You can add feedback for your ride history by going to the "Activity" section in the app. You can also report a scammer in the "Scammer List" section.',
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
