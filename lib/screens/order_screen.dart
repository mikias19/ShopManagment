import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:shop/widget/app_drawer.dart';
import '/provider/orders.dart' show Orders;
import '../widget/OrdeItem.dart';

class OrdeScreen extends StatefulWidget {
  // static const routes = "/cart";
  static const route = '/order';

  @override
  State<OrdeScreen> createState() => _OrdeScreenState();
}

class _OrdeScreenState extends State<OrdeScreen> {
  @override
  var isLoading = false;
  void initState() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<Orders>(context, listen: false).fetchAndSet();
    });
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? const CircularProgressIndicator()
          : ListView.builder(
              itemCount: orderData.order.length,
              itemBuilder: (context, index) =>
                  OrderItem(orderData.order[index]),
            ),
    );
  }
}
