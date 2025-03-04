import '../models/card_data.dart';

abstract class CardRepository {
  Future<void> saveCard(CardData card);
  Future<List<CardData>> getAllCards();
  Future<CardData?> getCard(String id);
  Future<void> updateCard(CardData card);
  Future<void> deleteCard(String id);
}
