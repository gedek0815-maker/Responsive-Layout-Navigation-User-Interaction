import 'package:flutter/material.dart';

// Identitas Mahasiswa wajib dicantumkan
const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

void main() {
  runApp(const TahapSembilanApp());
}

class TahapSembilanApp extends StatelessWidget {
  const TahapSembilanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 9: Returning Data Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
        useMaterial3: true,
      ),
      home: const CourseHomeWithReturnPage(),
    );
  }
}

// 1. Halaman Utama yang menunggu kembalian data (await Navigator.push)
class CourseHomeWithReturnPage extends StatefulWidget {
  const CourseHomeWithReturnPage({super.key});

  @override
  State<CourseHomeWithReturnPage> createState() =>
      _CourseHomeWithReturnPageState();
}

class _CourseHomeWithReturnPageState extends State<CourseHomeWithReturnPage> {
  // Status favorit untuk item pengujian
  bool _isFavorite = false;

  final Map<String, dynamic> sampleCourse = {
    'code': 'MOB04',
    'title': 'Responsive Layout & Navigation',
    'status': 'active',
    'instructor': 'Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom',
  };

  // Fungsi navigasi yang meng-await kembalian data
  Future<void> _navigateToDetail(BuildContext context) async {
    final bool? result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => DetailConfirmPage(course: sampleCourse),
      ),
    );

    // Jika data hasil bernilai true, perbarui state dan tampilkan SnackBar
    if (result == true && mounted) {
      setState(() {
        _isFavorite = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sukses: "${sampleCourse['title']}" telah ditambahkan ke favorit!',
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Tahap 9: Returning Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(
                            Icons.school,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                        title: Text(
                          sampleCourse['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${sampleCourse['code']} • ${sampleCourse['instructor']}',
                        ),
                        trailing: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                      const Divider(),
                      Text(
                        _isFavorite
                            ? 'Status: Kursus ini SUDAH difavoritkan'
                            : 'Status: Kursus ini BELUM difavoritkan',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _isFavorite
                              ? Colors.green.shade800
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Buka Detail untuk Memilih Favorit'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () => _navigateToDetail(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. Halaman Detail yang mengembalikan data (Navigator.pop(context, true))
class DetailConfirmPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const DetailConfirmPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course['title']),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Identitas: $studentId - $studentName',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const Divider(height: 24),
            Text(
              course['title'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Kode: ${course['code']}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Dosen: ${course['instructor']}',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.favorite),
                label: const Text('Pilih / Tandai Favorit (Return true)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Mengembalikan nilai true ke halaman asal lewat pop
                  Navigator.pop(context, true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
