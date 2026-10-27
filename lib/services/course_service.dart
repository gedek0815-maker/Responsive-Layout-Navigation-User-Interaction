import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Course>> loadCourses() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    final Map<String, dynamic> jsonData =
        jsonDecode(jsonString) as Map<String, dynamic>;

    final List<dynamic> coursesJson = jsonData['courses'] as List<dynamic>;

    return coursesJson.map((item) {
      return Course.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'code': course.code,
        'title': course.title,
        'credits': course.credits,
        'status': course.status,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // JSONPlaceholder mengembalikan objek simulasi.
      // Ambil data course dari form agar format tetap cocok.
      return Course.fromJson({
        'code': course.code,
        'title': course.title,
        'credits': course.credits,
        'status': course.status,
      });
    }

    throw Exception('Gagal membuat course. HTTP ${response.statusCode}');
  }

  // Memperbarui course menggunakan HTTP PUT (Tahap 7).
  Future<void> updateCourse(int id, Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal memperbarui course. HTTP ${response.statusCode}');
    }
  }
}
