// File: lib/pages/feed/view_posts_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import flutter_spinkit

class ViewPostsPage extends StatelessWidget {
  final Map<String, dynamic> post;
  final String authorName;
  final String userId;

  const ViewPostsPage({super.key, required this.post, required this.authorName, required this.userId});

  Future<void> _deletePost(BuildContext context, String postId) async {
    final deleteUrl = 'https://bec-sns.pockethost.io/api/collections/posts/records/$postId';
    try {
      final response = await http.delete(Uri.parse(deleteUrl));
      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Post deleted successfully.");
        Navigator.of(context).pop(true); // Return to the previous screen with success signal
      } else {
        print("Failed to delete post: ${response.body}");
      }
    } catch (e) {
      print("Error deleting post: $e");
    }
  }

  void _openFullScreenGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Image Gallery"),
            backgroundColor: Colors.black,
          ),
          body: PhotoViewGallery.builder(
            itemCount: post['media'].length,
            builder: (context, index) {
              String mediaUrl =
                  'https://bec-sns.pockethost.io/api/files/${post['collectionId']}/${post['id']}/${post['media'][index]}';
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(mediaUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: PageController(initialPage: initialIndex),
            scrollPhysics: const BouncingScrollPhysics(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        backgroundColor: Colors.black,
        actions: [
          if (post['authorProfile']?['id'] == userId)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirmDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Delete Post"),
                    content: const Text("Are you sure you want to delete this post?"),
                    actions: [
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text("Delete"),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                );

                if (confirmDelete == true) {
                  await _deletePost(context, post['id']);
                }
              },
            )
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.grey[850],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authorName,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post['caption'] ?? 'No Caption',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  if (post['media'] != null && post['media'].isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: post['media'].length,
                      itemBuilder: (context, index) {
                        String mediaUrl =
                            'https://bec-sns.pockethost.io/api/files/${post['collectionId']}/${post['id']}/${post['media'][index]}';
                        return GestureDetector(
                          onTap: () {
                            _openFullScreenGallery(context, index);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              mediaUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Center(
                                  child: SpinKitFadingCircle(
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Text(
                                  'Image could not be loaded',
                                  style: TextStyle(color: Colors.white70),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    )
                  else
                    const Text(
                      'No Images Available',
                      style: TextStyle(color: Colors.white70),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
