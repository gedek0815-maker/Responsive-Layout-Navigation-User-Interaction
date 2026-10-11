import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/course.dart';
import 'providers/course_provider.dart';

const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

// Contoh data Map yang bentuknya menyerupai data JSON.
final Map<String, dynamic> sampleCourseJson = {
  'code': 'PTI107',
  'title': 'Pemodelan Data JSON',
  'credits': 3,
  'status': 'Contoh Hasil Parsing',
};

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const MyApp(),
    ),
  );
}

// Mengubah Map menjadi object Course menggunakan fromJson().
final Course parsedCourse = Course.fromJson(sampleCourseJson);

const List<Course> courseList = [
  Course(
    code: 'PTI101',
    title: 'Pemrograman Mobile',
    credits: 3,
    status: 'Sedang Dipelajari',
  ),
  Course(
    code: 'PTI102',
    title: 'Pemrograman Berorientasi Objek',
    credits: 3,
    status: 'Sedang Dipelajari',
  ),
  Course(
    code: 'PTI103',
    title: 'Jaringan Komputer',
    credits: 3,
    status: 'Selesai',
  ),
  Course(
    code: 'PTI104',
    title: 'Basis Data',
    credits: 3,
    status: 'Sedang Dipelajari',
  ),
  Course(
    code: 'PTI105',
    title: 'Strategi Pembelajaran',
    credits: 2,
    status: 'Selesai',
  ),
  Course(
    code: 'PTI106',
    title: 'Sistem Operasi',
    credits: 3,
    status: 'Sedang Dipelajari',
  ),
];

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
  final TextEditingController searchController = TextEditingController();

  String selectedFilter = 'Semua';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Course> get filteredCourses {
    final keyword = searchController.text.toLowerCase();
    final provider = context.read<CourseProvider>();

    return courseList.where((course) {
      final matchesSearch =
          course.title.toLowerCase().contains(keyword) ||
          course.code.toLowerCase().contains(keyword);

      final favorite = provider.isFavorite(course.code);

      bool matchesFilter;

      switch (selectedFilter) {
        case 'Favorit':
          matchesFilter = favorite;
          break;
        case 'Belum Favorit':
          matchesFilter = !favorite;
          break;
        default:
          matchesFilter = true;
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Tahap 7: watch mendengarkan perubahan state Provider.
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
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 6),
                Text(
                  '${provider.favoriteCount}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Identitas mahasiswa
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      child: Icon(Icons.person, size: 30),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            studentName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('NIM: $studentId'),
                          Text('Pendidikan Teknik Informatika'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Ringkasan aplikasi
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total Mata Kuliah',
                    value: '${courseList.length}',
                    icon: Icons.menu_book,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: 'Mata Kuliah Favorit',
                    value: '${provider.favoriteCount}',
                    icon: Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Bagian baru untuk membuktikan Course.fromJson().
            const Text(
              'Hasil Parsing Model Course',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Data Map berhasil diubah menjadi objek Course.'),
            const SizedBox(height: 8),

            Card(
              color: Colors.indigo.shade50,
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.data_object)),
                title: Text(parsedCourse.title),
                subtitle: Text(
                  'Kode: ${parsedCourse.code}\n'
                  'SKS: ${parsedCourse.credits}\n'
                  'Status: ${parsedCourse.status}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Daftar Mata Kuliah',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Pencarian
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama atau kode mata kuliah...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),

            const SizedBox(height: 12),

            // Filter
            DropdownButtonFormField<String>(
              value: selectedFilter,
              decoration: const InputDecoration(
                labelText: 'Filter mata kuliah',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                DropdownMenuItem(value: 'Favorit', child: Text('Favorit')),
                DropdownMenuItem(
                  value: 'Belum Favorit',
                  child: Text('Belum Favorit'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedFilter = value ?? 'Semua';
                });
              },
            ),

            const SizedBox(height: 16),

            // Daftar mata kuliah yang sudah ada sejak Tahap 7.
            if (courses.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Mata kuliah tidak ditemukan.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...courses.map((course) => CourseCard(course: course)),

            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: provider.favoriteCount == 0
                  ? null
                  : () {
                      // Tahap 7: read dipakai untuk menjalankan aksi.
                      context.read<CourseProvider>().clearFavorites();
                    },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Hapus Semua Favorit'),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade50,
          child: const Icon(Icons.menu_book, color: Colors.indigo),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${course.code} • ${course.credits} SKS\n'
          'Status: ${course.status}',
        ),
        isThreeLine: true,

        // Tahap 7: Consumer membatasi area yang mendengarkan state.
        trailing: Consumer<CourseProvider>(
          builder: (context, provider, child) {
            final isFavorite = provider.isFavorite(course.code);

            return IconButton(
              tooltip: isFavorite
                  ? 'Hapus dari favorit'
                  : 'Tambahkan ke favorit',
              onPressed: () {
                context.read<CourseProvider>().toggleFavorite(course.code);
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
}
