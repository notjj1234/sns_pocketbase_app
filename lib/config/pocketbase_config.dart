// Configuration for PocketBase connection
class PocketBaseConfig {
  // Replace this with your PocketBase server URL
  static const String baseUrl = 'http://your-pocketbase-url.com';
  
  // Optional: Configure additional PocketBase settings here
  static const int timeout = 30; // seconds
  
  // Collection names in your PocketBase instance
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';
  static const String commentsCollection = 'comments';
  static const String likesCollection = 'likes';
  static const String profilesCollection = 'profiles';
  
  // Validate PocketBase URL
  static bool isConfigured() {
    return baseUrl != 'http://your-pocketbase-url.com' && 
           baseUrl.startsWith('http');
  }
}
