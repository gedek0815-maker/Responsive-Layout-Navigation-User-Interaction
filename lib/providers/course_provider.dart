import 'package:flutter/material.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  List<Course> courses = [];
  final Set<String> favorites = {};

  bool isLoading = false;
  bool isSaving = false;
  String? error;

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

  Future<bool> createCourse(Course course) async {
    if (isSaving) return false;

    isSaving = true;
    notifyListeners();

    try {
      await repository.createCourse(course);
      await loadCourses();
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // Memperbarui course yang sudah ada (HTTP PUT - Tahap 7).
  Future<bool> updateCourse(int id, Course course) async {
    if (isSaving) return false;

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await repository.updateCourse(id, course);

      // Perbarui data course di list lokal agar perubahan langsung tampil di UI (Poin 45).
      final index = courses.indexWhere((c) => c.code == course.code);
      if (index != -1) {
        courses[index] = course;
      }

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // Menghapus course menggunakan HTTP DELETE (Tahap 8).
  Future<bool> deleteCourse(String code, int apiId) async {
    if (isSaving) return false;

    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await repository.deleteCourse(apiId);

      // Poin 49: Hapus course dari daftar lokal untuk me-refresh tampilan.
      courses.removeWhere((course) => course.code == code);

      // Poin 51: Jika course ada di favorites, hapus juga agar tidak tersisa data yatim.
      favorites.remove(code);

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  bool isFavorite(String code) {
    return favorites.contains(code);
  }

  void toggleFavorite(String code) {
    if (favorites.contains(code)) {
      favorites.remove(code);
    } else {
      favorites.add(code);
    }

    notifyListeners();
  }

  List<Course> get favoriteCourses {
    return courses.where((course) => favorites.contains(course.code)).toList();
  }
}
