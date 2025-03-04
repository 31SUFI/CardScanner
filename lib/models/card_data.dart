class CardData {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final DateTime createdAt;

  CardData({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.createdAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      id: json['id'],
      cardNumber: json['cardNumber'],
      cardHolderName: json['cardHolderName'],
      expiryDate: json['expiryDate'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
