// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'firebase_options.dart';

// ...


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
    apiKey: 'AIzaSyCv6nOv83Jm35ppe_P2XXjUS_Xnwvx2F3Q',
    appId: '1:1091283538081:web:109f96bd3eb661e7ebe0e0',
    messagingSenderId: '1091283538081',
    projectId: 'translate-and-learn-b14e3',
    authDomain: 'translate-and-learn-b14e3.firebaseapp.com',
    storageBucket: 'translate-and-learn-b14e3.appspot.com',
    measurementId: 'G-G6XCF91P3C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCpPVedYlt0Pb8ONo3E1VZh84_rag3mM-s',
    appId: '1:1091283538081:android:a36406dc9a4dd7aaebe0e0',
    messagingSenderId: '1091283538081',
    projectId: 'translate-and-learn-b14e3',
    storageBucket: 'translate-and-learn-b14e3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDIx55qPpitDB-EGce3OTX4M7OeG_oixSc',
    appId: '1:1091283538081:ios:7c7ab9ff8752fdd6ebe0e0',
    messagingSenderId: '1091283538081',
    projectId: 'translate-and-learn-b14e3',
    storageBucket: 'translate-and-learn-b14e3.appspot.com',
    iosBundleId: 'com.example.translateAndLearnApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDIx55qPpitDB-EGce3OTX4M7OeG_oixSc',
    appId: '1:1091283538081:ios:7c7ab9ff8752fdd6ebe0e0',
    messagingSenderId: '1091283538081',
    projectId: 'translate-and-learn-b14e3',
    storageBucket: 'translate-and-learn-b14e3.appspot.com',
    iosBundleId: 'com.example.translateAndLearnApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCv6nOv83Jm35ppe_P2XXjUS_Xnwvx2F3Q',
    appId: '1:1091283538081:web:e8b3f49687f5a392ebe0e0',
    messagingSenderId: '1091283538081',
    projectId: 'translate-and-learn-b14e3',
    authDomain: 'translate-and-learn-b14e3.firebaseapp.com',
    storageBucket: 'translate-and-learn-b14e3.appspot.com',
    measurementId: 'G-JDYW64MB67',
  );
}