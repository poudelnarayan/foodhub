import 'package:flutter/material.dart';
import 'package:foodhub/provider/auth.dart';
import 'package:foodhub/provider/cart.dart';
import 'package:provider/provider.dart';

import '../screens/food_detail_screen.dart';
import '../provider/food.dart';

class FoodItem extends StatelessWidget {
  const FoodItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Food>(context, listen: false); // another method
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(FoodDetailScreen.routeName,
              arguments: product.id); //  pushing Screens with arguments
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Hero(
                tag: product.id!,
                child: FadeInImage(
                  height: 250,
                  placeholder:
                      const AssetImage('assets/images/food.png'),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black87.withOpacity(0.3),
                    Colors.black54.withOpacity(0.3),
                    Colors.black38.withOpacity(0.3),
                  ],
                  stops: [0.1, 0.4, 0.6, 0.9],
                ),
              ),
            ),
            Positioned(
              bottom: 65.0,
              child: Column(
                children: <Widget>[
                  Text(
                    product.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Rs.${product.price}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10.0,
              right: 10.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  iconSize: 25.0,
                  color: Colors.white,
                  onPressed: () {
                    cart.addItem(product.id!, product.price, product.title);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Added item to cart.'),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              cart.removeSingleItem(product.id!);
                            }),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 5.0,
              left: 5.0,
              child: Consumer<Food>(
                builder: (c, product, child) => IconButton(
                  onPressed: () {
                    product.toggleFavorite(authData.token!, authData.userId!);
                  },
                  icon: Icon(
                    product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

    //     ClipRRect(

    //   borderRadius: BorderRadius.circular(10),
    //   child: GridTile(
    //     child: GestureDetector(
    //       onTap: () {

    //         Navigator.of(context).pushNamed(FoodDetailScreen.routeName,
    //             arguments: product.id); //  pushing Screens with arguments
    //       },
    //       child: Hero(
    //         tag: product.id!,
    //         child: FadeInImage(
    //           placeholder:
    //               const AssetImage('assets/images/product-placeholder.png'),
    //           image: NetworkImage(product.imageUrl),
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     ),
    //     footer: GridTileBar(
    //       backgroundColor: Colors.black87,
    //       leading: Consumer<Food>(
    //         builder: (c, product, child) => IconButton(
    //           onPressed: () {
    //             product.toggleFavorite(authData.token!, authData.userId!);
    //           },
    //           icon: Icon(
    //             product.isFavorite ? Icons.favorite : Icons.favorite_outline,
    //             color: Theme.of(context).colorScheme.secondary,
    //           ),
    //         ),
    //       ),
    //       title: Text(
    //         product.title,
    //         textAlign: TextAlign.center,
    //       ),
    //       trailing: IconButton(
    //         onPressed: () {
    //           cart.addItem(product.id!, product.price, product.title);
    //           ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(
    //               content: const Text('Added item to cart.'),
    //               duration: const Duration(seconds: 2),
    //               action: SnackBarAction(
    //                   label: 'UNDO',
    //                   onPressed: () {
    //                     cart.removeSingleItem(product.id!);
    //                   }),
    //             ),
    //           );
    //         },
    //         icon: Icon(
    //           Icons.shopping_cart,
    //           color: Theme.of(context).colorScheme.secondary,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
