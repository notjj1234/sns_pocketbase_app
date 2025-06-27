// lib/pages/feed/posts/home_page.dart

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<dynamic> posts;
  final String userId;
  final String profileId;

  const HomePage({
    Key? key,
    required this.posts,
    required this.userId,
    required this.profileId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=${index + 1}'),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        post['user'] == '1' ? 'Test User 1' : 'Test User 2',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(post['content']),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.thumb_up_outlined),
                        label: Text('${(post['likes'] as List).length}'),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.comment_outlined),
                        label: const Text('Comment'),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined),
                        label: const Text('Share'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a dialog to create a new post
          showDialog(
            context: context,
            builder: (context) => const NewPostDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewPostDialog extends StatefulWidget {
  const NewPostDialog({Key? key}) : super(key: key);

  @override
  _NewPostDialogState createState() => _NewPostDialogState();
}

class _NewPostDialogState extends State<NewPostDialog> {
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Post'),
      content: TextField(
        controller: _contentController,
        decoration: const InputDecoration(
          hintText: 'What\'s on your mind?',
        ),
        maxLines: 4,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // In demo mode, we just close the dialog
            Navigator.pop(context);
          },
          child: const Text('Post'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
