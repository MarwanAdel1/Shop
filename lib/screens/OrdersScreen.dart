import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/oreders_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const ROUTE_NAME = "/orders";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: Provider.of<OrdersProvider>(context, listen: false)
                .fetchAndSetOrders(),
            builder: (ctx, snapShotData) {
              if (snapShotData.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapShotData.error != null) {
                return Center(child: Text("An error occurred!"));
              } else {
                return Consumer<OrdersProvider>(
                  builder: (ctxx, orderData, child) {
                    return orderData.orders.length == 0
                        ? Center(
                            child: Text("NO ORDERS!"),
                          )
                        : ListView.builder(
                            itemCount: orderData.orders.length,
                            itemBuilder: (ctxxx, i) =>
                                OrderItem(orderData.orders[i]),
                          );
                  },
                );
              }
            }));
  }
}
