import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  CartModel cartItems;
  String id;

  CartItem(this.cartItems, this.id);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItems.cartItemId),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          right: 20,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false).removeItem(id);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              "Delete?",
            ),
            content: Text(
              "Are you want to remove ${cartItems.quantity}x ${cartItems.title} from the cart?!",
            ),
            actions: [
              FlatButton(
                child: Text("YES"),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
            ],
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Text("\$${cartItems.price}"),
          ),
          title: Text(cartItems.title),
          subtitle: Text("Total: \$${cartItems.price * cartItems.quantity}"),
          trailing: Text("${cartItems.quantity}x"),
        ),
      ),
    );
  }
}
