import 'dart:convert';
import 'package:banboo_store/models/order_model.dart';
import 'package:http/http.dart' as http;
import '../../models/banboo_model.dart';
import '../../controller/utils/session_manager.dart';
import 'api.dart';

class OrderService {
  static Future<int> createOrder(Banboo banboo, int quantity) async {
    String? token = await SessionManager.getToken();
    if (token == null) throw Exception('Not authenticated');

    // print('Token used for request: $token');

    final totalPrice = banboo.price * quantity;

    try {
      final response = await http.post(
        Uri.parse('$baseURL/orders/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'banbooId': banboo.banbooId,
          'quantity': quantity,
          'totalPrice': totalPrice,
        }),
      );

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['orderId'];
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to create order');
      }
    } catch (e) {
      // print('Error in createOrder: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  static Future<List<Order>> getOrderHistory() async {
    String? token = await SessionManager.getToken();
    if (token == null) throw Exception('Not authenticated');

    try {
      final response = await http.get(
        Uri.parse('$baseURL/orders/history'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load order history');
      }
    } catch (e) {
      throw Exception('Error fetching order history: $e');
    }
  }
}
