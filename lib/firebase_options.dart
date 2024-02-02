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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCFOEM6zWc1_qpTcKnwiglGdcokKWz48f8',
    appId: '1:14844084599:web:91d892d0c336a32d126172',
    messagingSenderId: '14844084599',
    projectId: 'cinematix-1f427',
    authDomain: 'cinematix-1f427.firebaseapp.com',
    storageBucket: 'cinematix-1f427.appspot.com',
    measurementId: 'G-XWWPQ1ML1D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYiC5yFG_jcr2veXgXtHC-q3PYdiqLYM4',
    appId: '1:14844084599:android:ec93c5ca597abb62126172',
    messagingSenderId: '14844084599',
    projectId: 'cinematix-1f427',
    storageBucket: 'cinematix-1f427.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCAvyTONMUnQhivAV69WChB2QooYuudyc',
    appId: '1:14844084599:ios:877dfb66ddbf7744126172',
    messagingSenderId: '14844084599',
    projectId: 'cinematix-1f427',
    storageBucket: 'cinematix-1f427.appspot.com',
    iosBundleId: 'com.example.cinematic',
  );
}
