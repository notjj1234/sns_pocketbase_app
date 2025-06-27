import '../services/data_service.dart';
import '../services/demo_data_service.dart';

class AppConfig {
  static bool isDemoMode = true;
  static DataService get dataService => DemoDataService();
  
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