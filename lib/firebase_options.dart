// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBT8GqcCBxvaFmYYRavJ3hLab1oraDix1E',
    appId: '1:501080543281:web:03325e5701430993b5c510',
    messagingSenderId: '501080543281',
    projectId: 'chat-application-71d39',
    authDomain: 'chat-application-71d39.firebaseapp.com',
    storageBucket: 'chat-application-71d39.appspot.com',
    measurementId: 'G-XDRRPQKJ8C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCR6QNaSd4hgTl7aAFnKhzSLqOs3rxli4w',
    appId: '1:501080543281:android:230ac866c325c22db5c510',
    messagingSenderId: '501080543281',
    projectId: 'chat-application-71d39',
    storageBucket: 'chat-application-71d39.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqiUAA0dLYN0E-k60_Vx_Ut6nL7plZLKs',
    appId: '1:501080543281:ios:5fb238dbd836fcacb5c510',
    messagingSenderId: '501080543281',
    projectId: 'chat-application-71d39',
    storageBucket: 'chat-application-71d39.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAqiUAA0dLYN0E-k60_Vx_Ut6nL7plZLKs',
    appId: '1:501080543281:ios:b67b829cb9291016b5c510',
    messagingSenderId: '501080543281',
    projectId: 'chat-application-71d39',
    storageBucket: 'chat-application-71d39.appspot.com',
    iosBundleId: 'com.example.chatApp.RunnerTests',
  );
}
