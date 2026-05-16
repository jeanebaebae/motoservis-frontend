import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final ApiClient _apiClient = ApiClient();

  static const String vapidKey = 'BJb7hC11HERhhtSQBGc2fRUA1_LuhtjzV-jGNERhJQOtIwkuYZjKUtv87horsJaYXJngvQrY1KFu5XGie0AvviY';

  Future<void> setupWebPushNotification() async {
    final settings = await _messaging.requestPermission();

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    final token = await _messaging.getToken(
      vapidKey: vapidKey,
    );

    if (token == null) return;

    await _apiClient.post(
      '${ApiConstants.baseUrl}/notifications/register-token',
      {
        'fcm_token': token,
        'platform': 'web',
      },
    );
  }
}