import 'package:card_scanner/models/id_card_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/id_card_data.dart';
import '../services/text_recognition_service.dart';
import '../repositories/id_card_repository.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final TextRecognitionService _recognitionService = TextRecognitionService();
  final IdCardRepository _repository = IdCardRepository();
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;
  List<IdCardData> _scannedIds = [];

  @override
  void initState() {
    super.initState();
    _loadScannedIds();
  }

  Future<void> _loadScannedIds() async {
    try {
      final ids = await _repository.getAllIdCards();
      setState(() {
        _scannedIds = ids;
      });
    } catch (e) {
      _showError('Error loading scanned IDs: $e');
    }
  }

  Future<void> _scanImage() async {
    try {
      setState(() => _isProcessing = true);

      // Pick image from camera
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) {
        setState(() => _isProcessing = false);
        return;
      }

      // Process the image
      final IdCardData? idData =
          await _recognitionService.processImage(image.path);

      if (idData != null) {
        // Save to Firebase
        await _repository.saveIdCard(idData);
        await _loadScannedIds();
        _showSuccess('ID scanned and saved successfully!');
      } else {
        _showError('Could not extract ID information from the image');
      }
    } catch (e) {
      _showError('Error scanning ID: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _recognitionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pakistani CNIC Scanner'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing image...'),
                ],
              ),
            )
          : _buildScannedList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _isProcessing ? null : _scanImage,
        tooltip: 'Scan ID',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _buildScannedList() {
    if (_scannedIds.isEmpty) {
      return const Center(
        child: Text('No scanned IDs yet. Tap the camera button to scan.'),
      );
    }

    return ListView.builder(
      itemCount: _scannedIds.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final id = _scannedIds[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(id.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Card Type: ${id.cardType}'),
                Text('ID: ${id.idNumber}'),
                if (id.fatherName.isNotEmpty)
                  Text('Father Name: ${id.fatherName}'),
                if (id.nationality.isNotEmpty)
                  Text('Nationality: ${id.nationality}'),
                if (id.gender.isNotEmpty) Text('Gender: ${id.gender}'),
                if (id.dateOfBirth.isNotEmpty) Text('DOB: ${id.dateOfBirth}'),
                if (id.issueDate.isNotEmpty)
                  Text('Issue Date: ${id.issueDate}'),
                if (id.expiryDate.isNotEmpty) Text('Expiry: ${id.expiryDate}'),
              ],
            ),
            trailing: Text(
              id.scannedAt.toString().split('.')[0],
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
