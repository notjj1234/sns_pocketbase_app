import 'package:flutter/material.dart';
import 'package:sns_pocketbase_app/pages/feed/events/create_event_page.dart';
import 'package:sns_pocketbase_app/pages/feed/posts/create_home_post.dart';
import 'package:provider/provider.dart';
import 'package:sns_pocketbase_app/pages/settings/language_provider.dart';
import 'package:sns_pocketbase_app/utils/translations.dart';

class CreatePostPage extends StatelessWidget {
  final String userId;
  final String email;
  final VoidCallback onLogout;

  const CreatePostPage({super.key, required this.userId, required this.email, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    // Step 1, add translate function in the build of code
    String translate(BuildContext context, String key) {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      String currentLanguage = languageProvider.currentLanguage;
      return translations[currentLanguage]?[key] ?? key;
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 234, 241), // Light, subtle purple background color
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          translate(context, 'create_post'),
          style: TextStyle(color: Theme.of(context).textTheme.headlineLarge?.color),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateHomePostPage(
                        userId: userId,
                        email: email,
                        onLogout: onLogout,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: const Size(250, 60), // Set custom width and height
                ),
                child: Text(
                  translate(context, 'create_post'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => CreateEventPage(), // Placeholder for the create event page
              //       ),
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: const Color.fromARGB(255, 252, 76, 102), // Blush pink color
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30.0),
              //     ),
              //     minimumSize: const Size(250, 60), // Set custom width and height
              //   ),
              //   child: Text(
              //     translate(context, 'create_bec_news'),
              //     style: const TextStyle(
              //       color: Colors.white,
              //       fontSize: 16.0,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
