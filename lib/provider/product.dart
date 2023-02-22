import 'dart:convert';
import "package:http/http.dart" as http;
import "package:flutter/material.dart";

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final String description;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  Future<void> toogleHandler(String token, String userId) async {
    final url =
        "https://products-600a7-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token";
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final res = await http.put(Uri.parse(url), body: jsonEncode(isFavorite));
      if (res.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
