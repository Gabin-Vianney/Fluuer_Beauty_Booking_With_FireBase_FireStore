import 'package:firebasebookingapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Change theme mode'),
              trailing: IconButton(
                icon: themeProvider.isDarkMode
                    ? const Icon(Icons.dark_mode, color: primaryColor,) // Icon for dark mode
                    : const Icon(Icons.light_mode,color: primaryColor,), // Icon for light mode
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
