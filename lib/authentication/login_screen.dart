import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:siswa_ride/authentication/register_screen.dart';
import 'package:siswa_ride/global/global_var.dart';
import 'package:siswa_ride/methods/common_methods.dart';
import 'package:siswa_ride/pages/dashboard.dart';
import 'package:siswa_ride/pages/dashboard2.dart';
import 'package:siswa_ride/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  @override
  void initState() {
    super.initState();
    print('LoginScreen initialized');
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
    print('LoginScreen disposed');
  }

  signInFormValidation() {
    //cMethods.checkConnectivity(context); // Check network connectivity

    // Proceed with form validation
    if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Your email format is invalid", context);
    } else if (passwordTextEditingController.text.trim().length < 5) {
      cMethods.displaySnackBar(
          "Your password must be at least 6 characters.", context);
    } else {
      signInUser();
    }
  }

  signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Logging into your account..."),
    );

    try {
      final User? userFirebase =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      ))
              .user;

      if (!context.mounted) return;
      Navigator.pop(context);

      if (userFirebase != null) {
        DatabaseReference usersRef = FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(userFirebase.uid);
        usersRef.once().then((snap) {
          if (snap.snapshot.value != null) {
            final userMap = snap.snapshot.value as Map;
            if (userMap["blockStatus"] == "no") {
              userName = userMap['name'];
              String userType = userMap['userType'];
              if (userType == 'Customer') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Dashboard(userName: userName)),
                );
              } else if (userType == 'Driver') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Dashboard2(userName: userName)),
                );
              }
            } else {
              FirebaseAuth.instance.signOut();
              cMethods.displaySnackBar("Your account is blocked.", context);
            }
          } else {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("Your account does not exist.", context);
          }
        });
      }
    } catch (error) {
      Navigator.pop(context);
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found' || error.code == 'wrong-password') {
          cMethods.displaySnackBar(
              "Your email/password is not correct.", context);
        } else {
          cMethods.displaySnackBar(error.message.toString(), context);
        }
      } else {
        cMethods.displaySnackBar(error.toString(), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Login your registered Account",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "User Email",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Password",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        signInFormValidation(); // Call form validation directly
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 48, 98, 207),
                          padding: const EdgeInsets.symmetric(horizontal: 80)),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                },
                child: const Text(
                  "Don't have an Account? Register Here",
                  style: TextStyle(
                    color: Colors.grey,
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
