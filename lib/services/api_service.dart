import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/api_post.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<ApiPost>> fetchPosts() async {
    final uri = Uri.parse('$baseUrl/posts');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        return ApiPost.fromJson(json as Map<String, dynamic>);
      }).toList();
    }

    throw Exception('Gagal mengambil data. HTTP ${response.statusCode}');
  }
}
