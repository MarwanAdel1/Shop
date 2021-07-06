import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _productItems = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  String authToken;
  String userId;

  ProductsProvider(this.userId, this.authToken, this._productItems);

  List<Product> get productItems {
    return _productItems;
  }

  List<Product> get favoriteItems {
    return _productItems.where((Item) => Item.isFavorite).toList();
  }

  Product findById(Product product) {
    return _productItems
        .firstWhere((productItem) => productItem.id == product.id);
  }

  Future<void> fetchDataAndSetProducts(bool filterByUser) async {
    try {
      final String filtering =
          filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
      final productsUrl = Uri.parse(
          'https://shopapp-24c0f-default-rtdb.firebaseio.com/products.json?auth=$authToken$filtering');
      final response = await http.get(productsUrl);
      final extractedProduct =
          json.decode(response.body) as Map<String, dynamic>;
      final List<Product> productLoaded = [];
      if (extractedProduct == null) {
        return;
      }
      final favoritesUrl = Uri.parse(
          'https://shopapp-24c0f-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(favoritesUrl);
      final extractedFavorite = json.decode(favoriteResponse.body);
      extractedProduct.forEach((productId, productData) {
        productLoaded.add(Product(
            id: productId,
            imageUrl: productData['imageUrl'],
            description: productData['description'],
            price: productData['price'],
            title: productData['title'],
            isFavorite: extractedFavorite == null
                ? false
                : extractedFavorite[productId] ?? false));
      });
      _productItems = productLoaded;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shopapp-24c0f-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _productItems.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    final index = _productItems.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      try {
        final url = Uri.parse(
            'https://shopapp-24c0f-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$authToken');
        final response = await http.patch(
          url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }),
        );
        _productItems[index] = product;
        notifyListeners();
      } catch (error) {}
    }
  }

  Future<void> deleteProduct(Product product) async {
    try {
      final url = Uri.parse(
          'https://shopapp-24c0f-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$authToken');
      final response = await http.delete(url);
      _productItems.removeWhere((item) => item.id == product.id);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
