import 'package:flutter/material.dart';

void main() {
  runApp(const TahapDelapanApp());
}

class TahapDelapanApp extends StatelessWidget {
  const TahapDelapanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 8: Passing Data Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
        useMaterial3: true,
      ),
      home: const CourseListPage(),
    );
  }
}

// 1. Halaman Daftar Kursus (List Page)
class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  static const Map<String, dynamic> rawJsonData = {
    "student": {"nim": "2415051036", "name": "Gede Krisna Adi Pramana"},
    "courses": [
      {
        "code": "MOB01",
        "title": "Git & GitHub",
        "credits": 2,
        "status": "done",
        "instructor": "Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom",
      },
      {
        "code": "MOB02",
        "title": "Dart Fundamentals",
        "credits": 2,
        "status": "done",
        "instructor": "Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom",
      },
      {
        "code": "MOB03",
        "title": "Flutter UI Fundamentals",
        "credits": 3,
        "status": "active",
        "instructor": "Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom",
      },
      {
        "code": "MOB04",
        "title": "Navigation & Routing",
        "credits": 2,
        "status": "planned",
        "instructor": "Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom",
      },
      {
        "code": "MOB05",
        "title": "State Management",
        "credits": 3,
        "status": "planned",
        "instructor": "Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final student = rawJsonData['student'] as Map<String, dynamic>;
    final List courses = rawJsonData['courses'] as List;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tahap 8: Passing Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${student['nim']} - ${student['name']}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final course = courses[index] as Map<String, dynamic>;
          final bool isActive = course['status'] == 'active';

          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: isActive
                    ? Colors.green.shade100
                    : Colors.blue.shade100,
                child: Text(
                  course['code'].toString().substring(3),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? Colors.green.shade800
                        : Colors.blue.shade800,
                  ),
                ),
              ),
              title: Text(
                course['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${course['code']} • ${course['credits']} SKS'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
              // Passing Data: Kirim Map course ke CourseDetailPage
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailPage(
                      course: course,
                      studentInfo: '${student['nim']} - ${student['name']}',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 2. Halaman Detail (Detail Page yang menerima data via Constructor)
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;
  final String studentInfo;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.studentInfo,
  });

  @override
  Widget build(BuildContext context) {
    final status = course['status'].toString().toUpperCase();
    final bool isActive = course['status'] == 'active';

    return Scaffold(
      appBar: AppBar(
        title: Text(course['title']),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identitas Mahasiswa di Halaman Detail
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Data Mahasiswa:\n$studentInfo',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1976D2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Detail Data Course yang diterima
            Text(
              course['title'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text('${course['code']} • ${course['credits']} SKS'),
                  backgroundColor: Colors.grey.shade100,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? Colors.green.shade800
                          : Colors.blue.shade800,
                    ),
                  ),
                  backgroundColor: isActive
                      ? Colors.green.shade50
                      : Colors.blue.shade50,
                ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'Dosen Pengampu:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              course['instructor'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi Mata Kuliah:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              'Mata kuliah ini membahas konsep dan implementasi antarmuka pada Flutter secara menyeluruh, mencakup tata letak adaptif, navigasi tumpukan, serta interaksi pengguna.',
              style: TextStyle(fontSize: 15, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
