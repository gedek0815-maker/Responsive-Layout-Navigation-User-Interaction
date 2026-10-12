import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  // State data mata kuliah
  List<Course> courses = [];

  // State loading dan error
  bool isLoading = false;
  String? error;

  // State favorites
  final Set<String> _favorites = <String>{};

  Set<String> get favorites => Set.unmodifiable(_favorites);

  int get favoriteCount => _favorites.length;

  bool isFavorite(String code) {
    return _favorites.contains(code);
  }

  // Mengambil data melalui Repository
  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Menambah atau menghapus mata kuliah favorit
  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }

    notifyListeners();
  }

  // Menghapus semua favorit
  void clearFavorites() {
    if (_favorites.isEmpty) return;

    _favorites.clear();
    notifyListeners();
  }
}
