// feed_page.dart

import 'package:flutter/material.dart';
import 'package:sns_pocketbase_app/pages/feed/events/events_calendar.dart';
import 'package:sns_pocketbase_app/pages/feed/events/event_page.dart';
import 'package:sns_pocketbase_app/pages/feed/posts/home_page.dart';
import 'package:sns_pocketbase_app/pages/login/login_page.dart';
import 'package:sns_pocketbase_app/pages/profile/profile_page.dart';
import 'package:sns_pocketbase_app/pages/settings/language_provider.dart';
import 'package:sns_pocketbase_app/pages/settings/settings_page.dart';
import 'package:sns_pocketbase_app/utils/translations.dart';
import 'package:sns_pocketbase_app/config/app_config.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FeedPage extends StatefulWidget {
  final String userId;
  final String email;
  final VoidCallback onLogout;

  const FeedPage({super.key, required this.userId, required this.email, required this.onLogout});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int _selectedIndex = 0;

  List<dynamic> _posts = [];
  Map<String, dynamic> _profilesMap = {};
  bool _isLoading = true;
  Timer? _debounce;
  String? profileId;

  @override
  void initState() {
    super.initState();
    _fetchPostsAndProfiles();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchPostsAndProfiles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await AppConfig.dataService.getPosts();
      final profiles = await AppConfig.dataService.getProfiles();

      setState(() {
        _posts = posts;
        _profilesMap = {
          for (var profile in profiles) profile['id'].toString(): profile
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String getPageTitle(BuildContext context) {
    final currentLanguage = Provider.of<LanguageProvider>(context).currentLanguage;

    switch (_selectedIndex) {
      case 0:
        return translations[currentLanguage]?['feed'] ?? 'Feed';
      case 1:
        return translations[currentLanguage]?['company_news'] ?? 'News Feed';
      case 2:
        return translations[currentLanguage]?['company_calendar'] ?? 'Calendar';
      case 3:
        return translations[currentLanguage]?['profile'] ?? 'Profile';
      case 4:
        return translations[currentLanguage]?['settings'] ?? 'Settings';
      default:
        return '';
    }
  }

  Color getAppBarColor() {
    switch (_selectedIndex) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.indigo;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.teal;
      case 4:
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  List<Widget> _getPages() {
    return [
      HomePage(
        posts: _posts,
        userId: widget.userId,
        profileId: widget.userId,
      ),
      EventPage(),
      CalendarView(events: const {}),
      ProfilePage(
        userId: widget.userId,
        email: widget.email,
        onLogout: widget.onLogout
      ),
      SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final currentLanguage = Provider.of<LanguageProvider>(context).currentLanguage;
    final pages = _getPages();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getPageTitle(context),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: getAppBarColor(),
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _fetchPostsAndProfiles,
                  color: Colors.white,
                ),
              ]
            : null,
      ),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            )
          : pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: translations[currentLanguage]?['feed'] ?? 'Feed',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.article),
            label: translations[currentLanguage]?['company_news'] ?? 'News Feed',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: translations[currentLanguage]?['company_calendar'] ?? 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: translations[currentLanguage]?['profile'] ?? 'Profile',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: translations[currentLanguage]?['settings'] ?? 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: getAppBarColor(),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
