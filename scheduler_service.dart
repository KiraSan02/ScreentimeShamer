import 'package:workmanager/workmanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'usage_service.dart';
import 'push_notification_service.dart';

class SchedulerService {
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      UsageService usageService = UsageService();
      PushNotificationService pushNotificationService = PushNotificationService();
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        int usageLimit = await usageService.getUsageLimit(user.uid);
        int minutesUsed = await usageService.getMinutesUsed(user.uid); // Assuming this method exists

        if (minutesUsed > usageLimit) {
          await pushNotificationService.sendNotification(user.uid);
        }
      }

      return Future.value(true);
    });
  }

  static void initialize() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    Workmanager().registerPeriodicTask(
      "1",
      "checkScreenTime",
      frequency: Duration(minutes: 10),
    );
  }
}
