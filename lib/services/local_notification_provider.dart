import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_notification_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;

  LocalNotificationProvider(this.flutterNotificationService) {
    _loadReminderStatus();
    requestPermissions();

  }

  int _notificationId = 0;
  bool _reminderEnabled = false;
  bool get reminderEnabled => _reminderEnabled;

  bool? _permission = false;
  bool? get permission => _permission;

  List<PendingNotificationRequest> pendingNotificationRequests = [];


  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  Future<void> _loadReminderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _reminderEnabled = prefs.getBool('reminder_enabled') ?? false;
    notifyListeners();
  }

  Future<void> _saveReminderStatus(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminder_enabled', enabled);
  }

  Future<void> enableReminder() async {
    _notificationId += 1;
    await flutterNotificationService.scheduleDailyElevenAMNotification(
      id: _notificationId,
    );
    _reminderEnabled = true;
    await _saveReminderStatus(true);
    notifyListeners();
  }

  Future<void> disableReminder() async {
    await flutterNotificationService.cancelNotification(_notificationId);
    _reminderEnabled = false;
    await _saveReminderStatus(false);
    notifyListeners();
  }

  Future<void> checkPendingNotificationRequests(BuildContext context) async {
    pendingNotificationRequests =
    await flutterNotificationService.pendingNotificationRequests();
    notifyListeners();
  }
}
