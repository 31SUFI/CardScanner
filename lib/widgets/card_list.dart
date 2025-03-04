import 'package:flutter/material.dart';
import '../models/card_data.dart';

class CardList extends StatelessWidget {
  final List<CardData> cards;
  final VoidCallback onRefresh;

  const CardList({
    super.key,
    required this.cards,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const Center(
        child: Text('No cards yet. Add some dummy data!'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                card.cardHolderName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${card.cardNumber} - ${card.expiryDate}'),
              trailing: Text(
                card.createdAt.toString().split('.')[0],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
