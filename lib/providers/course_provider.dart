import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  // Async state.
  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  // Shared favorite state dari tahap sebelumnya.
  final Set<String> _favorites = <String>{};

  Set<String> get favorites => Set.unmodifiable(_favorites);

  int get favoriteCount => _favorites.length;

  bool isFavorite(String code) {
    return _favorites.contains(code);
  }

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }

    notifyListeners();
  }

  void clearFavorites() {
    if (_favorites.isEmpty) return;

    _favorites.clear();
    notifyListeners();
  }

  // Memuat data melalui Repository.
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
}
