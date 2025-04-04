
import 'package:http/http.dart' as http;

import 'package:http/http.dart';
import 'dart:convert';

class UsersService {
  static final UsersService _singleton = UsersService._internal();
  UsersService._internal();
  static UsersService get instance => _singleton;

  final String baseUrl =
      'https://67e251cd97fc65f535356bbc.mockapi.io/api/version1/Bopha';

  Future<List<dynamic>> getUsers() async {

    Response res = await get(Uri.parse('$baseUrl'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw 'Cannot fetch users';
    }
  }

  Future<dynamic> updateUser(String id, Map<String, dynamic> data) async {

    Response res = await http.put(
      Uri.parse('$baseUrl/$id'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw 'Cannot update user';
    }
  }

  Future<dynamic> createUser(Map<String, dynamic> data) async {

    Response res = await post(
      Uri.parse('$baseUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),

    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw 'Cannot create user';
    }
  }

  Future<dynamic> deleteUser(String id) async {

    Response res = await delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw 'Cannot delete user';
    }
  }
}
