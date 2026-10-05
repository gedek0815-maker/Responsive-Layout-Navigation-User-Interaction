import 'package:flutter/material.dart';

void main() {
  runApp(const TahapLimaApp());
}

class TahapLimaApp extends StatelessWidget {
  const TahapLimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 5: Responsive GridView',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
        useMaterial3: true,
      ),
      home: const ResponsiveCourseGridPage(),
    );
  }
}

class ResponsiveCourseGridPage extends StatelessWidget {
  const ResponsiveCourseGridPage({super.key});

  // Data JSON asli dari pertemuan sebelumnya
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

  // Fungsi penentuan jumlah kolom responsif sesuai breakpoint modul
  int columnsFor(double width) {
    if (width < 600) return 1; // Compact (<600)
    if (width < 840) return 2; // Medium (600-839)
    return 3; // Expanded (>=840)
  }

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
              'Tahap 5: Responsive GridView',
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final int crossAxisCount = columnsFor(constraints.maxWidth);

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Bar Breakpoint
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lebar Layar: ${constraints.maxWidth.toStringAsFixed(0)} px',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      Text(
                        'Kolom: $crossAxisCount (${crossAxisCount == 1
                            ? "Compact"
                            : crossAxisCount == 2
                            ? "Medium"
                            : "Expanded"})',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // GridView Responsif
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: crossAxisCount == 1 ? 3.0 : 2.2,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final courseItem = courses[index] as Map<String, dynamic>;
                      return CourseCard(course: courseItem);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Reusable CourseCard Widget
class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseCard({super.key, required this.course});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return Colors.blue;
      case 'active':
        return Colors.green;
      case 'planned':
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return Icons.check_circle_outline;
      case 'active':
        return Icons.play_circle_outline;
      case 'planned':
      default:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String;
    final statusColor = _getStatusColor(status);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: statusColor.withOpacity(0.15),
              child: Icon(_getStatusIcon(status), color: statusColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${course['code']} • ${course['credits']} SKS',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    course['instructor'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: statusColor.withOpacity(0.5)),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
