import 'package:flutter/material.dart';
import '../models/card_data.dart';
import '../repositories/firebase_card_repository.dart';
import '../services/firebase_service.dart';
import '../widgets/card_list.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _initialized = false;
  bool _error = false;
  String _errorMessage = '';
  FirebaseCardRepository? _cardRepository;
  List<CardData> _cards = [];

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    try {
      await FirebaseService.initialize();
      _cardRepository = FirebaseCardRepository();
      await _loadInitialData();
    } catch (e) {
      setState(() {
        _error = true;
        _errorMessage = e.toString();
      });
      print('Error initializing repository: $e');
    }
  }

  Future<void> _loadInitialData() async {
    try {
      await _loadCards();
      setState(() {
        _initialized = true;
        _error = false;
      });
    } catch (e) {
      setState(() {
        _error = true;
        _errorMessage = e.toString();
      });
      print('Error loading initial data: $e');
    }
  }

  Future<void> _loadCards() async {
    try {
      if (_cardRepository != null) {
        _cards = await _cardRepository!.getAllCards();
        setState(() {});
      }
    } catch (e) {
      print('Error loading cards: $e');
      rethrow;
    }
  }

  Future<void> _addDummyCard() async {
    if (_cardRepository == null) {
      _showError('Repository not initialized');
      return;
    }

    try {
      final card = CardData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cardNumber: '4111 1111 1111 1111',
        cardHolderName: 'John Doe',
        expiryDate: '12/25',
        createdAt: DateTime.now(),
      );

      await _cardRepository!.saveCard(card);
      await _loadCards();
    } catch (e) {
      print('Error adding dummy card: $e');
      _showError('Error adding card: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _retryInitialization() async {
    setState(() {
      _error = false;
      _initialized = false;
      _errorMessage = '';
    });
    await _initializeRepository();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return _buildErrorScreen();
    }

    if (!_initialized) {
      return _buildLoadingScreen();
    }

    return _buildMainScreen();
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Error initializing Firebase'),
            const SizedBox(height: 8),
            Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _retryInitialization,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildMainScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: CardList(
        cards: _cards,
        onRefresh: _loadCards,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDummyCard,
        tooltip: 'Add Dummy Card',
        child: const Icon(Icons.add),
      ),
    );
  }
}
