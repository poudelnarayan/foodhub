import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:foodhub/provider/cart.dart';
import 'package:foodhub/provider/foods.dart';
import 'package:foodhub/screens/cart_screen.dart';
import 'package:foodhub/widgets/profile.dart';
import 'package:foodhub/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';
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
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  var _showOnlyFavourites = false;
  var _isLoading = false;
  int _page = 1;

  Widget _listTileBuilder(
      IconData leadingIcon, String text, Function onTapHandeler) {
    return GestureDetector(
      onTap: () {
        onTapHandeler;
      },
      child: ListTile(
        leading: Icon(leadingIcon),
        title: Text(text),
      ),
    );
  }

  Widget _settingPage() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _listTileBuilder(Icons.info, 'About FoodHub', () {}),
              const Divider(),
              _listTileBuilder(Icons.feedback_outlined, 'Feedback', () {}),
              const Divider(),
              _listTileBuilder(Icons.feed, 'Terms and condition', () {}),
              const Divider(),
              _listTileBuilder(
                  Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
              const Divider(),
              _listTileBuilder(Icons.question_answer, 'FAQs', () {}),
              const Divider(),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 70),
            child: Column(
              children: const [
                Text(
                  'Version 1.0 © FoodHub Pvt.Ltd',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Made with ♥ by Prajwol ',
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

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
    final String currentUser = Provider.of<Auth>(context).userId!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodHub'),
        centerTitle: true,
        actions: [
          if (_page == 1)
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
          : Container(
              child: _page == 1
                  ? FoodsGrid(
                      showFavourites: _showOnlyFavourites,
                      isProfileScreen: false,
                    )
                  : Container(
                      child: _page == 0
                          ? UserProfile(currentUser: currentUser)
                          : _settingPage(),
                    ),
            ),
      bottomNavigationBar: _isLoading
          ? null
          : CurvedNavigationBar(
              index: 1,
              height: 60,
              key: _bottomNavigationKey,
              items: const [
                Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.white,
                ),
                Icon(
                  Icons.home,
                  size: 30,
                  color: Colors.white,
                ),
                Icon(
                  Icons.settings,
                  size: 30,
                  color: Colors.white,
                ),
              ],
              animationDuration: const Duration(milliseconds: 500),
              backgroundColor: Colors.white,
              color: Theme.of(context).colorScheme.secondary,
              onTap: (index) {
                setState(
                  () {
                    _page = index;
                  },
                );
              },
            ),
    );
  }
}
