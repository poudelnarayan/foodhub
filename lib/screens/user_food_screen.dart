import 'package:flutter/material.dart';
import 'package:foodhub/screens/edit_food_screen.dart';
import 'package:provider/provider.dart';

import '../provider/foods.dart';
import '../widgets/user_food_list.dart';
import '../widgets/app_drawer.dart';

class UserFoodScreen extends StatelessWidget {
  static const routeName = '/user-product';
  const UserFoodScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Foods>(context, listen: false).fetchAndSetFood(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foods you added'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Foods>(
                      builder: (ctx, foodData, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: foodData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserFoodList(
                                id: foodData.items[i].id!,
                                imageUrl: foodData.items[i].imageUrl,
                                title: foodData.items[i].title,
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
