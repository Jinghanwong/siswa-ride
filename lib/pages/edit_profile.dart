import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String gender = '';

  XFile? _customerPhoto;
  XFile? _matricCardImage;
  String? _matricCardImageUrl;
  String? _customerPhotoUrl;

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

      if (snapshot.exists && snapshot.value != null) {
        Map<dynamic, dynamic> rawData = snapshot.value as Map<dynamic, dynamic>;
        Map<String, dynamic> userData = Map<String, dynamic>.from(rawData);

        setState(() {
          nameController.text = userData['name'] ?? '';
          phoneController.text = userData['phone'] ?? '';
          emailController.text = userData['email'] ?? '';
          gender = userData['gender'] ?? '';
          _customerPhotoUrl = userData['customerPhotoUrl']?.toString();
          _matricCardImageUrl = userData['matricCardUrl']?.toString();
        });
      }
    }
  }

  Future<String?> _loadImageFromStorage(
      String folder, String userId, String fileName) async {
    try {
      String downloadUrl =
          await storage.ref('$folder/$userId/$fileName').getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error loading image from storage: $e');
      return null;
    }
  }

  Future<void> _pickImage(ImageType type) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        switch (type) {
          case ImageType.matricCard:
            _matricCardImage = pickedFile;
            break;
          case ImageType.customerPhoto:
            _customerPhoto = pickedFile;
            break;
        }
      });
    }
  }

  Future<String?> _uploadImage(XFile imageFile, String filePath) async {
    try {
      Uint8List fileData = await imageFile.readAsBytes();
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

      Map<String, dynamic> updatedData = {
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'gender': gender,
        'matricCardUrl': _matricCardImageUrl ?? '',
        'customerPhotoUrl': _customerPhotoUrl ?? '',
      };

      // 上传新的 Matric Card 照片并更新 URL
      if (_matricCardImage != null) {
        String? url = await _uploadImage(
            _matricCardImage!, 'matric_cards/$uid/matric_card.jpeg');
        if (url != null) {
          updatedData['matricCardUrl'] = url;
          _matricCardImageUrl = url;
        }
      }
      if (_customerPhoto != null) {
        String? url = await _uploadImage(
            _customerPhoto!, 'customer_photos/$uid/customer_photo.jpeg');
        if (url != null) {
          updatedData['customerPhotoUrl'] = url;
          _customerPhotoUrl = url;
        }
      }

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

  Widget _buildImagePreview(String? imageUrl, XFile? imageFile,
      {bool isCustomerPhoto = false}) {
    if (imageFile != null) {
      return FutureBuilder<Uint8List>(
        future: imageFile.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildImageContainer(
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
              isCustomerPhoto: isCustomerPhoto,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      return _buildImageContainer(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image: $error');
            return const Center(
              child: Text(
                'Error loading image',
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        ),
        isCustomerPhoto: isCustomerPhoto,
      );
    }
    return _buildImageContainer(
      child: const Center(
        child: Text(
          'No image',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      isCustomerPhoto: isCustomerPhoto,
    );
  }

  Widget _buildImageContainer(
      {required Widget child, bool isCustomerPhoto = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: isCustomerPhoto ? 150 : 150,
      width: isCustomerPhoto ? 150 : double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0, // 增加一些高度以适应新布局
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade800,
                      Colors.blue.shade500,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // 标题移到这里
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20), // 标题和头像之间的间距
                      _buildProfileImage(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      'Personal Information',
                      [
                        _buildTextField(
                          controller: nameController,
                          label: 'Full Name',
                          icon: Icons.person_outline,
                        ),
                        _buildTextField(
                          controller: phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        _buildGenderSelection(),
                        _buildTextField(
                          controller: emailController,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                    _buildSection(
                      'Documents',
                      [
                        _buildDocumentUpload(
                          'Matric Card',
                          _matricCardImageUrl,
                          _matricCardImage,
                          () => _pickImage(ImageType.matricCard),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildUpdateButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () => _pickImage(ImageType.customerPhoto),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: _customerPhoto != null || _customerPhotoUrl != null
                  ? SizedBox(
                      width: 120, // 确保宽度等于直径
                      height: 120, // 确保高度等于直径
                      child: _customerPhoto != null
                          ? FutureBuilder<Uint8List>(
                              future: _customerPhoto!.readAsBytes(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover, // 使用 cover 确保填满
                                    width: 120,
                                    height: 120,
                                  );
                                }
                                return const CircularProgressIndicator();
                              },
                            )
                          : Image.network(
                              _customerPhotoUrl!,
                              fit: BoxFit.cover, // 使用 cover 确保填满
                              width: 120,
                              height: 120,
                            ),
                    )
                  : const Icon(Icons.person, size: 60, color: Colors.blue),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12.0,
          children: [
            const Icon(Icons.people_outline, color: Colors.blue),
            const Text('Gender:'),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (value) =>
                        setState(() => gender = value.toString()),
                  ),
                  const Text('Male'),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (value) =>
                        setState(() => gender = value.toString()),
                  ),
                  const Text('Female'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentUpload(
      String title, String? imageUrl, XFile? imageFile, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: _buildImagePreview(imageUrl, imageFile),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _handleUpdate,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Update Profile',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

enum ImageType { matricCard, customerPhoto }
