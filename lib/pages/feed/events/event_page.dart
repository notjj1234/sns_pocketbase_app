// lib/pages/feed/events/event_page.dart

import 'package:flutter/material.dart';
import 'package:sns_pocketbase_app/pages/settings/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:sns_pocketbase_app/utils/translations.dart';
import 'package:sns_pocketbase_app/config/app_config.dart';
import 'custom_news_section.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<Map<String, dynamic>> _news = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final news = await AppConfig.dataService.getNews();
      if (mounted) {
        setState(() {
          _news = List<Map<String, dynamic>>.from(news);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLanguage = Provider.of<LanguageProvider>(context).currentLanguage;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _news.isEmpty
              ? Center(
                  child: Text(
                    translations[currentLanguage]?['no_news'] ?? 'No news available',
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNews,
                  child: ListView.builder(
                    itemCount: _news.length,
                    itemBuilder: (context, index) {
                      final newsItem = _news[index];
                      return CustomNewsSection(
                        title: newsItem['title'],
                        content: newsItem['content'],
                        imageUrl: newsItem['image'],
                        date: DateTime.parse(newsItem['created']),
                        onEdit: () {},
                        onDelete: () async {
                          // Show confirmation dialog
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(translations[currentLanguage]?['delete_news'] ?? 'Delete News'),
                              content: const Text('Are you sure you want to delete this news item?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text(translations[currentLanguage]?['cancel'] ?? 'Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(translations[currentLanguage]?['delete'] ?? 'Delete'),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete == true) {
                            try {
                              await AppConfig.dataService.deleteNews(newsItem['id']);
                              await _loadNews();
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateEventPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateEventPage extends StatelessWidget {
  const CreateEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translations[Provider.of<LanguageProvider>(context).currentLanguage]?['create_news'] ?? 'Create News'),
      ),
      body: const Center(
        child: Text('Create news form will be here'),
      ),
    );
  }
}



