import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String gender = '';
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref(); // Correct method to get reference

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      DatabaseEvent event = await dbRef.child('users/$uid').once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        nameController.text = userData['name'] ?? '';
        phoneController.text = userData['phone'] ?? '';
        emailController.text = userData['email'] ?? '';
        gender = userData['gender'] ?? '';
        setState(() {});
      }
    }
  }

  void _handleUpdate() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      String name = nameController.text;
      String phone = phoneController.text;
      String email = emailController.text;

      Map<String, dynamic> updatedData = {
        'name': name,
        'phone': phone,
        'email': email,
        'gender': gender,
      };

      dbRef.child('users/$uid').update(updatedData).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Update successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 20), // 设置标题字体大小
        ),
        backgroundColor: const Color.fromARGB(255, 48, 98, 207), // 设置AppBar背景色
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF82B1FF), Color(0xFF2962FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldWithIcon(
                icon: Icons.person,
                label: 'Name',
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildFieldWithIcon(
                icon: Icons.phone,
                label: 'Phone No',
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Enter your phone number',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildFieldWithIcon(
                icon: Icons.people,
                label: 'Gender',
                child: Row(
                  children: [
                    Radio(
                      value: 'Male',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                    const Text('Male'),
                    Radio(
                      value: 'Female',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                    const Text('Female'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildFieldWithIcon(
                icon: Icons.email,
                label: 'Email Address',
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email address',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _handleUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 48, 98, 207),
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(
                        color: Colors.white, fontSize: 18), // 设置按钮文本样式
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldWithIcon(
      {required IconData icon, required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
