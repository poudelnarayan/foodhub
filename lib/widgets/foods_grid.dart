import 'package:flutter/material.dart';
import 'package:foodhub/widgets/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../provider/foods.dart';
import 'food_item.dart';

class FoodsGrid extends StatelessWidget {
  const FoodsGrid({
    Key? key,
    required this.showFavourites,
    required this.isProfileScreen,
  }) : super(key: key);

  final bool showFavourites;
  final bool isProfileScreen;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Foods>(context);
    final products =
        showFavourites ? productsData.favouriteItems : productsData.items;

    Widget _buildGridView() {
      return GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        physics: const ScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2 / 2,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),

        // itemBuilder: (ctx, i) => ChangeNotifierProvider(   // * If provider value depends on context
        //   create: (c) => products[i],
        //   child: ProductItem(),
        // ),

        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          // * WhenEver we use a existing object it is recommended to use .value
          //* If provider value doesnot depends on context
          value: products[i],
          child: FoodItem(isProfile: isProfileScreen),
          //! This method must be  used on builder function (listView.builder or GridView.builder)
        ),
      );
    }

    return Container(
      child: isProfileScreen
          ? _buildGridView()
          : ListView(
              children: [
                const CaSlider(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: showFavourites
                      ? const Text(
                          'Your Favourites',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text(
                          'Browse More',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                _buildGridView(),
              ],
            ),
    );
  }
}
