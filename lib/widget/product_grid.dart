import 'package:provider/provider.dart';
import 'package:shop/provider/product_provider.dart';
import "../widget/product_item.dart";
import "package:flutter/material.dart";

class ProductGrid extends StatelessWidget {
  bool showFav;
  ProductGrid(this.showFav);

  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final product = showFav ? productData.FavItem : productData.item;
    return GridView.builder(
        itemCount: product.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: product[index],
              child: productItems(
                  // id: product[index].id,
                  // title: product[index].title,
                  // imageUrl: product[index].imageUrl),
                  ),
            ));
  }
}
