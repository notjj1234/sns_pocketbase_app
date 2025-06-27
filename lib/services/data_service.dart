abstract class DataService {
  Future<List<Map<String, dynamic>>> getPosts();
  Future<List<Map<String, dynamic>>> getProfiles();
  Future<List<Map<String, dynamic>>> getNews();
  Future<Map<String, dynamic>> createNews(Map<String, dynamic> newsData);
  Future<void> deleteNews(String id);
  Future<Map<String, dynamic>> updateNews(String id, Map<String, dynamic> newsData);
  Future<String> uploadImage(String path);
  Future<Map<String, dynamic>> createPost(Map<String, dynamic> postData);
  Future<void> deletePost(String id);
  Future<Map<String, dynamic>> updatePost(String id, Map<String, dynamic> postData);
  Future<Map<String, dynamic>> createProfile(Map<String, dynamic> profileData);
}