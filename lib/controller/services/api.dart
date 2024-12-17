import 'dart:convert';
import 'package:banboo_store/controller/utils/session_manager.dart';
import 'package:banboo_store/models/banboo_model.dart';
import 'package:banboo_store/models/user_model.dart';
import 'package:http/http.dart' as http;

const baseURL = 'http://10.0.2.2:3000';

Future<User?> tryLogin(String username, String password) async {
  String url = '$baseURL/users/login';

  var result = await http
      .post(Uri.parse(url), body: {'username': username, 'password': password});

  if (result.statusCode == 200) {
    var data = json.decode(result.body);
    return User.fromJson(data);
  }

  return null;
}

Future<User?> tryRegister(
    String username, String email, String password) async {
  String url = '$baseURL/users/register';

  var result = await http.post(Uri.parse(url),
      body: {'username': username, 'email': email, 'password': password});

  if (result.statusCode == 201) {
    var data = json.decode(result.body);
    return User.fromJson(data);
  }

  return null;
}

Future<List<Banboo>> fetchBanboos() async {
  String url = '$baseURL/banboos';

  try {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Banboo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load banboos');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<Banboo> fetchBanbooById(int id) async {
  String url = '$baseURL/banboos/$id';

  try {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Banboo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load banboo');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<List<Banboo>> searchBanboos(String query) async {
  final url = Uri.parse('$baseURL/banboo/search').replace(
    queryParameters: {'query': query},
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Banboo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search banboos');
    }
  } catch (e) {
    throw Exception('Error searching banboos: $e');
  }
}

Future<Banboo> createBanboo(Map<String, dynamic> banbooData) async {
  try {
    final token = await SessionManager.getToken();
    if (token == null) throw Exception('Not authenticated');

    print('Creating banboo with data: $banbooData'); // Debug log

    final response = await http.post(
      Uri.parse('$baseURL/banboos'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': banbooData['name'],
        'price': banbooData['price'],
        'description': banbooData['description'],
        'elementId': banbooData['elementId'],
        'level': banbooData['level'],
        'imageUrl': banbooData['imageUrl'],
      }),
    );

    print('Response status: ${response.statusCode}'); // Debug log
    print('Response body: ${response.body}'); // Debug log

    if (response.statusCode == 201) {
      return Banboo.fromJson(json.decode(response.body));
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to create banboo');
    }
  } catch (e) {
    print('Error creating banboo: $e'); // Debug log
    throw Exception('Failed to create banboo: $e');
  }
}

Future<Banboo> updateBanboo(int id, Map<String, dynamic> banbooData) async {
  try {
    final token = await SessionManager.getToken();
    final response = await http.put(
      Uri.parse('$baseURL/banboos/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': banbooData['name'],
        'price': banbooData['price'],
        'description': banbooData['description'],
        'elementId': banbooData['elementId'],
        'level': banbooData['level'],
        'imageUrl': banbooData['imageUrl'], // Added this
      }),
    );

    if (response.statusCode == 200) {
      return Banboo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update banboo');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<void> deleteBanboo(int id) async {
  try {
    final token = await SessionManager.getToken();
    final isAdmin = await SessionManager.isAdmin();

    if (!isAdmin) {
      throw Exception('Access denied. Admin privileges required.');
    }

    // print('Deleting banboo with ID: $id');

    final response = await http.delete(
      Uri.parse('$baseURL/banboos/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // print('Delete response status: ${response.statusCode}');
    // print('Delete response body: ${response.body}');

    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to delete banboo');
    }
  } catch (e) {
    // print('Error deleting banboo: $e');
    throw Exception('Failed to delete banboo: $e');
  }
}
