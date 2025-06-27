// profile_page.dart

import 'package:flutter/material.dart';
import 'package:sns_pocketbase_app/pages/feed/posts/view_posts_page.dart';
import 'package:sns_pocketbase_app/pages/profile/edit_profile_page.dart';
import 'package:sns_pocketbase_app/pages/login/login_page.dart';
import 'package:sns_pocketbase_app/pages/settings/language_provider.dart';
import 'package:sns_pocketbase_app/utils/translations.dart';
import 'package:provider/provider.dart';
import 'package:sns_pocketbase_app/config/app_config.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  final String email;
  final VoidCallback onLogout;

  const ProfilePage({
    super.key,
    required this.userId,
    required this.email,
    required this.onLogout,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";
  String bio = "";
  String avatarUrl = "";
  String department = "";
  bool isLoading = true;
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadPosts();
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final profiles = await AppConfig.dataService.getProfiles();
      final profile = profiles.firstWhere(
        (p) => p['id'] == widget.userId,
        orElse: () => {
          'name': 'Demo User',
          'avatar': 'https://i.pravatar.cc/150?img=1',
          'department': 'Demo Department',
        },
      );

      if (mounted) {
        setState(() {
          username = profile['name'];
          avatarUrl = profile['avatar'];
          department = profile['department'];
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadPosts() async {
    if (!mounted) return;

    try {
      final allPosts = await AppConfig.dataService.getPosts();
      if (mounted) {
        setState(() {
          posts = allPosts.where((post) => post['user'] == widget.userId).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLanguage = Provider.of<LanguageProvider>(context).currentLanguage;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadProfile();
          await _loadPosts();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      department,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.email),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              userId: widget.userId,
                              email: widget.email,
                              onProfileUpdated: () {
                                _loadProfile();
                              },
                            ),
                          ),
                        );
                      },
                      child: Text(translations[currentLanguage]?['edit_profile'] ?? 'Edit Profile'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () async {
                        widget.onLogout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: Text(translations[currentLanguage]?['logout'] ?? 'Logout'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                          Text(
                            post['content'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateTime.parse(post['created']).toLocal().toString().split('.')[0],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
