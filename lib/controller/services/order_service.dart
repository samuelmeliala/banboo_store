import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/banboo_model.dart';
import '../../controller/utils/session_manager.dart';
import 'api.dart';

class OrderService {
  static Future<int> createOrder(Banboo banboo, int quantity) async {
    String? token = await SessionManager.getToken();
    if (token == null) throw Exception('Not authenticated');

    print('Token used for request: $token'); // Debug log

    final totalPrice = banboo.price * quantity;

    try {
      final response = await http.post(
        Uri.parse('$baseURL/orders/create'),
        headers: {
          'Authorization': 'Bearer $token', // Add 'Bearer ' prefix
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'banbooId': banboo.banbooId,
          'quantity': quantity,
          'totalPrice': totalPrice,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['orderId'];
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to create order');
      }
    } catch (e) {
      print('Error in createOrder: $e');
      throw Exception('Failed to create order: $e');
    }
  }
}
