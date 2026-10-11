import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/course.dart';
import 'providers/course_provider.dart';
import 'services/course_service.dart';

const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

// Contoh parsing dari Tahap 8 tetap dipertahankan.
final Map<String, dynamic> sampleCourseJson = {
  'code': 'PTI107',
  'title': 'Pemodelan Data JSON',
  'credits': 3,
  'status': 'Contoh Hasil Parsing',
};

final Course parsedCourse = Course.fromJson(sampleCourseJson);

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CourseExplorerPage(),
    );
  }
}

class CourseExplorerPage extends StatefulWidget {
  const CourseExplorerPage({super.key});

  @override
  State<CourseExplorerPage> createState() => _CourseExplorerPageState();
}

class _CourseExplorerPageState extends State<CourseExplorerPage> {
  final CourseService _courseService = CourseService();

  late Future<List<Course>> _coursesFuture;

  String searchQuery = '';
  bool showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _courseService.loadCourses();
  }

  void reloadCourses() {
    setState(() {
      _coursesFuture = _courseService.loadCourses();
    });
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
      body: FutureBuilder<List<Course>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
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
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: reloadCourses,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final courses = snapshot.data ?? <Course>[];

          final filteredCourses = courses.where((course) {
            final query = searchQuery.toLowerCase();

            final matchesSearch =
                course.title.toLowerCase().contains(query) ||
                course.code.toLowerCase().contains(query);

            final matchesFavorite =
                !showFavoritesOnly || provider.isFavorite(course.code);

            return matchesSearch && matchesFavorite;
          }).toList();

          return Column(
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

              // Hasil parsing dari Tahap 8.
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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

              // Pencarian mata kuliah.
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

              // Filter seluruh mata kuliah atau favorites.
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
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

              // Daftar data yang dimuat melalui CourseService.
              Expanded(
                child: filteredCourses.isEmpty
                    ? Center(
                        child: Text(
                          showFavoritesOnly
                              ? 'Belum ada mata kuliah favorit.'
                              : 'Mata kuliah tidak ditemukan.',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: filteredCourses.length,
                        itemBuilder: (context, index) {
                          final course = filteredCourses[index];

                          return CourseCard(course: course);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<CourseProvider, bool>(
      (provider) => provider.isFavorite(course.code),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.menu_book),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            'Kode: ${course.code}\n'
            'SKS: ${course.credits} | Status: ${course.status}',
          ),
        ),
        isThreeLine: true,
        trailing: IconButton(
          tooltip: isFavorite ? 'Hapus dari favorites' : 'Tambah ke favorites',
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            context.read<CourseProvider>().toggleFavorite(course.code);
          },
        ),
      ),
    );
  }
}
