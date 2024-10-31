import 'package:flutter/material.dart';

class ScammerListPage extends StatefulWidget {
  const ScammerListPage({super.key});

  @override
  State<ScammerListPage> createState() => _ScammerListPageState();
}

class _ScammerListPageState extends State<ScammerListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF82B1FF), Color(0xFF2962FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 40),
              const Text(
                "Scammer List",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Protect yourself from scams\n\n"
                "In this digital age, scammers and fraudsters are getting smarter "
                "and are finding new ways to get your money and personal details "
                "all the time. While Siswa Ride has implemented several layers of "
                "security to keep you safe, we believe the best defence is "
                "awareness and knowing what to look out for.\n\n"
                "Read on to find out more.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Add Scammer'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('View List'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.white),
              const ExpansionTile(
                title: Text(
                  "What is Phishing?",
                  style: TextStyle(color: Colors.white),
                ),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Phishing is a popular form of cyberattack that attempts to gain access to your personal "
                      "information, bank account details, passwords, and so on. It usually involves a cybercriminal "
                      "pretending to be Grab via email or instant messaging services, who will request you to share "
                      "your personal information via a link provided in these communications. Once cybercriminals get "
                      "access to your information, they can easily access your account and funds.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white),
              const ExpansionTile(
                title: Text(
                  "How to spot a scammer",
                  style: TextStyle(color: Colors.white),
                ),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Here are some tell-tale signs that your message or email might be a scam:\n\n"
                      "1. Check for bad spelling or grammar.\n"
                      "2. Urgent call to action or threats.\n"
                      "3. Promise of attractive rewards.\n"
                      "4. Mismatched and misleading domains.\n"
                      "5. Suspicious link or unexpected attachments.\n"
                      "6. Unexpected or unfamiliar senders.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white),
              const ExpansionTile(
                title: Text(
                  "How to protect yourself from phishing scams",
                  style: TextStyle(color: Colors.white),
                ),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "To protect yourself from phishing scams, here's what you can do:\n\n"
                      "1. Check the sender's details to confirm that the notification is actually from Siswa Ride.\n"
                      "2. Set up your SiswaRidePIN.\n"
                      "3. Don't share your OTP.\n"
                      "4. Review your accounts regularly.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white),
              const ExpansionTile(
                title: Text(
                  "If your account or information has been compromised",
                  style: TextStyle(color: Colors.white),
                ),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "If you've entered your credit/debit card information, please block your card immediately by "
                      "contacting your bank and lodge a police report for further investigation.\n\n"
                      "If you've shared your Siswa Ride app login credentials or have noticed any irregular activities/"
                      "charges on your Siswa Ride account, please reset your SiswaRidePIN and submit a report to us.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ScammerListPage(),
  ));
}
