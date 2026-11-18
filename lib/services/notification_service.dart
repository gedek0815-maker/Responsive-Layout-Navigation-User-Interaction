import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app_keys.dart';
import '../firebase_options.dart';

/// Background message handler (harus berupa top-level function di luar class)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('[BACKGROUND NOTIFICATION] ${message.notification?.title}');
    debugPrint('[BACKGROUND NOTIFICATION] ${message.notification?.body}');
  } catch (e) {
    debugPrint('Background handler error: $e');
  }
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String? currentToken;
  AuthorizationStatus? permissionStatus;

  /// Praktik 8: Meminta izin notifikasi
  Future<AuthorizationStatus> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      permissionStatus = settings.authorizationStatus;
      debugPrint('Notification permission: ${settings.authorizationStatus.name}');
      return settings.authorizationStatus;
    } catch (e) {
      debugPrint('Error requestPermission: $e');
      return AuthorizationStatus.notDetermined;
    }
  }

  /// Praktik 9: Mendapatkan FCM Token
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      currentToken = token;
      debugPrint('====================================');
      debugPrint('FCM Token: $token');
      debugPrint('====================================');
      return token;
    } catch (e) {
      debugPrint('Error getToken: $e');
      return null;
    }
  }

  /// Praktik 9: Mendengarkan perubahan token
  void listenTokenRefresh(void Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen((newToken) {
      currentToken = newToken;
      debugPrint('FCM Token diperbarui: $newToken');
      onRefresh(newToken);
    });
  }

  /// Praktik 9 (Opsional): Simpan token ke Supabase tabel device_tokens
  Future<void> saveTokenToSupabase(String token) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      await Supabase.instance.client.from('device_tokens').upsert({
        'token': token,
        'user_id': user.id,
        'platform': defaultTargetPlatform.name,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
      debugPrint('Token berhasil disimpan ke Supabase untuk user: ${user.id}');
    } catch (e) {
      debugPrint('Gagal simpan token ke Supabase: $e');
    }
  }

  /// Praktik 10: Inisialisasi lengkap notifikasi (Permission + Token + Foreground Listener)
  Future<void> init() async {
    await requestPermission();
    final token = await getToken();
    if (token != null) {
      await saveTokenToSupabase(token);
    }
    listenTokenRefresh(saveTokenToSupabase);

    // iOS presentation options
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Praktik 10: Listener saat aplikasi sedang aktif di Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FOREGROUND] Notification received');
      debugPrint('title: ${message.notification?.title}');
      debugPrint('body : ${message.notification?.body}');
      debugPrint('data : ${message.data}');

      final title = message.notification?.title ?? 'Notifikasi';
      final body = message.notification?.body ?? '';

      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('$title\n$body'),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.indigo,
        ),
      );
    });
  }
}
