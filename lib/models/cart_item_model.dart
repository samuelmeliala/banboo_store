import 'package:banboo_store/models/banboo_model.dart';

class CartItem {
  final Banboo banboo;
  int quantity;

  CartItem({
    required this.banboo,
    this.quantity = 1,
  });

  double get totalPrice => banboo.price * quantity;
}
