import 'package:flutter/material.dart';
import 'package:siswa_ride/pages/account_page.dart';
import 'package:siswa_ride/pages/activity_page.dart';
import 'package:siswa_ride/pages/mainpage.dart';
import 'package:siswa_ride/pages/scammerlist_page.dart'; // Adjust import path as per your project

class Dashboard extends StatefulWidget {
  final String userName; // Declare userName as a property

  const Dashboard({super.key, required this.userName});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int indexSelected = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          MainPage(userName: widget.userName), // Pass userName to MainPage
          ActivityPage(),
          ScammerListPage(),
          AccountPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.car_rental), label: "Ride Booking"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Activity"),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined), label: "ScammerList"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: "Account"),
        ],
        currentIndex: indexSelected,
        unselectedItemColor: Colors.black,
        selectedItemColor: const Color.fromARGB(255, 48, 98, 207),
        showSelectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        onTap: onBarItemClicked,
      ),
    );
  }

  void onBarItemClicked(int index) {
    setState(() {
      indexSelected = index;
      controller.index = indexSelected;
    });
  }
}
