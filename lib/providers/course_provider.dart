import 'package:flutter/foundation.dart';

class CourseProvider extends ChangeNotifier {
  // Menyimpan kode mata kuliah yang ditandai sebagai favorit.
  final Set<String> _favorites = <String>{};

  // Mengambil data favorites tanpa memberikan akses untuk mengubah
  // koleksi aslinya secara langsung.
  Set<String> get favorites => Set.unmodifiable(_favorites);

  // Menghitung jumlah mata kuliah favorit.
  int get favoriteCount => _favorites.length;

  // Memeriksa apakah mata kuliah sudah menjadi favorit.
  bool isFavorite(String code) {
    return _favorites.contains(code);
  }

  // Menambahkan atau menghapus mata kuliah dari favorites.
  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }

    // Memberi tahu widget yang mendengarkan provider
    // bahwa state telah berubah.
    notifyListeners();
  }

  // Menghapus seluruh mata kuliah favorit.
  void clearFavorites() {
    if (_favorites.isEmpty) return;

    _favorites.clear();
    notifyListeners();
  }
}
