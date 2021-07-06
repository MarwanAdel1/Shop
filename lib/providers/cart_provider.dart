import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get cartItems {
    return {..._cartItems};
  }

  int get itemCount {
    return _cartItems.length;
  }

  double get totalAmount {
    double total = 0;
    _cartItems.forEach((key, value) {
      total += value.quantity * value.price;
    });
    return total;
  }

  void addItem(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems.update(
        product.id,
        (value) => CartModel(
          cartItemId: value.cartItemId,
          title: value.title,
          price: value.price,
          quantity: value.quantity + 1,
        ),
      );
    } else {
      _cartItems.putIfAbsent(
        product.id,
        () => CartModel(
          cartItemId: DateTime.now().toString(),
          title: product.title,
          price: product.price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_cartItems.containsKey(productId)) {
      return;
    }
    if (_cartItems[productId].quantity > 1) {
      _cartItems.update(
          productId,
          (existingCartItem) => CartModel(
                cartItemId: existingCartItem.cartItemId,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems = {};
    notifyListeners();
  }
}
