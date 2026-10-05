import 'package:flutter/material.dart';

// Identitas Mahasiswa wajib dicantumkan
const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

void main() {
  runApp(const TahapTujuhApp());
}

class TahapTujuhApp extends StatelessWidget {
  const TahapTujuhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 7: Navigation Dasar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// 1. Halaman Utama (HomePage)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 7: Navigation Stack'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home, size: 72, color: Color(0xFF1976D2)),
              const SizedBox(height: 16),
              const Text(
                'Halaman Utama (HomePage)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '$studentId - $studentName',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              const Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Status Stack: [ HomePage ]\nTekan tombol di bawah untuk menambah DetailPage ke tumpukan (push).',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Tombol Navigator.push()
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Buka Halaman Detail'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DetailPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. Halaman Detail (DetailPage)
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Detail'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        // Tombol back panah kiri bawaan otomatis tersedia di sini
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.article, size: 72, color: Colors.indigo),
              const SizedBox(height: 16),
              const Text(
                'Halaman Detail (DetailPage)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '$studentId - $studentName',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              const Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Status Stack: [ HomePage, DetailPage ]\nTekan tombol kembali di bawah atau tombol back pada AppBar untuk pop.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Tombol Navigator.pop()
              OutlinedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali ke Home (Navigator.pop)'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
