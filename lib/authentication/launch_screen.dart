import 'package:flutter/material.dart';
import 'package:siswa_ride/authentication/login_screen.dart';

// ignore: use_key_in_widget_constructors
class LaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // 设置背景为白色
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.jpg',
                width: 200, // 调整图片宽度
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/launchscreen.jpg',
                width: 300, // 调整图片宽度
              ),
              const SizedBox(height: 20),
              const Text(
                'Enjoy your hassle-free journey.',
                style: TextStyle(
                  color: Colors.black, // 调整文本颜色
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 48, 98, 207), // 按钮背景颜色
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
