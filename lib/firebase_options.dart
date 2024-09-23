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
    apiKey: 'AIzaSyAXnU_D7z7mPjgPmn0R25NvbAuypRde4Fw',
    appId: '1:610573022429:web:10873ca2382b4e71f95734',
    messagingSenderId: '610573022429',
    projectId: 'fir-test-bc61c',
    authDomain: 'fir-test-bc61c.firebaseapp.com',
    storageBucket: 'fir-test-bc61c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDD76OGAxJBPj9Tr5nzgBYBE0bujEbK6Vw',
    appId: '1:610573022429:android:8cdbfc0deb8b6a5af95734',
    messagingSenderId: '610573022429',
    projectId: 'fir-test-bc61c',
    storageBucket: 'fir-test-bc61c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCSWuhpKpHrESp1A7_8cwHYoRYKarb-H8E',
    appId: '1:610573022429:ios:a3566cd97fc78b4af95734',
    messagingSenderId: '610573022429',
    projectId: 'fir-test-bc61c',
    storageBucket: 'fir-test-bc61c.appspot.com',
    iosBundleId: 'com.example.firebasebookingapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCSWuhpKpHrESp1A7_8cwHYoRYKarb-H8E',
    appId: '1:610573022429:ios:a3566cd97fc78b4af95734',
    messagingSenderId: '610573022429',
    projectId: 'fir-test-bc61c',
    storageBucket: 'fir-test-bc61c.appspot.com',
    iosBundleId: 'com.example.firebasebookingapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAXnU_D7z7mPjgPmn0R25NvbAuypRde4Fw',
    appId: '1:610573022429:web:a039d09db7e635b5f95734',
    messagingSenderId: '610573022429',
    projectId: 'fir-test-bc61c',
    authDomain: 'fir-test-bc61c.firebaseapp.com',
    storageBucket: 'fir-test-bc61c.appspot.com',
  );
}