// lib/pages/feed/events/create_event_page.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sns_pocketbase_app/config/app_config.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _eventDateController = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final ImagePicker _picker = ImagePicker();
  DateTime? _selectedDate;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // In demo mode, use a placeholder image
        setState(() {
          _imageUrl = 'https://picsum.photos/800/400?random=${DateTime.now().millisecondsSinceEpoch}';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _eventDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _createEvent() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty || _selectedDate == null) {
      _btnController.error();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      await Future.delayed(const Duration(seconds: 1));
      _btnController.reset();
      return;
    }

    try {
      final newsData = {
        'title': _titleController.text,
        'content': _contentController.text,
        'date': _selectedDate!.toIso8601String(),
        'image': _imageUrl,
      };

      await AppConfig.dataService.createNews(newsData);

      _btnController.success();
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      _btnController.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating event: $e')),
        );
      }
      await Future.delayed(const Duration(seconds: 1));
      _btnController.reset();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _eventDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create News'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _eventDateController,
              decoration: InputDecoration(
                labelText: 'Date',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 24),
            _imageUrl != null
                ? Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.network(
                        _imageUrl!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _imageUrl = null;
                          });
                        },
                      ),
                    ],
                  )
                : ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Add Image'),
                  ),
            const SizedBox(height: 24),
            RoundedLoadingButton(
              controller: _btnController,
              onPressed: _createEvent,
              child: const Text('Create News', style: TextStyle(color: Colors.white)),
            ),
            if (AppConfig.isDemoMode) ...[
              const SizedBox(height: 24),
              const Text(
                'Demo Mode: News will be stored locally',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
