import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:shop/provider/product_provider.dart';

class ProductDetaile extends StatelessWidget {
  static const routes = "/productDetaile";
  const ProductDetaile({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedItem = Provider.of<Products>(context)
        .item
        .firstWhere((pro) => pro.id == productId);
    return Scaffold(
        // appBar: AppBar(title: Text(loadedItem.title)),
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedItem.title),
              background: Hero(
                tag: loadedItem.id,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    loadedItem.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${loadedItem.price}',
                style: const TextStyle(fontSize: 20, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  loadedItem.description,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 800,
              )
            ],
          ),
        )
      ],
    ));
  }
}
