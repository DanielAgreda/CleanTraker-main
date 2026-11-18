// PLACEHOLDER: este archivo se sobrescribe al ejecutar `flutterfire configure`
// (ver README). Reemplaza los valores REPLACE_ME con los de tu proyecto Firebase.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static const FirebaseOptions currentPlatform = web;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'REPLACE_ME',
    authDomain: 'REPLACE_ME.firebaseapp.com',
    storageBucket: 'REPLACE_ME.firebasestorage.app',
  );
}
