import 'package:flutter/material.dart';
import 'package:shop/provider/Cart.dart';
import 'package:shop/provider/product_provider.dart';
import 'package:shop/widget/app_drawer.dart';
import 'package:shop/widget/badge.dart';
import 'package:shop/widget/product_grid.dart';
import "package:provider/provider.dart";
import "../screens/cart_screen.dart";

enum FilterOption {
  Favorite,
  All,
}

class ProductOverViewDetaile extends StatefulWidget {
  @override
  State<ProductOverViewDetaile> createState() => _ProductOverViewDetaileState();
}

class _ProductOverViewDetaileState extends State<ProductOverViewDetaile> {
  var showFavoriteOnly = false;
  var isInit = true;
  var isLoading = false;
  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).FetchAndSet().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("MyShop"),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOption selectValue) => setState(
                () {
                  if (selectValue == FilterOption.Favorite) {
                    showFavoriteOnly = true;
                  } else {
                    showFavoriteOnly = false;
                  }
                },
              ),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  child: Text("Only Favorite"),
                  value: FilterOption.Favorite,
                ),
                const PopupMenuItem(
                  child: Text("Show All"),
                  value: FilterOption.All,
                )
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                  child: ch!,
                  value: cart.itemCounter.toString(),
                  color: Colors.deepOrange),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routes);
                },
                icon: Icon(Icons.shopping_cart),
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ProductGrid(showFavoriteOnly));
  }
}
