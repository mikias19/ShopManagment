import "package:flutter/material.dart";
import "package:provider/provider.dart";
import '../provider/Cart.dart';

class CartItem extends StatelessWidget {
  String id;
  String productId;
  double price;
  int quantitiy;
  String title;

  CartItem(
      {required this.id,
      required this.productId,
      required this.price,
      required this.quantitiy,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        padding: const EdgeInsets.only(right: 8),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: FittedBox(child: Text('\$$price'))),
            ),
            title: Text(title),
            subtitle: Text('Total \$${price * quantitiy}'),
            trailing: Text('$quantitiy x'),
          ),
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure ?'),
            content: const Text('Do you want to remove item from the cart '),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('NO'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Yes'),
              )
            ],
          ),
        );
      },
    );
  }
}
