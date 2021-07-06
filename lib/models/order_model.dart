import 'cart_model.dart';

class OrderModel {
  String id;
  double amount;
  DateTime dateTime;
  List<CartModel> products;

  OrderModel({
    this.id,
    this.amount,
    this.dateTime,
    this.products,
  });
}
