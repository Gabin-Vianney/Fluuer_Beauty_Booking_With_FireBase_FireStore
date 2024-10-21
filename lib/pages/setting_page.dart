import 'package:firebasebookingapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/theme_provider.dart';
import '../Provider/language_provider.dart';
import 'package:firebasebookingapp/gen_l10n/flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.settings), // Localized string
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
            ListTile(
              title: const Text('Change language'),
               trailing: DropdownButton<Locale>(
              value: languageProvider.locale,
              items: LanguageProvider.supportedLocales.map((locale) {
                return DropdownMenuItem(
                  value: locale,
                  child: Text(locale.languageCode == 'en'
                      ? 'English'
                      : 'Français'), // Add other languages as needed
                );
              }).toList(),
              onChanged: (Locale? locale) {
                if (locale != null) {
                  languageProvider.setLocale(locale);
                }
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
