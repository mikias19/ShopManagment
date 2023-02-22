// ignore_for_file: unnecessary_null_comparison, unnecessary_null_in_if_null_operators

import 'dart:convert';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg
    //       '',
    // ),
  ];
  String? token;
  String? userId;
  Products(this.token, this.items, this.userId);
  var showFavoriteOnly = false;
  List<Product> get item {
    // if (showFavoriteOnly) {
    //   return items.where((element) => element.isFavorite).toList();
    // }
    return [...items];
  }

  List<Product> get FavItem {
    return items.where((element) => element.isFavorite).toList();
  }

  Future<void> FetchAndSet([bool filterbyUser = false]) async {
    final filterString =
        filterbyUser ? "orderBy='creatorId'&equalTo='$userId'" : "";
    var url =
        "https://products-600a7-default-rtdb.firebaseio.com/products.json?auth=$token&$filterString";
    try {
      final List<Product> listofProduct = [];
      final response = await http.get(Uri.parse(url));
      final extractData = jsonDecode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }

      url =
          "https://products-600a7-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$token";
      final favresponse = await http.get(Uri.parse(url));
      final favoriteData = jsonDecode(favresponse.body);
      extractData.forEach((proId, proData) {
        listofProduct.add(Product(
          id: proId,
          price: proData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[proId] ?? false,
          description: proData['description'],
          imageUrl: proData['imageUrl'],
          title: proData['title'],
        ));
      });
      items = listofProduct;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> AddProducts(Product product) async {
    final url =
        "https://products-600a7-default-rtdb.firebaseio.com/products.json?auth=$token";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "title": product.title,
          "price": product.price,
          "description": product.description,
          'imageUrl': product.imageUrl,
          "creatorId": userId,
        }),
      );
      final newProduct = Product(
          id: jsonDecode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Product findbyid(String id) {
    return item.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    var index = items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      final url =
          "https://products-600a7-default-rtdb.firebaseio.com/products/$id.json?auth=$token";

      await http.patch(
        Uri.parse(url),
        body: json.encode({
          "title": newProduct.title,
          "price": newProduct.price,
          "description": newProduct.description,
          'imageUrl': newProduct.imageUrl
        }),
      );
      items[index] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://products-600a7-default-rtdb.firebaseio.com/products/$id.json?auth=$token";
    final existingIndex = items.indexWhere((element) => element.id == id);
    var existingData = items[existingIndex];
    var resetecistingProduct = Product(
      title: "",
      imageUrl: '',
      price: 0,
      description: '',
      id: '',
    );

    items.removeAt(existingIndex);
    notifyListeners();
    final res = await http.delete(Uri.parse(url));
    if (res.statusCode >= 400) {
      items.insert(existingIndex, existingData);
      notifyListeners();
      throw HttpException("Coud not Delete!");
    }
    existingData = resetecistingProduct;
  }
}

  // void FilterFav() {
  //   showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void FilterAll() {
  //   showFavoriteOnly = false;
  //   notifyListeners();
  // }

