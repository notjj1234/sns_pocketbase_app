import '../services/data_service.dart';
import '../services/demo_data_service.dart';
import '../services/pocketbase_service.dart';
import 'pocketbase_config.dart';

class AppConfig {
  // Set to false and configure PocketBaseConfig to use real PocketBase backend
  static bool isDemoMode = true;
  
  // This will automatically use PocketBase service if isDemoMode is false and PocketBase is configured
  static DataService get dataService {
    if (!isDemoMode && PocketBaseConfig.isConfigured()) {
      try {
        return PocketBaseService();
      } catch (e) {
        print('Warning: Failed to initialize PocketBase service: $e');
        print('Falling back to demo mode...');
        return DemoDataService();
      }
    }
    return DemoDataService();
  }
  
  // App-wide configuration
  static const String appName = 'Social Network Template';
  static const String defaultLanguage = 'en';
  
  // Feature flags
  static const bool enableImageUploads = true;
  static const bool enableComments = true;
  static const bool enableLikes = true;
  
  // UI Configuration
  static const double maxImageWidth = 800.0;
  static const double maxImageHeight = 600.0;
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
}