import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class EditProfile2Page extends StatefulWidget {
  const EditProfile2Page({super.key});

  @override
  State<EditProfile2Page> createState() => _EditProfile2PageState();
}

class _EditProfile2PageState extends State<EditProfile2Page> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController carPlateNumberController = TextEditingController();
  TextEditingController carTypeController = TextEditingController();
  TextEditingController carColourController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankAccountNumberController = TextEditingController();
  String gender = '';

  XFile? _idCardImage;
  XFile? _licenseImage;
  XFile? _matricCardImage;
  XFile? _driverPhoto;
  final ImagePicker _picker = ImagePicker();

  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final FirebaseStorage storage = FirebaseStorage.instance;

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
        carPlateNumberController.text = userData['carPlateNumber'] ?? '';
        carTypeController.text = userData['carType'] ?? '';
        carColourController.text = userData['carColour'] ?? '';
        bankNameController.text = userData['bankName'] ?? '';
        bankAccountNumberController.text = userData['bankAccountNumber'] ?? '';
        gender = userData['gender'] ?? '';
        setState(() {});
      }
    }
  }

  Future<void> _pickImage(ImageType type) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        switch (type) {
          case ImageType.idCard:
            _idCardImage = pickedFile;
            break;
          case ImageType.license:
            _licenseImage = pickedFile;
            break;
          case ImageType.matricCard:
            _matricCardImage = pickedFile;
            break;
          case ImageType.driverPhoto:
            _driverPhoto = pickedFile;
            break;
        }
      });
    }
  }

  Future<String?> _uploadImage(XFile imageFile, String filePath) async {
    try {
      Uint8List fileData =
          await imageFile.readAsBytes(); // Read as bytes for web compatibility
      TaskSnapshot snapshot =
          await storage.ref().child(filePath).putData(fileData);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  Future<void> _handleUpdate() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;

      String name = nameController.text;
      String phone = phoneController.text;
      String email = emailController.text;
      String carPlateNumber = carPlateNumberController.text;
      String carType = carTypeController.text;
      String carColour = carColourController.text;
      String bankName = bankNameController.text;
      String bankAccountNumber = bankAccountNumberController.text;

      String? idCardUrl;
      String? licenseUrl;
      String? matricCardUrl;
      String? driverPhotoUrl;

      if (_idCardImage != null) {
        idCardUrl =
            await _uploadImage(_idCardImage!, 'id_cards/$uid/id_card.jpeg');
      }
      if (_licenseImage != null) {
        licenseUrl =
            await _uploadImage(_licenseImage!, 'licenses/$uid/license.jpeg');
      }
      if (_matricCardImage != null) {
        matricCardUrl = await _uploadImage(
            _matricCardImage!, 'matric_cards/$uid/matric_card.jpeg');
      }
      if (_driverPhoto != null) {
        driverPhotoUrl = await _uploadImage(
            _driverPhoto!, 'driver_photos/$uid/driver_photo.jpeg');
      }

      Map<String, dynamic> updatedData = {
        'name': name,
        'phone': phone,
        'email': email,
        'carPlateNumber': carPlateNumber,
        'carType': carType,
        'carColour': carColour,
        'bankName': bankName,
        'bankAccountNumber': bankAccountNumber,
        'gender': gender,
        if (idCardUrl != null) 'idCardUrl': idCardUrl,
        if (licenseUrl != null) 'licenseUrl': licenseUrl,
        if (matricCardUrl != null) 'matricCardUrl': matricCardUrl,
        if (driverPhotoUrl != null) 'driverPhotoUrl': driverPhotoUrl,
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
        title: const Text('Edit Profile'),
        backgroundColor: const Color.fromARGB(255, 48, 98, 207),
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
          child: SingleChildScrollView(
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
                  icon: Icons.photo_camera,
                  label: 'Driver Photo',
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickImage(ImageType.driverPhoto),
                        child: const Text('Upload Driver Photo'),
                      ),
                      const SizedBox(width: 10),
                      _driverPhoto != null
                          ? const Text('Image selected')
                          : const Text('No image selected'),
                    ],
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
                  label: 'Email',
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildFieldWithIcon(
                  icon: Icons.car_rental,
                  label: 'Car Plate Number',
                  child: TextFormField(
                    controller: carPlateNumberController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your car plate number',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildFieldWithIcon(
                  icon: Icons.car_repair,
                  label: 'Car Type',
                  child: TextFormField(
                    controller: carTypeController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your car type',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildFieldWithIcon(
                  icon: Icons.color_lens,
                  label: 'Car Colour',
                  child: TextFormField(
                    controller: carColourController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your car colour',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildFieldWithIcon(
                  icon: Icons.account_balance,
                  label: 'Bank Name',
                  child: TextFormField(
                    controller: bankNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your bank name',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildFieldWithIcon(
                  icon: Icons.account_balance_wallet,
                  label: 'Bank Account Number',
                  child: TextFormField(
                    controller: bankAccountNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter your bank account number',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildFieldWithIcon(
                  icon: Icons.perm_identity,
                  label: 'ID Card',
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickImage(ImageType.idCard),
                        child: const Text('Upload ID Card'),
                      ),
                      const SizedBox(width: 10),
                      _idCardImage != null
                          ? const Text('Image selected')
                          : const Text('No image selected'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildFieldWithIcon(
                  icon: Icons.perm_identity,
                  label: 'License',
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickImage(ImageType.license),
                        child: const Text('Upload License'),
                      ),
                      const SizedBox(width: 10),
                      _licenseImage != null
                          ? const Text('Image selected')
                          : const Text('No image selected'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildFieldWithIcon(
                  icon: Icons.perm_identity,
                  label: 'Matric Card',
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickImage(ImageType.matricCard),
                        child: const Text('Upload Matric Card'),
                      ),
                      const SizedBox(width: 10),
                      _matricCardImage != null
                          ? const Text('Image selected')
                          : const Text('No image selected'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: _handleUpdate,
                    child: const Text('Update'),
                  ),
                ),
              ],
            ),
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
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

enum ImageType { idCard, license, matricCard, driverPhoto }
