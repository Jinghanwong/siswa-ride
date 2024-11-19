import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:siswa_ride/authentication/login_screen.dart';
import 'package:siswa_ride/pages/edit_profile2.dart';
import 'package:siswa_ride/pages/faq2_page.dart';

class AccountPage2 extends StatefulWidget {
  const AccountPage2({Key? key}) : super(key: key);

  @override
  State<AccountPage2> createState() => _AccountPage2State();
}

class _AccountPage2State extends State<AccountPage2> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final FirebaseStorage storage = FirebaseStorage.instance;

  String? _userName;
  String? _userEmail;
  String? _driverPhotoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        DatabaseEvent event = await dbRef.child('users/$uid').once();
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists && snapshot.value != null) {
          Map<dynamic, dynamic> rawData =
              snapshot.value as Map<dynamic, dynamic>;
          Map<String, dynamic> userData = Map<String, dynamic>.from(rawData);

          setState(() {
            _userName = userData['name'] ?? 'Your Name';
            _userEmail = userData['email'] ?? 'your.email@example.com';
            _driverPhotoUrl = userData['driverPhotoUrl']?.toString();
          });

          print('Driver Photo URL: $_driverPhotoUrl'); // Debug print
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2962FF), Color(0xFF64B5F6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Log Out",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Are you sure you want to log out?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "No",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _signOut();
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            "Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2962FF), Color(0xFF64B5F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: kToolbarHeight + 40),
            CircleAvatar(
              radius: 50,
              backgroundImage: _driverPhotoUrl != null
                  ? NetworkImage(_driverPhotoUrl!)
                  : const AssetImage('assets/profile_placeholder.png')
                      as ImageProvider,
            ),
            const SizedBox(height: 10),
            Text(
              _userName ?? "Your Name",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              _userEmail ?? "your.email@example.com",
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.blueAccent),
                      title: const Text("Edit Profile"),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Colors.blueAccent),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfile2Page()),
                        ).then((_) =>
                            _loadUserData()); // Reload data when returning from EditProfile
                      },
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading:
                          Icon(Icons.help_outline, color: Colors.blueAccent),
                      title: const Text("FAQ"),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Colors.blueAccent),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Faq2Page()),
                        );
                      },
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.redAccent),
                      title: const Text("Log Out"),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Colors.redAccent),
                      onTap: _showSignOutDialog,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

