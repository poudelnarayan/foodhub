import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/foods.dart';

class FoodDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  const FoodDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    final loadedProduct =
        Provider.of<Foods>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                  tag: loadedProduct.id!,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // list of WIdget to be displayed
              const SizedBox(
                height: 50,
              ),
              Text(
                '\$${loadedProduct.price}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const SizedBox(
                height: 750,
                // Just to make the product-detail screen scrollable so that we can test the beautiful animation
                // between appBar and Image
              )
            ]),
          ),
        ],
        // child: Column(
        //   children: <Widget>[
        //     SizedBox(
        //       height: 300,
        //       width: double.infinity,
        //       child: Hero(
        //         tag: loadedProduct.id!,
        //         child: Image.network(
        //           loadedProduct.imageUrl,
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //     ),
        //     const SizedBox(
        //       height: 10,
        //     ),
        //     Text(
        //       '\$${loadedProduct.price}',
        //       style: const TextStyle(color: Colors.grey, fontSize: 20),
        //     ),
        //     const SizedBox(  //! Used CustomScrollVIew with sliverDelegate
        //       height: 10,
        //     ),
        //     SizedBox(
        //       width: double.infinity,
        //       child: Text(
        //         loadedProduct.description,
        //         textAlign: TextAlign.center,
        //         softWrap: true,
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }
}
