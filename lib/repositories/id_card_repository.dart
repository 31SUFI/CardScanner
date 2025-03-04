import 'package:firebase_database/firebase_database.dart';
import '../models/id_card_data.dart';

class IdCardRepository {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('id_cards');

  Future<void> saveIdCard(IdCardData idData) async {
    try {
      final String key = _database.push().key!;
      await _database.child(key).set(idData.toJson());
    } catch (e) {
      throw Exception('Failed to save ID card: $e');
    }
  }

  Future<List<IdCardData>> getAllIdCards() async {
    try {
      final DataSnapshot snapshot = await _database.get();
      final List<IdCardData> ids = [];

      if (snapshot.value != null) {
        final Map<dynamic, dynamic> values =
            snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          ids.add(IdCardData.fromJson(Map<String, dynamic>.from(value)));
        });
      }

      return ids;
    } catch (e) {
      throw Exception('Failed to get ID cards: $e');
    }
  }

  Stream<List<IdCardData>> streamIdCards() {
    return _database.onValue.map((event) {
      final List<IdCardData> ids = [];
      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          ids.add(IdCardData.fromJson(Map<String, dynamic>.from(value)));
        });
      }
      return ids;
    });
  }

  // Get ID cards by type (Emirates or Pakistani)
  Future<List<IdCardData>> getIdCardsByType(String cardType) async {
    try {
      final DataSnapshot snapshot =
          await _database.orderByChild('cardType').equalTo(cardType).get();

      final List<IdCardData> ids = [];

      if (snapshot.value != null) {
        final Map<dynamic, dynamic> values =
            snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          ids.add(IdCardData.fromJson(Map<String, dynamic>.from(value)));
        });
      }

      return ids;
    } catch (e) {
      throw Exception('Failed to get $cardType cards: $e');
    }
  }
}
