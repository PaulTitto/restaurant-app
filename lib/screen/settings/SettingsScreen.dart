import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
      ),
      body: ListView(
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return SwitchListTile(
                value: themeProvider.themeMode == ThemeMode.dark,
                title: Text(
                  themeProvider.themeMode == ThemeMode.dark ? "Dark Mode" : "Light Mode",
                ),
                onChanged: (bool value) {
                  themeProvider.setTheme(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
                secondary: const Icon(Icons.brightness_6),
              );
            },
          ),


        ],
      ),
    );
  }
}
