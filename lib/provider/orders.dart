import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/provider/Cart.dart' as ci;
import 'package:http/http.dart' as http;
import "./Cart.dart";

class OrderItem {
  final String id;
  final double total;
  final List<ci.CartItem> product;
  final DateTime datetime;

  OrderItem(
      {required this.id,
      required this.total,
      required this.product,
      required this.datetime});
}

class Orders with ChangeNotifier {
  List<OrderItem> orders = [];
  List<OrderItem> get order {
    return [...orders];
  }

  String? token;
  String? userId;
  Orders(this.token, this.userId, this.orders);
  Future<void> fetchAndSet() async {
    final url =
        "https://products-600a7-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token";
    var response = await http.get(Uri.parse(url));
    // print(jsonDecode(response.body));

    final extractedData = jsonDecode(response.body) as Map<String?, dynamic>;
    if (extractedData == null) {
      return;
    }
    final List<OrderItem> loadedOrder = [];
    extractedData.forEach(
      (orderId, orderData) {
        loadedOrder.add(
          OrderItem(
              id: orderId!,
              datetime: DateTime.parse(orderData['dateTime']),
              total: orderData['amount'],
              product: (orderData['product'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      price: item['price'],
                      quantiity: item['quantiity'],
                    ),
                  )
                  .toList()),
        );
      },
    );
    orders = loadedOrder.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<ci.CartItem> productOrder, double total) async {
    final timeSatmp = DateTime.now();
    final url =
        "https://products-600a7-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token";
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'amount': total,
            "dateTime": timeSatmp.toIso8601String(),
            "product": productOrder
                .map((pd) => {
                      "id": pd.id,
                      "title": pd.title,
                      "price": pd.price,
                      "quantiity": pd.quantiity
                    })
                .toList()
          }));

      orders.insert(
        0,
        OrderItem(
          id: jsonDecode(response.body)['name'],
          total: total,
          product: productOrder,
          datetime: timeSatmp,
        ),
      );
      notifyListeners();
    } catch (error) {
      //
    }
  }
}
