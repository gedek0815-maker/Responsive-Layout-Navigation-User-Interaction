import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'favorites_page.dart';

const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

class CourseExplorerPage extends StatefulWidget {
  const CourseExplorerPage({super.key});

  @override
  State<CourseExplorerPage> createState() => _CourseExplorerPageState();
}

class _CourseExplorerPageState extends State<CourseExplorerPage> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';
  bool filterFavorites = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    final List<Course> displayedCourses = provider.courses.where((course) {
      final query = searchQuery.toLowerCase();

      final matchesSearch =
          course.title.toLowerCase().contains(query) ||
          course.code.toLowerCase().contains(query) ||
          course.status.toLowerCase().contains(query);

      final matchesFavorite =
          !filterFavorites || provider.isFavorite(course.code);

      return matchesSearch && matchesFavorite;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        actions: [
          IconButton(
            tooltip: 'Mata Kuliah Favorit',
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Identitas mahasiswa
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  studentName,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text('NIM: $studentId'),
                const SizedBox(height: 8),
                Text('Total mata kuliah: ${provider.courses.length}'),
                Text('Total favorit: ${provider.favorites.length}'),
              ],
            ),
          ),

          // Pencarian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari mata kuliah...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Filter favorit
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Favorit saja'),
                  avatar: const Icon(Icons.favorite_border),
                  selected: filterFavorites,
                  onSelected: (value) {
                    setState(() {
                      filterFavorites = value;
                    });
                  },
                ),
                const Spacer(),
                Text('${displayedCourses.length} mata kuliah'),
              ],
            ),
          ),

          // Loading, error, atau daftar mata kuliah
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Gagal memuat mata kuliah.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(provider.error!, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<CourseProvider>().loadCourses();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  )
                : displayedCourses.isEmpty
                ? const Center(child: Text('Mata kuliah tidak ditemukan.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: displayedCourses.length,
                    itemBuilder: (context, index) {
                      return CourseCard(course: displayedCourses[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
