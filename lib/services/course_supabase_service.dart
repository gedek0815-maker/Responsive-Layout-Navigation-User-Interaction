// Nama: Gede Krisna Adi Pramana | NIM: 2415051036
// Tahap 13: INSERT - Menambah Data ke Database Supabase (Poin 78)

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    // 72. Ambil data dari tabel courses
    final data = await supabase
        .from('courses')
        .select()
        .order('id');

    // 73. Konversi response menjadi List<Course>
    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Tahap 13: INSERT - Menambah Data ke Database (Poin 78)
  @override
  Future<Course> createCourse(Course course) async {
    final row = await supabase
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();

    return Course.fromJson(row);
  }

  @override
  Future<void> updateCourse(int id, Course course) => throw UnimplementedError();

  @override
  Future<void> deleteCourse(int id) => throw UnimplementedError();
}
