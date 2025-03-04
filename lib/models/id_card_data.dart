class IdCardData {
  final String idNumber;
  final String name;
  final String fatherName;
  final String nationality;
  final String dateOfBirth;
  final String expiryDate;
  final String gender;
  final String issueDate;
  final String cardType; // 'Emirates ID' or 'Pakistani CNIC'
  final DateTime scannedAt;

  IdCardData({
    required this.idNumber,
    required this.name,
    this.fatherName = '',
    this.nationality = '',
    this.dateOfBirth = '',
    this.expiryDate = '',
    this.gender = '',
    this.issueDate = '',
    required this.cardType,
    required this.scannedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'idNumber': idNumber,
      'name': name,
      'fatherName': fatherName,
      'nationality': nationality,
      'dateOfBirth': dateOfBirth,
      'expiryDate': expiryDate,
      'gender': gender,
      'issueDate': issueDate,
      'cardType': cardType,
      'scannedAt': scannedAt.toIso8601String(),
    };
  }

  factory IdCardData.fromJson(Map<String, dynamic> json) {
    return IdCardData(
      idNumber: json['idNumber'] ?? '',
      name: json['name'] ?? '',
      fatherName: json['fatherName'] ?? '',
      nationality: json['nationality'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      gender: json['gender'] ?? '',
      issueDate: json['issueDate'] ?? '',
      cardType: json['cardType'] ?? 'Unknown',
      scannedAt: DateTime.parse(json['scannedAt']),
    );
  }
}
