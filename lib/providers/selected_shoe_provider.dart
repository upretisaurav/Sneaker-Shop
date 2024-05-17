import 'package:flutter/material.dart';
import 'package:priority_soft_test/models/shoe.dart';

class SelectedShoeProvider extends ChangeNotifier {
  late Shoe _selectedShoe;
  late String? _selectedImageUrl;

  Shoe get selectedShoe => _selectedShoe;

  String? get selectedImageUrl => _selectedImageUrl;

  void setSelectedShoe(Shoe shoe, String? imageUrl) {
    _selectedShoe = shoe;
    _selectedImageUrl = imageUrl;
    notifyListeners();
  }
}
