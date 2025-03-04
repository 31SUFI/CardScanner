# ID Card Scanner App 🆔

A Flutter-based mobile application that uses Machine Learning Kit for optical character recognition (OCR) to scan and extract information from Pakistani National Identity Cards (CNIC). The app stores the extracted data in Firebase Realtime Database for easy access and management.

## Features ✨

1. **Smart Card Detection**
   - Real-time camera feed for instant card capture
   - Automatic text recognition using Google ML Kit
   - Support for both front and back sides of CNIC

2. **Data Extraction**
   - Extracts key information including:
     - CNIC Number
     - Name
     - Father's Name
     - Gender
     - Date of Birth
     - Issue Date
     - Expiry Date
   - Intelligent text parsing and formatting
   - Handles both English and Urdu text

3. **User Experience**
   - Clean, modern Material Design interface
   - Real-time scanning feedback
   - List view of all scanned cards
   - Easy-to-read card details display

4. **Data Management**
   - Firebase Realtime Database integration
   - Secure data storage
   - Real-time data synchronization
   - Offline support

## Implementation Details 💻

### ML Kit Integration
- Uses `google_mlkit_text_recognition` for OCR
- Optimized text extraction algorithms
- Robust error handling

### Firebase Integration
- Real-time database for data storage
- Efficient data structure for quick retrieval
- Secure data access rules

### Camera Implementation
- Uses `image_picker` for photo capture
- Optimized image processing
- Automatic image quality assessment

## Getting Started 🚀

1. **Clone the Repository**
```bash
git clone https://github.com/31SUFI/CardScanner.git
```

2. **Set Up Firebase**
- Create a new Firebase project
- Add your `google-services.json` to the Android app
- Configure Firebase in the Flutter project

3. **Install Dependencies**
```bash
flutter pub get
```

4. **Run the App**
```bash
flutter run
```

## Dependencies 🧩
```yaml
dependencies:
  flutter:
    sdk: flutter
   firebase_core: ^2.25.4
  firebase_auth: ^4.17.4
  cloud_firestore: ^4.15.4
  firebase_storage: ^11.6.5
  firebase_database: ^10.4.5
  google_mlkit_text_recognition: ^0.14.0
  image_picker: ^1.0.7
  intl: ^0.19.0

```

## Technical Requirements 📱
- Android: SDK 21 or later
- Camera permission
- Internet connection for Firebase sync
- Google Play Services for ML Kit

## Architecture 🏗️

The app follows a clean architecture pattern with:

- **Screens**: UI layer (`scanner_screen.dart`)
- **Services**: Business logic layer (`text_recognition_service.dart`)
- **Models**: Data layer (`id_card_data.dart`)
- **Repositories**: Data management (`id_card_repository.dart`)

## Contributing 🤝

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create your feature branch
```bash
git checkout -b feature/AmazingFeature
```
3. Commit your changes
```bash
git commit -m 'Add some AmazingFeature'
```
4. Push to the branch
```bash
git push origin feature/AmazingFeature
```
5. Open a Pull Request

## Acknowledgments 🙏
- Google ML Kit for text recognition capabilities
- Firebase for real-time data storage


## Support 💬
For support, email msufiyan.dev@gmail.com or open an issue in the repository.
