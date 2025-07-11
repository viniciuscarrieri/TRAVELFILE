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
    apiKey: 'AIzaSyDxbRGoU0x246nHUQ6QXlf8XsMTx8DGR8w',
    appId: '1:761760624263:web:b6454ac3d4660577bbd222',
    messagingSenderId: '761760624263',
    projectId: 'viagens-7973d',
    authDomain: 'viagens-7973d.firebaseapp.com',
    storageBucket: 'viagens-7973d.firebasestorage.app',
    measurementId: 'G-Y720Q9S3RX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwWrPynvL-PlP6dbEjoyj0MKsfesXSvA0',
    appId: '1:761760624263:android:d51aea2d7310140dbbd222',
    messagingSenderId: '761760624263',
    projectId: 'viagens-7973d',
    storageBucket: 'viagens-7973d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDcpJEwN6sxcMVrZCc6FM8aDpldCOCWRFw',
    appId: '1:761760624263:ios:3d9af5bd081b7492bbd222',
    messagingSenderId: '761760624263',
    projectId: 'viagens-7973d',
    storageBucket: 'viagens-7973d.firebasestorage.app',
    iosBundleId: 'com.example.travelfile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDcpJEwN6sxcMVrZCc6FM8aDpldCOCWRFw',
    appId: '1:761760624263:ios:3d9af5bd081b7492bbd222',
    messagingSenderId: '761760624263',
    projectId: 'viagens-7973d',
    storageBucket: 'viagens-7973d.firebasestorage.app',
    iosBundleId: 'com.example.travelfile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAQwl-pI3wbmL9IbYGHfx4cHOl73pj2tEo',
    appId: '1:761760624263:web:e15f992487add323bbd222',
    messagingSenderId: '761760624263',
    projectId: 'viagens-7973d',
    authDomain: 'viagens-7973d.firebaseapp.com',
    storageBucket: 'viagens-7973d.firebasestorage.app',
    measurementId: 'G-3EVN117T36',
  );
}
