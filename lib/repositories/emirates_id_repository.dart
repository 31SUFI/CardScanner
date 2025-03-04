import 'package:firebase_database/firebase_database.dart';
import '../models/emirates_id_data.dart';

class EmiratesIdRepository {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('emirates_ids');

  Future<void> saveEmiratesId(EmiratesIdData idData) async {
    try {
      final String key = _database.push().key!;
      await _database.child(key).set(idData.toJson());
    } catch (e) {
      throw Exception('Failed to save Emirates ID: $e');
    }
  }

  Future<List<EmiratesIdData>> getAllEmiratesIds() async {
    try {
      final DataSnapshot snapshot = await _database.get();
      final List<EmiratesIdData> ids = [];

      if (snapshot.value != null) {
        final Map<dynamic, dynamic> values =
            snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          ids.add(EmiratesIdData.fromJson(Map<String, dynamic>.from(value)));
        });
      }

      return ids;
    } catch (e) {
      throw Exception('Failed to get Emirates IDs: $e');
    }
  }

  Stream<List<EmiratesIdData>> streamEmiratesIds() {
    return _database.onValue.map((event) {
      final List<EmiratesIdData> ids = [];
      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          ids.add(EmiratesIdData.fromJson(Map<String, dynamic>.from(value)));
        });
      }
      return ids;
    });
  }
}
