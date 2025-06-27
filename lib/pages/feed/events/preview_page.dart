import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime? date;

  const PreviewPage({
    super.key,
    required this.title,
    required this.content,
    this.imageUrl,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview News'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (date != null) ...[
              const SizedBox(height: 8),
              Text(
                date!.toLocal().toString().split(' ')[0],
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 16),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
