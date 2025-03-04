class EmiratesIdData {
  final String idNumber;
  final String name;
  final String nationality;
  final String dateOfBirth;
  final String expiryDate;
  final DateTime scannedAt;

  EmiratesIdData({
    required this.idNumber,
    required this.name,
    required this.nationality,
    required this.dateOfBirth,
    required this.expiryDate,
    required this.scannedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'idNumber': idNumber,
      'name': name,
      'nationality': nationality,
      'dateOfBirth': dateOfBirth,
      'expiryDate': expiryDate,
      'scannedAt': scannedAt.toIso8601String(),
    };
  }

  factory EmiratesIdData.fromJson(Map<String, dynamic> json) {
    return EmiratesIdData(
      idNumber: json['idNumber'] ?? '',
      name: json['name'] ?? '',
      nationality: json['nationality'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      scannedAt: DateTime.parse(json['scannedAt']),
    );
  }
}
