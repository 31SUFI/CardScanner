import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/id_card_data.dart';

class TextRecognitionService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<IdCardData?> processImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFile(File(imagePath));
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      // Debug: Print all recognized text
      print('Recognized Text Blocks:');
      for (TextBlock block in recognizedText.blocks) {
        print('Block: ${block.text}');
        for (TextLine line in block.lines) {
          print('  Line: ${line.text}');
        }
      }

      return _extractPakistaniCNICData(recognizedText);
    } catch (e) {
      print('Error processing image: $e');
      return null;
    }
  }

  IdCardData? _extractPakistaniCNICData(RecognizedText recognizedText) {
    try {
      String idNumber = '';
      String name = '';
      String fatherName = '';
      String dateOfBirth = '';
      String expiryDate = '';
      String gender = '';
      String issueDate = '';

      // Process each line to find fields
      List<TextLine> allLines = [];
      for (TextBlock block in recognizedText.blocks) {
        allLines.addAll(block.lines);
      }

      for (int i = 0; i < allLines.length; i++) {
        String text = allLines[i].text.trim();
        String lowerText = text.toLowerCase();

        // Name extraction
        if (lowerText.startsWith('name')) {
          // Try to get name from current line
          name = text
              .replaceFirst(RegExp(r'Name\s*:?', caseSensitive: false), '')
              .trim();

          // If name is empty or too short, look at next line
          if (name.isEmpty && i + 1 < allLines.length) {
            String nextLine = allLines[i + 1].text.trim();
            if (!_isFieldLabel(nextLine)) {
              name = nextLine;
            }
          }
        }

        // Father Name extraction
        if (lowerText.startsWith('father')) {
          // Try to get father name from current line
          fatherName = text
              .replaceFirst(
                  RegExp(r'Father\s*Name\s*:?', caseSensitive: false), '')
              .trim();

          // If father name is empty or too short, look at next line
          if (fatherName.isEmpty && i + 1 < allLines.length) {
            String nextLine = allLines[i + 1].text.trim();
            if (!_isFieldLabel(nextLine)) {
              fatherName = nextLine;
            }
          }
        }

        // Gender extraction
        if (lowerText.contains('gender')) {
          String genderText = text
              .replaceFirst(RegExp(r'Gender\s*:?', caseSensitive: false), '')
              .trim();
          if (genderText.contains('M')) {
            gender = 'Male';
          } else if (genderText.contains('F')) {
            gender = 'Female';
          }

          // If no gender found in current line, check next line
          if (gender.isEmpty && i + 1 < allLines.length) {
            String nextLine = allLines[i + 1].text.trim();
            if (nextLine.contains('M')) {
              gender = 'Male';
            } else if (nextLine.contains('F')) {
              gender = 'Female';
            }
          }
        }

        // CNIC Number extraction
        if (_isPakistaniCNIC(text)) {
          idNumber = _extractPakistaniCNIC(text);
        }

        // Date of Birth extraction
        if (lowerText.contains('birth')) {
          dateOfBirth = _extractDate(text);
          if (dateOfBirth.isEmpty && i + 1 < allLines.length) {
            dateOfBirth = _extractDate(allLines[i + 1].text);
          }
        }

        // Issue Date extraction
        if (lowerText.contains('issue')) {
          issueDate = _extractDate(text);
          if (issueDate.isEmpty && i + 1 < allLines.length) {
            issueDate = _extractDate(allLines[i + 1].text);
          }
        }

        // Expiry Date extraction
        if (lowerText.contains('expiry')) {
          expiryDate = _extractDate(text);
          if (expiryDate.isEmpty && i + 1 < allLines.length) {
            expiryDate = _extractDate(allLines[i + 1].text);
          }
        }
      }

      // Clean up names
      name = _cleanupName(name);
      fatherName = _cleanupName(fatherName);

      print('Extracted Data:');
      print('ID Number: $idNumber');
      print('Name: $name');
      print('Father Name: $fatherName');
      print('Gender: $gender');
      print('Date of Birth: $dateOfBirth');
      print('Issue Date: $issueDate');
      print('Expiry Date: $expiryDate');

      if (idNumber.isNotEmpty) {
        return IdCardData(
          idNumber: idNumber,
          name: name,
          fatherName: fatherName,
          nationality: 'Pakistani',
          dateOfBirth: dateOfBirth,
          expiryDate: expiryDate,
          gender: gender,
          issueDate: issueDate,
          cardType: 'Pakistani CNIC',
          scannedAt: DateTime.now(),
        );
      }
    } catch (e) {
      print('Error extracting data: $e');
    }
    return null;
  }

  bool _isFieldLabel(String text) {
    text = text.toLowerCase();
    return text.contains('name:') ||
        text.contains('father') ||
        text.contains('gender') ||
        text.contains('identity') ||
        text.contains('birth') ||
        text.contains('issue') ||
        text.contains('expiry') ||
        text.contains('signature');
  }

  String _cleanupName(String name) {
    if (name.isEmpty) return name;

    // Remove common field markers and noise
    name = name.replaceAll(
        RegExp(r'name|:|father|/|\(|\)', caseSensitive: false), '');

    // Remove extra whitespace and trim
    name = name.replaceAll(RegExp(r'\s+'), ' ').trim();

    return name;
  }

  bool _isPakistaniCNIC(String text) {
    return RegExp(r'\d{5}[-]?\d{7}[-]?\d{1}').hasMatch(text);
  }

  String _extractPakistaniCNIC(String text) {
    final match = RegExp(r'\d{5}[-]?\d{7}[-]?\d{1}').firstMatch(text);
    if (match == null) return '';

    String cnic = match.group(0) ?? '';
    // Ensure proper format with hyphens
    if (!cnic.contains('-')) {
      cnic =
          '${cnic.substring(0, 5)}-${cnic.substring(5, 12)}-${cnic.substring(12)}';
    }
    return cnic;
  }

  String _extractDate(String text) {
    // Try to find a date pattern in the text
    final datePattern = RegExp(r'\d{2}[./-]\d{2}[/.-]\d{4}');
    final match = datePattern.firstMatch(text);
    return match?.group(0) ?? '';
  }

  void dispose() {
    _textRecognizer.close();
  }
}
