import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/user_product_screen.dart';
import '/screens/order_screen.dart';
import "../provider/auth.dart";

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: const Text('hellow my friends '),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            }),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text("Orders"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdeScreen.route);
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text("Manage Products"),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routes);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text("LogOut"),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed("/");
            Provider.of<Auth>(context, listen: false).Logout();
          },
        ),
        const Divider(),
      ]),
    );
  }
}
