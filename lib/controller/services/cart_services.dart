import 'dart:convert';
import 'package:banboo_store/models/banboo_model.dart';
import 'package:banboo_store/models/cart_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const String _cartKey = 'cart_items';

  static Future<void> addToCart(CartItem item) async {
    final prefs = await SharedPreferences.getInstance();
    List<CartItem> currentCart = await getCart();

    // Check if item already exists in cart
    int existingIndex = currentCart.indexWhere(
        (cartItem) => cartItem.banboo.banbooId == item.banboo.banbooId);

    if (existingIndex != -1) {
      currentCart[existingIndex].quantity += item.quantity;
    } else {
      currentCart.add(item);
    }

    // Save updated cart
    List<String> cartJson = currentCart
        .map((item) => jsonEncode({
              'banbooId': item.banboo.banbooId,
              'quantity': item.quantity,
              'banboo': item.banboo.toJson(),
            }))
        .toList();

    await prefs.setStringList(_cartKey, cartJson);
  }

  static Future<List<CartItem>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartJson = prefs.getStringList(_cartKey);

    if (cartJson == null) return [];

    return cartJson.map((itemJson) {
      Map<String, dynamic> item = jsonDecode(itemJson);
      return CartItem(
        banboo: Banboo.fromJson(item['banboo']),
        quantity: item['quantity'],
      );
    }).toList();
  }

  static Future<void> updateQuantity(int banbooId, int quantity) async {
    List<CartItem> cart = await getCart();
    int index = cart.indexWhere((item) => item.banboo.banbooId == banbooId);

    if (index != -1) {
      cart[index].quantity = quantity;
      if (quantity <= 0) {
        cart.removeAt(index);
      }

      final prefs = await SharedPreferences.getInstance();
      List<String> cartJson = cart
          .map((item) => jsonEncode({
                'banbooId': item.banboo.banbooId,
                'quantity': item.quantity,
                'banboo': item.banboo.toJson(),
              }))
          .toList();

      await prefs.setStringList(_cartKey, cartJson);
    }
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
