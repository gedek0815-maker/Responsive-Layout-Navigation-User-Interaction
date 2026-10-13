import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/course.dart';

class CourseService {
  Future<List<Course>> loadCourses() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    final Map<String, dynamic> jsonData =
        json.decode(jsonString) as Map<String, dynamic>;

    final List<dynamic> courseList = jsonData['courses'] as List<dynamic>;

    return courseList.map((item) {
      return Course.fromJson(item as Map<String, dynamic>);
    }).toList();
  }
}
