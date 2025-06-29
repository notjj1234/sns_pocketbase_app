import 'package:pocketbase/pocketbase.dart';
import '../config/pocketbase_config.dart';
import 'data_service.dart';

class PocketBaseService implements DataService {
  late final PocketBase _pb;
  
  PocketBaseService() {
    if (!PocketBaseConfig.isConfigured()) {
      throw Exception(
        'PocketBase is not configured. Please update the baseUrl in lib/config/pocketbase_config.dart'
      );
    }
    _pb = PocketBase(PocketBaseConfig.baseUrl);
  }

  // Implementation example for one method
  @override
  Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      final records = await _pb
          .collection(PocketBaseConfig.postsCollection)
          .getFullList();
      
      return records.map((record) => record.data).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  // TODO: Implement other DataService methods
  @override
  Future<List<Map<String, dynamic>>> getProfiles() async {
    throw UnimplementedError('Implement this method with your PocketBase logic');
  }

  @override
  Future<List<Map<String, dynamic>>> getNews() async {
    throw UnimplementedError('Implement this method with your PocketBase logic');
  }

  @override
  Future<Map<String, dynamic>> createNews(Map<String, dynamic> newsData) async {
    throw UnimplementedError('Implement this method with your PocketBase logic');
  }

  @override
  Future<void> deleteNews(String id) async {
    throw UnimplementedError('Implement this method with your PocketBase logic');
  }

  @override
  Future<Map<String, dynamic>> updateNews(String id, Map<String, dynamic> newsData) async {
    throw UnimplementedError('Implement this method with your PocketBase logic');
  }

  @override
  Future<String> uploadImage(String path) async {
    throw UnimplementedError('Implement this method with your PocketBase logic');
  }

  @override
  Future<Map<String, dynamic>> createPost(Map<String, dynamic> postData) async {
    throw UnimplementedError('Implement this method with your PocketBase logic');
  }

  @override
  Future<void> deletePost(String id) async {
    throw UnimplementedError('Implement this method with your PocketBase logic');
  }

  @override
  Future<Map<String, dynamic>> updatePost(String id, Map<String, dynamic> postData) async {
    throw UnimplementedError('Implement this method with your PocketBase logic');
  }

  @override
  Future<Map<String, dynamic>> createProfile(Map<String, dynamic> profileData) async {
    throw UnimplementedError('Implement this method with your PocketBase logic');
  }
}
