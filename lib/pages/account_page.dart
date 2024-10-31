import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:siswa_ride/authentication/login_screen.dart';
import 'package:siswa_ride/pages/edit_profile.dart';
import 'package:siswa_ride/pages/faq1_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // 清理 Navigator 堆栈并导航到登录页面
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error signing out: $e");
      // Handle sign out error
    }
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: const Text(
                "Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(color: Colors.white),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text("Edit Profile",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),
            const Divider(color: Colors.white),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.white),
              title: const Text("FAQ", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Faq1Page()),
                );
              },
            ),
            const Divider(color: Colors.white),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title:
                  const Text("Log Out", style: TextStyle(color: Colors.white)),
              onTap: () {
                _signOut(); // Call sign out function
              },
            ),
          ],
        ),
      ),
    );
  }
}