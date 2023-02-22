import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/Cart.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/screens/auth_screen.dart.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/user_product_screen.dart';
import './provider/product_provider.dart';
import './screens/product_overview_detaile.dart';
import "./screens/order_screen.dart";
import "./provider/auth.dart";
import "./screens/start_auto.dart";
//import "./screens/product_overview_description.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products('', [], ''),
            update: (context, value, previous) => Products(value.token,
                previous == null ? [] : previous.items, value.userId)),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders('', '', []),
            update: ((context, value, previous) => Orders(value.token,
                value.userId, previous == null ? [] : previous.orders))),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductOverViewDetaile()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: ((context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? StartAuto()
                          : AuthScreen())),
          routes: {
            ProductDetaile.routes: ((context) => ProductDetaile()),
            CartScreen.routes: (context) => CartScreen(),
            OrdeScreen.route: (context) => OrdeScreen(),
            UserProductScreen.routes: (context) => UserProductScreen(),
            EditProduct.routeName: (context) => EditProduct(),
          },
        ),
      ),
    );
  }
}
