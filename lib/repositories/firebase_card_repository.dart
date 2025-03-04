import 'package:firebase_database/firebase_database.dart';
import '../models/card_data.dart';
import 'card_repository.dart';

class FirebaseCardRepository implements CardRepository {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('cards');

  @override
  Future<void> saveCard(CardData card) async {
    try {
      await _database.child(card.id).set(card.toJson());
    } catch (e) {
      throw Exception('Failed to save card: $e');
    }
  }

  @override
  Future<List<CardData>> getAllCards() async {
    try {
      final DataSnapshot snapshot = await _database.get();
      final List<CardData> cards = [];

      if (snapshot.value != null) {
        final Map<dynamic, dynamic> values =
            snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          cards.add(CardData.fromJson(Map<String, dynamic>.from(value)));
        });
      }

      return cards;
    } catch (e) {
      throw Exception('Failed to get cards: $e');
    }
  }

  @override
  Future<CardData?> getCard(String id) async {
    try {
      final DataSnapshot snapshot = await _database.child(id).get();
      if (snapshot.value == null) return null;

      return CardData.fromJson(
        Map<String, dynamic>.from(snapshot.value as Map),
      );
    } catch (e) {
      throw Exception('Failed to get card: $e');
    }
  }

  @override
  Future<void> updateCard(CardData card) async {
    try {
      await _database.child(card.id).update(card.toJson());
    } catch (e) {
      throw Exception('Failed to update card: $e');
    }
  }

  @override
  Future<void> deleteCard(String id) async {
    try {
      await _database.child(id).remove();
    } catch (e) {
      throw Exception('Failed to delete card: $e');
    }
  }
}
