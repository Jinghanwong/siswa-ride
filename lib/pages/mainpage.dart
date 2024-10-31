import 'package:flutter/material.dart';
import 'package:siswa_ride/pages/bookride_page.dart';
import 'package:siswa_ride/pages/viewroute_page.dart';

class MainPage extends StatelessWidget {
  final String userName;

  const MainPage({super.key, required this.userName});

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
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to Siswa Ride",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  userName.isNotEmpty ? "Hello, $userName!" : "Hello!",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/images/homepage1.png', // replace with your image path
                    height: 200,
                  ),
                ),
                const SizedBox(height: 40),
                ListTile(
                  leading:
                      const Icon(Icons.directions_car, color: Colors.white),
                  title: const Text(
                    "Book Ride",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookridePage()),
                    );
                  },
                  tileColor:
                      const Color.fromARGB(255, 48, 98, 207), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                const Divider(), // Divider
                ListTile(
                  leading: const Icon(Icons.map, color: Colors.white),
                  title: const Text(
                    "View Route",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewRoutePage()),
                    );
                  },
                  tileColor:
                      const Color.fromARGB(255, 48, 98, 207), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
