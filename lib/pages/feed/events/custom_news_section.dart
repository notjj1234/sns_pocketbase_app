// lib/pages/feed/events/custom_bec_news_section.dart

import 'package:flutter/material.dart';

class CustomSection {
  String type;
  TextEditingController textController = TextEditingController();
  TextEditingController titleController = TextEditingController(); // Added controller for title

  CustomSection({this.type = 'Text'});

  Widget build(BuildContext context) {
    switch (type) {
      case 'Text':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController, // Input for section title
              decoration: InputDecoration(
                hintText: 'Enter section title here...',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Enter text here...',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': titleController.text, // Save the section title to JSON
      'content': textController.text,
    };
  }
}

class CustomBECNewsSection extends StatefulWidget {
  final List<CustomSection> customSections;
  final Function onAddCustomSection;
  final Function onDeleteCustomSection;

  const CustomBECNewsSection({
    super.key,
    required this.customSections,
    required this.onAddCustomSection,
    required this.onDeleteCustomSection,
  });

  @override
  _CustomBECNewsSectionState createState() => _CustomBECNewsSectionState();
}

class _CustomBECNewsSectionState extends State<CustomBECNewsSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Custom BEC News Section",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.customSections.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[800],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.customSections[index].titleController.text.isEmpty
                              ? 'Section ${index + 1}' // If no title provided, use default numbering
                              : widget.customSections[index].titleController.text,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        widget.customSections[index].build(context),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => widget.onDeleteCustomSection(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            // Add Custom Section Button
            Center(
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.greenAccent),
                onPressed: () => widget.onAddCustomSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNewsSection extends StatelessWidget {
  final String title;
  final String content;
  final String? imageUrl;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final DateTime? date;

  const CustomNewsSection({
    Key? key,
    required this.title,
    required this.content,
    this.imageUrl,
    this.onDelete,
    this.onEdit,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            Image.network(
              imageUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    if (onEdit != null || onDelete != null)
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit' && onEdit != null) {
                            onEdit!();
                          } else if (value == 'delete' && onDelete != null) {
                            onDelete!();
                          }
                        },
                        itemBuilder: (context) => [
                          if (onEdit != null)
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                          if (onDelete != null)
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                        ],
                      ),
                  ],
                ),
                if (date != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    date!.toLocal().toString().split(' ')[0],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
