import '../models/course.dart';

// Kontrak sumber data untuk abstraksi Repository Pattern (Tahap 9 - Poin 52)
abstract class CourseDataSource {
  Future<List<Course>> getCourses();
  Future<Course> createCourse(Course course);
  Future<void> updateCourse(int id, Course course);
  Future<void> deleteCourse(int id);
}
