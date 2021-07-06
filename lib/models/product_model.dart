import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite(String authToken, String userId) async {
    try {
      final url = Uri.parse(
          'https://shopapp-24c0f-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken');
      final response = await http.put(url,
          body: json.encode(
            !isFavorite,
          ));
      isFavorite = !isFavorite;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
