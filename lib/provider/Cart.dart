import "package:flutter/material.dart";

class CartItem {
  final String id;
  final String title;
  final int quantiity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantiity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> items = {};

  Map<String, CartItem> get item {
    return {...items};
  }

  void addItem(String productId, String title, double price) {
    if (items.containsKey(productId)) {
      items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                price: existingItem.price,
                quantiity: existingItem.quantiity + 1,
              ));
    } else {
      items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantiity: 1,
              ));
    }

    notifyListeners();
  }

  int get itemCounter {
    return items.length;
  }

  double get totalAmount {
    var total = 0.0;
    items.forEach((key, item) {
      total += item.price * item.quantiity;
    });
    return total;
  }

  void removeItem(String productId) {
    items.remove(productId);
    notifyListeners();
  }

  void clear() {
    items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!items.containsKey(productId)) {
      return;
    }
    if (items[productId]!.quantiity > 1) {
      items.update(
        productId,
        (existingItem) => CartItem(
            id: existingItem.id,
            title: existingItem.title,
            price: existingItem.price,
            quantiity: existingItem.quantiity - 1),
      );
    } else {
      items.remove(productId);
    }
    notifyListeners();
  }
}
