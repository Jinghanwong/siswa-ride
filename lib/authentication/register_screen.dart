import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:siswa_ride/authentication/login_screen.dart';
import 'package:siswa_ride/methods/common_methods.dart';
import 'package:siswa_ride/pages/dashboard.dart';
import 'package:siswa_ride/pages/dashboard2.dart';
import 'package:siswa_ride/widgets/loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController userPhoneTextEditingController =
      TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  String? _userType = 'Customer';

  registerFormValidation() {
    //cMethods.checkConnectivity(context); // Check network connectivity

    // Proceed with form validation
    if (userNameTextEditingController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          "Your name must be at least 4 or more characters.", context);
    } else if (userPhoneTextEditingController.text.trim().length < 9) {
      cMethods.displaySnackBar(
          "Your phone number must be at least 10 or more numbers.", context);
    } else if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Your email format in invalid", context);
    } else if (passwordTextEditingController.text.trim().length < 5) {
      cMethods.displaySnackBar(
          "Your password must be at least 6 or more characters.", context);
    } else {
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Registering your account..."),
    );

    try {
      final User? userFirebase = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
        // ignore: body_might_complete_normally_catch_error
      )
              // ignore: body_might_complete_normally_catch_error
              .catchError((errorMsg) {
        Navigator.pop(context);
        cMethods.displaySnackBar(errorMsg.toString(), context);
      }))
          .user;

      if (userFirebase != null) {
        DatabaseReference usersRef = FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(userFirebase.uid);
        Map<String, dynamic> userDataMap = {
          "name": userNameTextEditingController.text.trim(),
          "email": emailTextEditingController.text.trim(),
          "phone": userPhoneTextEditingController.text.trim(),
          "id": userFirebase.uid,
          "blockStatus": "no",
          "userType": _userType,
        };
        usersRef.set(userDataMap).then((_) {
          if (_userType == 'Customer') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Dashboard(
                      userName: userNameTextEditingController.text.trim())),
            );
          } else if (_userType == 'Driver') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Dashboard2(
                      userName: userNameTextEditingController.text.trim())),
            );
          }
        });
      }
    } catch (error) {
      Navigator.pop(context);
      cMethods.displaySnackBar(error.toString(), context);
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
                "Register",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10), // Add some space between the texts
              const Text(
                "Create an Account",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              //text fields + button
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: userNameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Name",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: userPhoneTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Phone Number",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 22),
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
                    const SizedBox(height: 22),
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
                    const SizedBox(height: 22),
                    // Add Radio buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Driver'),
                        Radio<String>(
                          value: 'Driver',
                          groupValue: _userType,
                          onChanged: (value) {
                            setState(() {
                              _userType = value;
                            });
                          },
                        ),
                        const Text('Customer'),
                        Radio<String>(
                          value: 'Customer',
                          groupValue: _userType,
                          onChanged: (value) {
                            setState(() {
                              _userType = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        registerFormValidation(); // Call form validation directly
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 48, 98, 207),
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              //textbutton
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  "Already have an Account? Login Here",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
