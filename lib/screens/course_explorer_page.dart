import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

final Map<String, dynamic> sampleCourseJson = {
  'code': 'PTI107',
  'title': 'Pemodelan Data JSON',
  'credits': 3,
  'status': 'Contoh Hasil Parsing',
};

final Course parsedCourse = Course.fromJson(sampleCourseJson);

class CourseExplorerPage extends StatefulWidget {
  const CourseExplorerPage({super.key});

  @override
  State<CourseExplorerPage> createState() => _CourseExplorerPageState();
}

class _CourseExplorerPageState extends State<CourseExplorerPage> {
  String searchQuery = '';
  bool showFavoritesOnly = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;
      Future.microtask(() => context.read<CourseProvider>().loadCourses());
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course Explorer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.redAccent),
                const SizedBox(width: 6),
                Text(
                  '${provider.favoriteCount}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Identitas mahasiswa.
          Card(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text(
                studentName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('NIM: $studentId'),
            ),
          ),

          // Contoh parsing model Course.
          Card(
            margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hasil Parsing Model Course',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('Kode: ${parsedCourse.code}'),
                  Text('Nama: ${parsedCourse.title}'),
                  Text('SKS: ${parsedCourse.credits}'),
                  Text('Status: ${parsedCourse.status}'),
                ],
              ),
            ),
          ),

          // Pencarian.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari mata kuliah...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Filter daftar mata kuliah.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Semua Mata Kuliah'),
                    selected: !showFavoritesOnly,
                    onSelected: (_) {
                      setState(() {
                        showFavoritesOnly = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Favorites'),
                  selected: showFavoritesOnly,
                  onSelected: (_) {
                    setState(() {
                      showFavoritesOnly = true;
                    });
                  },
                ),
              ],
            ),
          ),

          // Loading, error, atau daftar mata kuliah.
          Expanded(
            child: Builder(
              builder: (context) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(
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
                            'Gagal memuat data mata kuliah.',
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
                  );
                }

                final filteredCourses = provider.courses.where((course) {
                  final query = searchQuery.toLowerCase();

                  final matchesSearch =
                      course.title.toLowerCase().contains(query) ||
                      course.code.toLowerCase().contains(query);

                  final matchesFavorite =
                      !showFavoritesOnly || provider.isFavorite(course.code);

                  return matchesSearch && matchesFavorite;
                }).toList();

                if (filteredCourses.isEmpty) {
                  return Center(
                    child: Text(
                      showFavoritesOnly
                          ? 'Belum ada mata kuliah favorit.'
                          : 'Mata kuliah tidak ditemukan.',
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    return CourseCard(course: filteredCourses[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
