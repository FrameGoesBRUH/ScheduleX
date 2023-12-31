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
    apiKey: 'AIzaSyBOq_2o-UbPb37os6gAKUYKUHRkMVNYo3Q',
    appId: '1:89475562539:web:cfdfcc550fa998ec233e6e',
    messagingSenderId: '89475562539',
    projectId: 'schedulex-2f7cf',
    authDomain: 'schedulex-2f7cf.firebaseapp.com',
    storageBucket: 'schedulex-2f7cf.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyALdYnepAG55Gey4sl4pkD3bI2OlGQjTYE',
    appId: '1:89475562539:android:f420fb106731d5fd233e6e',
    messagingSenderId: '89475562539',
    projectId: 'schedulex-2f7cf',
    storageBucket: 'schedulex-2f7cf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA4S2bOqTt3MGRWkNR6nYeuR3kJ3P5UmEA',
    appId: '1:89475562539:ios:b4970d243aec39df233e6e',
    messagingSenderId: '89475562539',
    projectId: 'schedulex-2f7cf',
    storageBucket: 'schedulex-2f7cf.appspot.com',
    iosClientId: '89475562539-frk7k087ohb8orqchjlv74f009gk2hjo.apps.googleusercontent.com',
    iosBundleId: 'com.example.schedulex',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA4S2bOqTt3MGRWkNR6nYeuR3kJ3P5UmEA',
    appId: '1:89475562539:ios:47484584fc76df6a233e6e',
    messagingSenderId: '89475562539',
    projectId: 'schedulex-2f7cf',
    storageBucket: 'schedulex-2f7cf.appspot.com',
    iosClientId: '89475562539-oodpl3uv6pf22bg90vf19vpe7h83eqnc.apps.googleusercontent.com',
    iosBundleId: 'com.example.schedulex.RunnerTests',
  );
}
