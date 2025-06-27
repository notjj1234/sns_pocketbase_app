import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sns_pocketbase_app/config/app_config.dart';

class EditPostPage extends StatefulWidget {
  final String postId;
  final String currentCaption;
  final List<dynamic> currentPhotos;
  final Function(String, List<dynamic>) onPostUpdated;

  const EditPostPage({
    super.key,
    required this.postId,
    required this.currentCaption,
    required this.currentPhotos,
    required this.onPostUpdated,
  });

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late TextEditingController _captionController;
  bool _isSaving = false;
  List<XFile> _newPhotos = [];
  List<dynamic> _currentPhotos = [];

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.currentCaption);
    _currentPhotos = List.from(widget.currentPhotos);
  }

  Future<void> _pickPhotos() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? selectedPhotos = await picker.pickMultiImage();

    if (selectedPhotos != null) {
      setState(() {
        _newPhotos.addAll(selectedPhotos);
      });
    }
  }

  Future<void> _editPost() async {
    final newCaption = _captionController.text.trim();
    if (newCaption.isEmpty && _newPhotos.isEmpty && _currentPhotos.isEmpty) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // In demo mode, we'll simulate image upload with placeholder URLs
      List<dynamic> updatedPhotos = [..._currentPhotos];
      
      for (var _ in _newPhotos) {
        updatedPhotos.add('https://picsum.photos/800/400?random=${DateTime.now().millisecondsSinceEpoch}');
      }

      final updatedPost = await AppConfig.dataService.updatePost(
        widget.postId,
        {
          'content': newCaption,
          'images': updatedPhotos,
        },
      );

      widget.onPostUpdated(newCaption, updatedPhotos);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating post: $e')),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isSaving ? null : _editPost,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Caption',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _captionController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter your new caption',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Edit Photos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ..._currentPhotos.map((photo) => Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.network(
                              photo,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _currentPhotos.remove(photo);
                                });
                              },
                            ),
                          ],
                        )),
                    ..._newPhotos.map((photo) => Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.file(
                              File(photo.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _newPhotos.remove(photo);
                                });
                              },
                            ),
                          ],
                        )),
                    GestureDetector(
                      onTap: _pickPhotos,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, size: 40),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isSaving)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
