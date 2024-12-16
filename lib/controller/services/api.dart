import 'dart:convert';
import 'package:banboo_store/models/banboo_model.dart';
import 'package:banboo_store/models/user_model.dart';
import 'package:http/http.dart' as http;

const baseURL = 'http://10.0.2.2:3000'; // For Android emulator
// Use http://localhost:3000 for iOS simulator

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
  String url = '$baseURL/users/register'; // Add this endpoint to your backend

  var result = await http.post(Uri.parse(url),
      body: {'username': username, 'email': email, 'password': password});

  if (result.statusCode == 201) {
    // Usually 201 for resource creation
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
