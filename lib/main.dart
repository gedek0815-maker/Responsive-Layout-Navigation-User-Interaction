import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';

// Identitas mahasiswa
const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

// Data contoh mata kuliah
class Course {
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });
}

const List<Course> courseList = [
  Course(
    code: 'PTI601',
    title: 'Pemrograman Mobile',
    credits: 3,
    status: 'Sedang Dipelajari',
  ),
  Course(
    code: 'PTI602',
    title: 'Pemrograman Berorientasi Objek',
    credits: 3,
    status: 'Sedang Dipelajari',
  ),
  Course(
    code: 'PTI603',
    title: 'Jaringan Komputer',
    credits: 3,
    status: 'Sedang Dipelajari',
  ),
  Course(
    code: 'PTI604',
    title: 'Strategi Pembelajaran',
    credits: 2,
    status: 'Sedang Dipelajari',
  ),
  Course(
    code: 'PTI605',
    title: 'Rekayasa Perangkat Lunak',
    credits: 3,
    status: 'Belum Dipelajari',
  ),
  Course(
    code: 'PTI606',
    title: 'Basis Data',
    credits: 3,
    status: 'Belum Dipelajari',
  ),
];

void main() {
  runApp(
    ChangeNotifierProvider<CourseProvider>(
      create: (context) => CourseProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: const CourseHomePage(),
    );
  }
}

class CourseHomePage extends StatefulWidget {
  const CourseHomePage({super.key});

  @override
  State<CourseHomePage> createState() => _CourseHomePageState();
}

class _CourseHomePageState extends State<CourseHomePage> {
  // Local state: filter pencarian hanya digunakan halaman ini.
  String searchQuery = '';

  // Local state: filter kategori pada halaman ini.
  String selectedFilter = 'Semua';

  List<Course> get filteredCourses {
    return courseList.where((course) {
      final matchesSearch =
          course.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          course.code.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesFilter =
          selectedFilter == 'Semua' ||
          (selectedFilter == 'Favorit' &&
              context.read<CourseProvider>().isFavorite(course.code)) ||
          (selectedFilter == 'Belum Favorit' &&
              !context.read<CourseProvider>().isFavorite(course.code));

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Shared state: widget mendengarkan perubahan CourseProvider.
    final provider = context.watch<CourseProvider>();

    final courses = filteredCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course Explorer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.white),
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
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 650;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  children: [
                    // Identitas mahasiswa
                    _buildStudentHeader(),

                    // Informasi jumlah mata kuliah
                    _buildSummary(provider.favoriteCount),

                    // Pencarian
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari mata kuliah...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),

                    // Filter mata kuliah
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          _buildFilterChip('Semua'),
                          _buildFilterChip('Favorit'),
                          _buildFilterChip('Belum Favorit'),
                        ],
                      ),
                    ),

                    // Judul daftar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Daftar Mata Kuliah',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '${courses.length} mata kuliah',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),

                    // Daftar mata kuliah
                    Expanded(
                      child: courses.isEmpty
                          ? _buildEmptyState()
                          : isWide
                          ? _buildGrid(courses)
                          : _buildList(courses),
                    ),

                    // Identitas bagian bawah
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: Colors.white,
                      child: const Text(
                        '$studentName | NIM: $studentId',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStudentHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.person, size: 32, color: Colors.blue),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text('NIM: $studentId'),
                SizedBox(height: 4),
                Text('Pemrograman Mobile - Pertemuan 6'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(int favoriteCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.menu_book,
              title: 'Total Course',
              value: '${courseList.length}',
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              icon: Icons.favorite,
              title: 'Favorit',
              value: '$favoriteCount',
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selectedFilter == label,
        onSelected: (selected) {
          if (!selected) return;

          setState(() {
            selectedFilter = label;
          });
        },
      ),
    );
  }

  Widget _buildList(List<Course> courses) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return CourseCard(course: courses[index]);
      },
    );
  }

  Widget _buildGrid(List<Course> courses) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 420,
        mainAxisExtent: 125,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return CourseCard(course: courses[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Mata kuliah tidak ditemukan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              'Coba kata kunci atau filter lainnya.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Membaca state Provider untuk menentukan ikon favorit.
    final provider = context.watch<CourseProvider>();
    final isFavorite = provider.isFavorite(course.code);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              child: const Icon(Icons.menu_book, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${course.code} • ${course.credits} SKS',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    course.status,
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
              onPressed: () {
                // read() dipakai untuk menjalankan aksi
                // tanpa membuat listener baru.
                context.read<CourseProvider>().toggleFavorite(course.code);
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
                size: 27,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
