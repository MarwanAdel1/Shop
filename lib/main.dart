import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/oreders_provider.dart';
import 'providers/products_providers.dart';
import 'screens/OrdersScreen.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (ctx, auth, previousProducts) => ProductsProvider(
            auth.userId,
            auth.token,
            previousProducts == null ? [] : previousProducts.productItems,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          update: (ctx, auth, previousOrders) => OrdersProvider(
            auth.userId,
            auth.token,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: "Lato"),
          home: authData.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            AuthScreen.ROUTE_NAME: (ctx) => AuthScreen(),
            ProductOverviewScreen.ROUTE_NAME: (ctx) => ProductOverviewScreen(),
            ProductDetailsScreen.ROUTE_NAME: (ctx) => ProductDetailsScreen(),
            CartScreen.ROUTE_NAME: (ctx) => CartScreen(),
            OrdersScreen.ROUTE_NAME: (ctx) => OrdersScreen(),
            UserProductsScreen.ROUTE_NAME: (ctx) => UserProductsScreen(),
            EditProductScreen.ROUTE_NAME: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
