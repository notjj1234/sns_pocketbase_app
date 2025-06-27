// lib/pages/login/edit_profile_page.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sns_pocketbase_app/pages/login/login_page.dart';
import 'package:sns_pocketbase_app/config/app_config.dart';
import 'dart:io';

class CreateProfilePage extends StatefulWidget {
  final String userId;
  final String email;

  const CreateProfilePage({
    super.key,
    required this.userId,
    required this.email,
  });

  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _bioController = TextEditingController();
  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();
  File? _avatar;

  Future<void> updateProfile() async {
    try {
      // In demo mode, we'll simulate profile creation
      final avatarUrl = _avatar != null
          ? 'https://i.pravatar.cc/150?img=${DateTime.now().millisecondsSinceEpoch}'
          : 'https://i.pravatar.cc/150?img=1';

      final profileData = {
        'user_id': widget.userId,
        'name': _nameController.text,
        'department': _departmentController.text,
        'bio': _bioController.text,
        'avatar': avatarUrl,
      };

      await AppConfig.dataService.createProfile(profileData);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(
              email: widget.email,
              password: '',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> pickAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatar = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create Profile',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: pickAvatar,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _avatar != null
                            ? FileImage(_avatar!)
                            : const NetworkImage('https://i.pravatar.cc/150?img=1') as ImageProvider,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
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
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _departmentController,
                  decoration: InputDecoration(
                    labelText: 'Department',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: updateProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Create Profile'),
                ),
                if (AppConfig.isDemoMode) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Demo Mode: Profile will be created locally',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
