import 'package:flutter/material.dart';
import 'package:siswa_ride/pages/account_page2.dart';
import 'package:siswa_ride/pages/earning_page.dart';
import 'package:siswa_ride/pages/choosebooking.dart';

class Dashboard2 extends StatefulWidget {
  final String userName; // Declare userName as a property

  const Dashboard2({super.key, required this.userName});

  @override
  State<Dashboard2> createState() => _Dashboard2State();
}

class _Dashboard2State extends State<Dashboard2>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  int indexSelected = 0;

  onBarItemClicked(int i) {
    setState(() {
      indexSelected = i;
      controller!.index = indexSelected;
    });
  }

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          ChooseBookingPage(),
          EarningPage(),
          AccountPage2(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.car_rental), label: "Choose Booking"),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: "Earning"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: "Account"),
        ],
        currentIndex: indexSelected,
        //backgroundColor: Colors.grey,
        unselectedItemColor: Colors.black,
        selectedItemColor: const Color.fromARGB(255, 48, 98, 207),
        showSelectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        onTap: onBarItemClicked,
      ),
    );
  }
}
