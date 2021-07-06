import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/oreders_provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const ROUTE_NAME = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$" + cart.totalAmount.toStringAsFixed(2),
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: (cart.totalAmount <= 0 || _isLoading)
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await Provider.of<OrdersProvider>(context,
                                    listen: false)
                                .addOrder(
                              cart.cartItems.values.toList(),
                              cart.totalAmount,
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            cart.clearCart();
                          },
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('ORDER NOW'),
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => CartItem(
                  cart.cartItems.values.toList()[index],
                  cart.cartItems.keys.toList()[index]),
              itemCount: cart.cartItems.length,
            ),
          ),
        ],
      ),
    );
  }
}
