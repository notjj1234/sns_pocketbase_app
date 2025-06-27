import 'dart:math';
import 'data_service.dart';

class DemoDataService implements DataService {
  final List<Map<String, dynamic>> _demoNews = [];
  final List<Map<String, dynamic>> _demoPosts = [];
  final List<Map<String, dynamic>> _demoProfiles = [];
  final Random _random = Random();

  DemoDataService() {
    _initializeDemoData();
  }

  void _initializeDemoData() {
    // Initialize demo profiles
    _demoProfiles.addAll([
      {
        'id': '1',
        'name': 'Test User 1',
        'avatar': 'https://i.pravatar.cc/150?img=1',
        'department': 'Sales'
      },
      {
        'id': '2',
        'name': 'Test User 2',
        'avatar': 'https://i.pravatar.cc/150?img=2',
        'department': 'Finance'
      },
      // Add more demo profiles as needed
    ]);

    // Initialize demo posts
    _demoPosts.addAll([
      {
        'id': '1',
        'content': 'Excited to announce our new project launch!',
        'created': DateTime.now().toIso8601String(),
        'user': '1',
        'likes': ['2'],
        'comments': []
      },
      {
        'id': '2',
        'content': 'Great team meeting today!',
        'created': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'user': '2',
        'likes': ['1'],
        'comments': []
      },
      // Add more demo posts as needed
    ]);

    // Initialize demo news
    _demoNews.addAll([
      {
        'id': '1',
        'title': 'Company Updates',
        'content': 'We are expanding our operations to new regions!',
        'created': DateTime.now().toIso8601String(),
        'image': 'https://picsum.photos/800/400?random=1',
        'author': '1'
      },
      {
        'id': '2',
        'title': 'New Partnership Announcement',
        'content': 'We are excited to announce our new strategic partnership!',
        'created': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'image': 'https://picsum.photos/800/400?random=2',
        'author': '2'
      },
      // Add more demo news as needed
    ]);
  }

  @override
  Future<List<Map<String, dynamic>>> getPosts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _demoPosts;
  }

  @override
  Future<List<Map<String, dynamic>>> getProfiles() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _demoProfiles;
  }

  @override
  Future<List<Map<String, dynamic>>> getNews() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _demoNews;
  }

  @override
  Future<Map<String, dynamic>> createNews(Map<String, dynamic> newsData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newNews = {
      ...newsData,
      'id': (_demoNews.length + 1).toString(),
      'created': DateTime.now().toIso8601String(),
    };
    _demoNews.add(newNews);
    return newNews;
  }

  @override
  Future<void> deleteNews(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _demoNews.removeWhere((news) => news['id'] == id);
  }

  @override
  Future<Map<String, dynamic>> updateNews(String id, Map<String, dynamic> newsData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _demoNews.indexWhere((news) => news['id'] == id);
    if (index != -1) {
      _demoNews[index] = {
        ..._demoNews[index],
        ...newsData,
      };
      return _demoNews[index];
    }
    throw Exception('News not found');
  }

  @override
  Future<String> uploadImage(String path) async {
    // Simulate image upload by returning a random placeholder image
    await Future.delayed(const Duration(milliseconds: 1000));
    final randomId = _random.nextInt(1000);
    return 'https://picsum.photos/800/400?random=$randomId';
  }

  @override
  Future<Map<String, dynamic>> createPost(Map<String, dynamic> postData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newPost = {
      ...postData,
      'id': (_demoPosts.length + 1).toString(),
    };
    _demoPosts.add(newPost);
    return newPost;
  }

  @override
  Future<void> deletePost(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _demoPosts.removeWhere((post) => post['id'] == id);
  }

  @override
  Future<Map<String, dynamic>> updatePost(String id, Map<String, dynamic> postData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _demoPosts.indexWhere((post) => post['id'] == id);
    if (index != -1) {
      _demoPosts[index] = {
        ..._demoPosts[index],
        ...postData,
      };
      return _demoPosts[index];
    }
    throw Exception('Post not found');
  }

  @override
  Future<Map<String, dynamic>> createProfile(Map<String, dynamic> profileData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final profile = {
      ...profileData,
      'id': (_demoProfiles.length + 1).toString(),
    };
    _demoProfiles.add(profile);
    return profile;
  }
}