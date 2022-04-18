import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:foodhub/provider/foods.dart';
import 'package:provider/provider.dart';

import '../screens/food_detail_screen.dart';

class CaSlider extends StatelessWidget {
  const CaSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final foodsData = Provider.of<Foods>(context);
    final carouselFood = foodsData.items;

    return CarouselSlider.builder(
      itemCount: 3,
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
      ),
      itemBuilder: (context, itemIndex, realIndex) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                FoodDetailScreen.routeName,
                arguments: carouselFood[itemIndex].id,
              ); //  pushing Screens with arguments
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(
                        carouselFood[itemIndex].imageUrl,
                      ),
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
                  top: 10.0,
                  left: 15,
                  child: Column(
                    children: const <Widget>[
                      Text(
                        ' Todays Special ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          backgroundColor: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  left: 110,
                  child: Column(
                    children: <Widget>[
                      Text(
                        carouselFood[itemIndex].title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
