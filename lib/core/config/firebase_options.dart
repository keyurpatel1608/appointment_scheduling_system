// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

// You can find the documentation for this file here:
// https://firebase.google.com/docs/flutter/setup#configure-an-app

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      // case TargetPlatform.web:
      //   throw UnsupportedError(
      //     'DefaultFirebaseOptions have not been configured for web - use a web-specific implementation',
      //   );
      //   return web;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDg2q4WvI4i-c_JtxqUcgKgxdAXl_bt8Pw',
    appId: '1:394911396198:android:4cac2c8596eae33c7698a7',
    messagingSenderId: '394911396198',
    projectId: 'appointment-scheduling-app-dev',
    storageBucket: 'appointment-scheduling-app-dev.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDg2q4WvI4i-c_JtxqUcgKgxdAXl_bt8Pw',
    appId: '1:394911396198:ios:321abc456def789',
    messagingSenderId: '394911396198',
    projectId: 'appointment-scheduling-app-dev',
    storageBucket: 'appointment-scheduling-app-dev.firebasestorage.app',
    iosBundleId: 'com.aksharraj.appointement_scheduling_app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDg2q4WvI4i-c_JtxqUcgKgxdAXl_bt8Pw',
    appId: '1:394911396198:macos:321abc456def789',
    messagingSenderId: '394911396198',
    projectId: 'appointment-scheduling-app-dev',
    storageBucket: 'appointment-scheduling-app-dev.firebasestorage.app',
    iosBundleId: 'com.aksharraj.appointement_scheduling_app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDg2q4WvI4i-c_JtxqUcgKgxdAXl_bt8Pw',
    appId: '1:394911396198:web:321abc456def789',
    messagingSenderId: '394911396198',
    projectId: 'appointment-scheduling-app-dev',
    authDomain: 'appointment-scheduling-app-dev.firebaseapp.com',
    storageBucket: 'appointment-scheduling-app-dev.firebasestorage.app',
    measurementId: 'G-12345',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDg2q4WvI4i-c_JtxqUcgKgxdAXl_bt8Pw',
    appId: '1:394911396198:windows:321abc456def789',
    messagingSenderId: '394911396198',
    projectId: 'appointment-scheduling-app-dev',
    authDomain: 'appointment-scheduling-app-dev.firebaseapp.com',
    storageBucket: 'appointment-scheduling-app-dev.firebasestorage.app',
  );
}
