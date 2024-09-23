import 'package:firebasebookingapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider//theme_provider.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Change theme mode'),
              trailing: IconButton(
                icon: const Icon(Icons.brightness_6),
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
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
