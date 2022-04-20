import 'package:flutter/material.dart';
import 'package:foodhub/helpers/custom_route.dart';
import 'package:foodhub/provider/auth.dart';
import 'package:foodhub/screens/orders_screen.dart';
import 'package:foodhub/screens/profile_screen.dart';
import 'package:foodhub/screens/user_food_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Menu'),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(ProfileScreen.routeName);
                    },
                    icon: const Icon(Icons.person)),
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Get Some Foods'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(OrdersScreen.routeName);
              Navigator.of(context).pushReplacement(
                CustomRoute(
                  builder: (ctx) => const OrdersScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Foods'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserFoodScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              // To close the app drawer, as it will remain open after logout

              Navigator.of(context).pushReplacementNamed('/');

              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
