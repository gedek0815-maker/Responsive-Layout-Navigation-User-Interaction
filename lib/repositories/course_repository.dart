import '../models/course.dart';
import '../services/course_data_source.dart';

// Repository Pattern: Menggunakan CourseDataSource sebagai abstraksi (Tahap 9 - Poin 53)
class CourseRepository {
  CourseRepository(this.dataSource);

  final CourseDataSource dataSource;

  Future<List<Course>> getCourses() => dataSource.getCourses();

  Future<Course> createCourse(Course course) =>
      dataSource.createCourse(course);

  Future<void> updateCourse(int id, Course course) =>
      dataSource.updateCourse(id, course);

  Future<void> deleteCourse(int id) =>
      dataSource.deleteCourse(id);
}
