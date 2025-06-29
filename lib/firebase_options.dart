// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB9mrRYH82jn-35SMRL9teo1cpmn0TzIWQ',
    appId: '1:258140062461:web:2911596f5a5e8a831ef494',
    messagingSenderId: '258140062461',
    projectId: 'radarkopi-bd6ad',
    authDomain: 'radarkopi-bd6ad.firebaseapp.com',
    storageBucket: 'radarkopi-bd6ad.firebasestorage.app',
    measurementId: 'G-X54ZEJ3YVN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA3TKPq_V2KRw9newXOC_MCL9QTbqBx3OI',
    appId: '1:258140062461:android:fe042e68fbee275d1ef494',
    messagingSenderId: '258140062461',
    projectId: 'radarkopi-bd6ad',
    storageBucket: 'radarkopi-bd6ad.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMz9JnEBYD3TtBMi-VMM6pkxa6MbX8TLM',
    appId: '1:258140062461:ios:a1acc808df4cb4f11ef494',
    messagingSenderId: '258140062461',
    projectId: 'radarkopi-bd6ad',
    storageBucket: 'radarkopi-bd6ad.firebasestorage.app',
    iosBundleId: 'com.example.kopiradar',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMz9JnEBYD3TtBMi-VMM6pkxa6MbX8TLM',
    appId: '1:258140062461:ios:a1acc808df4cb4f11ef494',
    messagingSenderId: '258140062461',
    projectId: 'radarkopi-bd6ad',
    storageBucket: 'radarkopi-bd6ad.firebasestorage.app',
    iosBundleId: 'com.example.kopiradar',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB9mrRYH82jn-35SMRL9teo1cpmn0TzIWQ',
    appId: '1:258140062461:web:670987ac3fdeb6cb1ef494',
    messagingSenderId: '258140062461',
    projectId: 'radarkopi-bd6ad',
    authDomain: 'radarkopi-bd6ad.firebaseapp.com',
    storageBucket: 'radarkopi-bd6ad.firebasestorage.app',
    measurementId: 'G-NLZL1PS64P',
  );
}
