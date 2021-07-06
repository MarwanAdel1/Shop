import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_providers.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  bool showFavoritesOnly;

  ProductGrid(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = showFavoritesOnly
        ? productsData.favoriteItems
        : productsData.productItems;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemCount: products.length,
      itemBuilder: (_, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
    );
  }
}
