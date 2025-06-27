import 'package:flutter/material.dart';


//SortedPostPage
class SortedPostPage extends StatelessWidget {
  final List<dynamic> profiles;

  const SortedPostPage({super.key, required this.profiles});

  @override
  Widget build(BuildContext context) {
    return profiles.isEmpty
        ? const Center(
            child: Text(
              'No profiles available',
              style: TextStyle(color: Colors.white),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> profile = profiles[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    profile['user_id'][0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  profile['username'] ?? 'Unknown User',
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),                ),
                subtitle: Text(
                  profile['bio'] ?? 'No bio available',
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                onTap: () {
                  // Will add functionality to view more details about the user later
                },
              );
            },
          );
  }
}
