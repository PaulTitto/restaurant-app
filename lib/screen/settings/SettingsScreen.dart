import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/local_notification_provider.dart';
import '../theme_provider.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // SWITCH THEME
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return SwitchListTile(
                value: themeProvider.themeMode == ThemeMode.dark,
                title: Text(
                  themeProvider.themeMode == ThemeMode.dark
                      ? "Dark Mode"
                      : "Light Mode",
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

          // const Divider(),

          Consumer<LocalNotificationProvider>(
            builder: (context, notificationProvider, _) {
              return SwitchListTile(
                value: notificationProvider.reminderEnabled,
                title: const Text('Enable Daily Lunch Reminder'),
                subtitle: const Text('Reminder at 11:00 AM'),
                onChanged: (bool value) async {
                  if (value) {
                    await notificationProvider.enableReminder();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reminder Enabled')),
                    );
                  } else {
                    await notificationProvider.disableReminder();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reminder Disabled')),
                    );
                  }
                },
                secondary: const Icon(Icons.notifications_active),
              );
            },
          ),
        ],
      ),
    );
  }
}
