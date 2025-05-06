import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme_provider.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Tema'),
      ),
      body: ListView(
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('Terang'),
            value: ThemeMode.light,
            groupValue: themeProvider.themeMode,
            onChanged: (value) {
              if (value != null) {
                themeProvider.toggleTheme(false);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Gelap'),
            value: ThemeMode.dark,
            groupValue: themeProvider.themeMode,
            onChanged: (value) {
              if (value != null) {
                themeProvider.toggleTheme(true);
              }
            },
          ),
        ],
      ),
    );
  }
}
