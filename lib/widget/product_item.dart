import "package:flutter/material.dart";
import 'package:shop/provider/product.dart';
import 'package:shop/screens/product_detail_screen.dart';
import "package:provider/provider.dart";
import '../provider/Cart.dart';
import "../provider/auth.dart";

class productItems extends StatelessWidget {
  // final String title;
  // final String id;
  // final String imageUrl;
  // productItems({required this.id, required this.title, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetaile.routes, arguments: product.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            title: Text(product.title),
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (context, product, child) => IconButton(
                onPressed: () {
                  product.toogleHandler(authData.token!, authData.userId!);
                },
                icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.deepOrange),
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(
                  product.id,
                  product.title,
                  product.price,
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('added item to cart !'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart, color: Colors.deepOrange),
            ),
          ),
        ),
      ),
    );
  }
}
