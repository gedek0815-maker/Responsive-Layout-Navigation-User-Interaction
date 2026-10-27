import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/course.dart';
import 'course_data_source.dart';

// Implementasi CourseDataSource menggunakan REST API (Tahap 9 - Poin 52)
class CourseApiService implements CourseDataSource {
  final String baseUrl;

  CourseApiService([this.baseUrl = 'https://jsonplaceholder.typicode.com']);

  @override
  Future<List<Course>> getCourses() async {
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

  // Alias untuk kompatibilitas jika ada yang memanggil loadCourses
  Future<List<Course>> loadCourses() => getCourses();

  @override
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
      return Course.fromJson({
        'code': course.code,
        'title': course.title,
        'credits': course.credits,
        'status': course.status,
      });
    }

    throw Exception('Gagal membuat course. HTTP ${response.statusCode}');
  }

  @override
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

  @override
  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal menghapus course. HTTP ${response.statusCode}');
    }
  }
}
