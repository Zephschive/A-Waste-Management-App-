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
    apiKey: 'AIzaSyAgxt_81cdPBVNiBroSqwHUp5iZHgDi0lw',
    appId: '1:310153788618:web:82d1c0eea65888acc28833',
    messagingSenderId: '310153788618',
    projectId: 'wasteman-b8d2e',
    authDomain: 'wasteman-b8d2e.firebaseapp.com',
    storageBucket: 'wasteman-b8d2e.firebasestorage.app',
    measurementId: 'G-KJ47J6C9RY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD89FG_jciwoB4jhi3e_vf_c_wzs1T1-J4',
    appId: '1:310153788618:android:aa9103096f7878b0c28833',
    messagingSenderId: '310153788618',
    projectId: 'wasteman-b8d2e',
    storageBucket: 'wasteman-b8d2e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBhtdLHmsPc4WywGVVFToS3kK8VJSxZxD0',
    appId: '1:310153788618:ios:97f27642fea5e839c28833',
    messagingSenderId: '310153788618',
    projectId: 'wasteman-b8d2e',
    storageBucket: 'wasteman-b8d2e.firebasestorage.app',
    iosBundleId: 'com.example.wasteMangementApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBhtdLHmsPc4WywGVVFToS3kK8VJSxZxD0',
    appId: '1:310153788618:ios:97f27642fea5e839c28833',
    messagingSenderId: '310153788618',
    projectId: 'wasteman-b8d2e',
    storageBucket: 'wasteman-b8d2e.firebasestorage.app',
    iosBundleId: 'com.example.wasteMangementApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAgxt_81cdPBVNiBroSqwHUp5iZHgDi0lw',
    appId: '1:310153788618:web:baa34bbbed59760ac28833',
    messagingSenderId: '310153788618',
    projectId: 'wasteman-b8d2e',
    authDomain: 'wasteman-b8d2e.firebaseapp.com',
    storageBucket: 'wasteman-b8d2e.firebasestorage.app',
    measurementId: 'G-4TR1QMSQ3Y',
  );
}

