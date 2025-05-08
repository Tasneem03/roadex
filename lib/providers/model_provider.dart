import 'package:flutter/material.dart';

class ModelProvider<T> extends ChangeNotifier {
  List<T> _items = [];
  bool _isLoading = false;

  List<T> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchProviders(Future<List<T>> Function() fetchFunction) async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await fetchFunction();
    } catch (error) {
      print('Error fetching data: $error');
    }

    _isLoading = false;
    notifyListeners();
  }
}