// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication/launch_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA2harizq0dPby6xTpORihdLuFoetjTy78",
        appId: "1:857891438018:android:e63570e7bd52f3e4e22a5b",
        messagingSenderId: "857891438018",
        projectId: "siswa-ride-ce388",
        databaseURL: "https://siswa-ride-ce388-default-rtdb.firebaseio.com",
        storageBucket: 'gs://siswa-ride-ce388.appspot.com',
      ),
    );
    runApp(const MyApp());
  } catch (e) {
    print('Firebase initialization error: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Siswa Ride',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 56, 82, 197),
        ),
        useMaterial3: true,
      ),
      home: LaunchScreen(),
    );
  }
}
