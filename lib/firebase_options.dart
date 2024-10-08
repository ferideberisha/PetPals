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
    apiKey: 'AIzaSyCnKC-8GTDmbTjipRzfgky9LkSknxho9wA',
    appId: '1:341587754190:web:b7ecec566e543124efe49f',
    messagingSenderId: '341587754190',
    projectId: 'petpals-96da1',
    authDomain: 'petpals-96da1.firebaseapp.com',
    storageBucket: 'petpals-96da1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8IHN6i0LPf2PYinqsQiraTAHKHJA-Yns',
    appId: '1:341587754190:android:33c0b55d6c0145a0efe49f',
    messagingSenderId: '341587754190',
    projectId: 'petpals-96da1',
    storageBucket: 'petpals-96da1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOC-v-72N2nMnytdQSDyWU4MsdB1RXa3g',
    appId: '1:341587754190:ios:ffcab379d3a0b680efe49f',
    messagingSenderId: '341587754190',
    projectId: 'petpals-96da1',
    storageBucket: 'petpals-96da1.appspot.com',
    iosBundleId: 'com.example.petpals',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCOC-v-72N2nMnytdQSDyWU4MsdB1RXa3g',
    appId: '1:341587754190:ios:ffcab379d3a0b680efe49f',
    messagingSenderId: '341587754190',
    projectId: 'petpals-96da1',
    storageBucket: 'petpals-96da1.appspot.com',
    iosBundleId: 'com.example.petpals',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCnKC-8GTDmbTjipRzfgky9LkSknxho9wA',
    appId: '1:341587754190:web:b7ecec566e543124efe49f',
    messagingSenderId: '341587754190',
    projectId: 'petpals-96da1',
    authDomain: 'petpals-96da1.firebaseapp.com',
    storageBucket: 'petpals-96da1.appspot.com',
  );
}
