import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class FirebaseService {
  static Future<FirebaseApp> initialize() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        return Firebase.app();
      }
      return await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      if (e.toString().contains('duplicate-app')) {
        return Firebase.app();
      }
      throw Exception('Failed to initialize Firebase: $e');
    }
  }
}
