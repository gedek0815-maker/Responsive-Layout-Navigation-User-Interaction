// File konfigurasi Firebase untuk KosFinder
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_7tKHVqZmOwBo9u-Cv7okUk9KKRQ6edM',
    appId: '1:165625087160:android:02ea37b0be8faae240a04d',
    messagingSenderId: '165625087160',
    projectId: 'kosfinder-krisna',
    storageBucket: 'kosfinder-krisna.firebasestorage.app',
  );
}
