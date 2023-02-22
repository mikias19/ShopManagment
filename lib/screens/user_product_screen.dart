import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop/screens/edit_product.dart';
import '/provider/product_provider.dart';
import '/widget/app_drawer.dart';
import '/widget/user_product.dart';

class UserProductScreen extends StatelessWidget {
  static const routes = '/user-product';
  Future<void> refresherofPage(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).FetchAndSet(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productDate = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProduct.routeName);
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: refresherofPage(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => refresherofPage(context),
                      child: Consumer<Products>(
                        builder: (context, value, _) => Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: value.items.length,
                            itemBuilder: (context, index) => Column(
                              children: [
                                UserProduct(
                                    id: value.items[index].id,
                                    title: value.items[index].title,
                                    imageurl: value.items[index].imageUrl),
                                const Divider()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
        ));
  }
}
