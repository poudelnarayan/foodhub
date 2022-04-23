import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:foodhub/helpers/custom_route.dart';
import 'package:foodhub/provider/auth.dart';
import 'package:foodhub/provider/cart.dart';
import 'package:foodhub/provider/orders.dart';
import 'package:foodhub/screens/auth/login_screen.dart';
import 'package:foodhub/screens/cart_screen.dart';
import 'package:foodhub/screens/edit_food_screen.dart';
import 'package:foodhub/screens/orders_screen.dart';
import 'package:foodhub/screens/splash_screen.dart';
import 'package:foodhub/screens/user_food_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/food_overview_screen.dart';
import 'screens/food_detail_screen.dart';
import 'provider/foods.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.deepOrange, // status bar color
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FoodHub());
}

class FoodHub extends StatelessWidget {
  const FoodHub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Foods>(
          create: (_) => Foods('', '', []),
          update: (ctx, auth, previousProducts) => Foods(
            auth.token ?? '',
            auth.userId ?? '',
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', '', []),
          update: (ctx, auth, previousOrders) => Orders(
              auth.token ?? '',
              auth.userId ?? '',
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FoodHub',
          home: auth.isAuth
              ? const FoodOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const LoginScreen(),
                ),
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.grey[50],
            colorScheme:
                ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange)
                    .copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          routes: {
            FoodDetailScreen.routeName: (ctx) => const FoodDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserFoodScreen.routeName: (ctx) => const UserFoodScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
