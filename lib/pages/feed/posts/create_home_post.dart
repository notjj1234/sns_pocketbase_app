// lib/pages/create_post/create_home_post.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sns_pocketbase_app/pages/feed/feed_page.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:sns_pocketbase_app/config/app_config.dart';
import 'dart:io';

class CreateHomePostPage extends StatefulWidget {
  final String userId;
  final String email;
  final VoidCallback onLogout;

  const CreateHomePostPage({
    super.key,
    required this.userId,
    required this.email,
    required this.onLogout,
  });

  @override
  _CreateHomePostPageState createState() => _CreateHomePostPageState();
}

class _CreateHomePostPageState extends State<CreateHomePostPage> {
  final _contentController = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  List<File> _selectedImages = [];

  Future<void> createPost() async {
    try {
      if (_contentController.text.isEmpty) {
        _btnController.error();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post content cannot be empty')),
        );
        await Future.delayed(const Duration(seconds: 2));
        _btnController.reset();
        return;
      }

      // In demo mode, we'll simulate image upload by using placeholder URLs
      List<String> imageUrls = [];
      for (int i = 0; i < _selectedImages.length; i++) {
        imageUrls.add('https://picsum.photos/800/600?random=${DateTime.now().millisecondsSinceEpoch + i}');
      }

      final postData = {
        'content': _contentController.text,
        'images': imageUrls,
        'created': DateTime.now().toIso8601String(),
        'user': widget.userId,
        'likes': [],
        'comments': [],
      };

      await AppConfig.dataService.createPost(postData);
      _btnController.success();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => FeedPage(
            userId: widget.userId,
            email: widget.email,
            onLogout: widget.onLogout,
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      _btnController.error();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      await Future.delayed(const Duration(seconds: 2));
      _btnController.reset();
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Create Post', style: TextStyle(color: Theme.of(context).textTheme.headlineLarge?.color)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _contentController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Write something...',
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _selectedImages.isEmpty
                    ? const Text("No images selected")
                    : Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _selectedImages
                            .map((image) => Image.file(
                                  image,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ))
                            .toList(),
                      ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: pickImages,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  ),
                  child: const Text(
                    'Select Images',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                RoundedLoadingButton(
                  controller: _btnController,
                  onPressed: createPost,
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (AppConfig.isDemoMode) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Demo Mode: Post will be stored locally',
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
