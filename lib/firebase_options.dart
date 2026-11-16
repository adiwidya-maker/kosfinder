// File ini di-generate oleh FlutterFire CLI
// Jalankan: flutterfire configure untuk memperbarui dengan kredensial project Firebase Anda
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForWebPlatform',
    appId: '1:1234567890:web:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'kosfinder-demo',
    authDomain: 'kosfinder-demo.firebaseapp.com',
    storageBucket: 'kosfinder-demo.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-TrgxAbpcAG3FUrLwPjRv2arOqjidgew',
    appId: '1:129705915058:android:5d1b0a103a82f05fb3cfab',
    messagingSenderId: '129705915058',
    projectId: 'kosfinder-c9763',
    storageBucket: 'kosfinder-c9763.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForIOSPlatform',
    appId: '1:1234567890:ios:abcdef123456',
    messagingSenderId: '1234567890',
    projectId: 'kosfinder-c9763',
    storageBucket: 'kosfinder-c9763.appspot.com',
    iosBundleId: 'com.example.kosfinder',
  );
}
