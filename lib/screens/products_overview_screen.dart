import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/products_providers.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import 'cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const ROUTE_NAME = "/overview";

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showFavoritesOnly = false;

  Future _productsFuture;

  Future _obtainProductsFuture() {
    return Provider.of<ProductsProvider>(context, listen: false)
        .fetchDataAndSetProducts(false);
  }

  @override
  void initState() {
    _productsFuture = _obtainProductsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MyShop",
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.add_shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.ROUTE_NAME);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.All) {
                  showFavoritesOnly = false;
                } else {
                  showFavoritesOnly = true;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  "Show All",
                ),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: Text(
                  "Favorites",
                ),
                value: FilterOptions.Favorites,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _productsFuture,
        builder: (ctxx, snapShotData) {
          if (snapShotData.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapShotData.error != null) {
            return Center(child: Text("An error occurred!"));
          } else {
            return ProductGrid(showFavoritesOnly);
          }
        },
      ),
      // _isLoading
      //     ? Center(
      //   child: CircularProgressIndicator(),
      // )
      //     : ProductGrid(showFavoritesOnly),
    );
  }
}
