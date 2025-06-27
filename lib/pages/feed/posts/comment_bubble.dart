import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CommentBubble extends StatelessWidget {
  final List<Map<String, dynamic>> comments;
  final TextEditingController commentController;
  final Function(String content) onPostComment;
  final VoidCallback onClose;
  final bool isLoading; // <-- Add a new parameter for the loading state

  const CommentBubble({super.key, 
    required this.comments,
    required this.commentController,
    required this.onPostComment,
    required this.onClose,
    required this.isLoading, // <-- Include it in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.30, // Limit height to half of the screen
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prevent infinite expansion
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
                    onPressed: onClose,
                  ),
                ],
              ),
              Divider(color: Theme.of(context).dividerColor),
              Expanded(
                child: isLoading
                    ? Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Theme.of(context).colorScheme.primary,
                          size: 50,
                        ),
                      )
                    : comments.isEmpty
                        ? Center(
                            child: Text(
                              'No comments yet.',
                              style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: comments.map((comment) {
                                final authorName = comment['resolvedAuthorName'] ?? 'Unknown User';
                                final content = comment['content'] ?? '';

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '$authorName: $content',
                                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(hintText: 'Write a comment...'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      onPostComment(commentController.text.trim());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
