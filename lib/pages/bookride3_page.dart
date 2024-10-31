import 'package:flutter/material.dart';

class Bookride3Page extends StatefulWidget {
  const Bookride3Page({super.key});

  @override
  State<Bookride3Page> createState() => _Bookride3PageState();
}

class _Bookride3PageState extends State<Bookride3Page> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Connecting to your driver",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}