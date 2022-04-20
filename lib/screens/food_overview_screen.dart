import 'package:flutter/material.dart';
import 'package:foodhub/provider/cart.dart';
import 'package:foodhub/provider/foods.dart';
import 'package:foodhub/screens/cart_screen.dart';
import 'package:foodhub/widgets/app_drawer.dart';
import 'package:foodhub/widgets/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../widgets/foods_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  favourites,
  all,
}

class FoodOverviewScreen extends StatefulWidget {
  const FoodOverviewScreen({Key? key}) : super(key: key);

  @override
  State<FoodOverviewScreen> createState() => _FoodOverviewScreenState();
}

class _FoodOverviewScreenState extends State<FoodOverviewScreen> {
  var _showOnlyFavourites = false;
  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Foods>(context, listen: false).fetchAndSetFood().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodHub'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favourites) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
            child: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.favourites,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.all,
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
              child: ch!,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              // This doesnot rebuild when cart changes
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FoodsGrid(showFavourites: _showOnlyFavourites,isProfileScreen: false,),
    );
  }
}
