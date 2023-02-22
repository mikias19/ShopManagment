import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "../provider/orders.dart" as ord;
import "dart:math";

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(microseconds: 300),
        height:
            expanded ? min(widget.order.product.length * 30 + 100, 200) : 95,
        child: Card(
            child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.total}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.datetime)),
              trailing: IconButton(
                  icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  }),
            ),
            AnimatedContainer(
              duration: const Duration(microseconds: 300),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              height: expanded
                  ? min(widget.order.product.length * 30 + 20, 120)
                  : 0,
              child: ListView(
                children: widget.order.product
                    .map(
                      (pro) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pro.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text('${pro.quantiity}x \$${pro.price}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ))
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        )));
  }
}
