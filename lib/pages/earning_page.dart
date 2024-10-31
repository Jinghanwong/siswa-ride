import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EarningPage extends StatefulWidget {
  const EarningPage({super.key});

  @override
  State<EarningPage> createState() => _EarningPageState();
}

class _EarningPageState extends State<EarningPage> {
  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEE, d MMM yy');
    return formatter.format(now);
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
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      getCurrentDate(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "RM 53.00",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFF2962FF),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                      ),
                      child: const Text(
                        "WITHDRAW",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "History",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: const [
                          ListTile(
                            leading: Icon(Icons.arrow_upward),
                            title: Text("Ahmad Nasrul"),
                            subtitle: Text("Seksyen 16 • 20/5/24"),
                            trailing: Text(
                              "+RM10.00",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.arrow_upward),
                            title: Text("Arif Hamid"),
                            subtitle: Text("Taman Permai • 20/5/24"),
                            trailing: Text(
                              "+RM15.00",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
