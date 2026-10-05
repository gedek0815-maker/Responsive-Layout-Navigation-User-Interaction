import 'package:flutter/material.dart';

// Identitas Mahasiswa wajib dicantumkan
const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

void main() {
  runApp(const TahapEmpatApp());
}

class TahapEmpatApp extends StatelessWidget {
  const TahapEmpatApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Kumpulan skill/materi untuk pengujian Wrap
    final List<String> skills = [
      'Constraints',
      'MediaQuery',
      'LayoutBuilder',
      'Expanded',
      'Flexible',
      'Wrap Layout',
      'NavigationRail',
      'State Management',
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tahap 4: Expanded & Wrap Demo'),
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Identitas Mahasiswa
              const Text(
                '$studentId - $studentName',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(height: 16),

              // Bagian 1: Pengujian Expanded dengan rasio Flex 2:1
              const Text(
                '1. Pembagian Ruang Row (Flex 2 : 1)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Panel A (Flex: 2)\n66.6% Ruang',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Panel B (Flex: 1)\n33.3% Ruang',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bagian 2: Pengujian Wrap vs Row biasa
              const Text(
                '2. Daftar Skill Menggunakan Wrap (Anti-Overflow)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0, // Jarak horizontal antar chip
                runSpacing: 8.0, // Jarak vertikal saat berpindah baris
                children: skills
                    .map(
                      (skill) => Chip(
                        avatar: const CircleAvatar(
                          backgroundColor: Color(0xFF1976D2),
                          child: Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                        label: Text(skill),
                        backgroundColor: Colors.blue.shade50,
                        side: BorderSide(color: Colors.blue.shade200),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Kartu Analisis
              Card(
                color: Colors.amber.shade50,
                elevation: 1,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Catatan: Jika daftar chip di atas ditaruh dalam Row biasa tanpa scroll, akan terjadi RenderFlex overflow pada tepi kanan layar. Wrap secara otomatis melipat item ke baris baru.',
                    style: TextStyle(fontSize: 13, color: Colors.brown),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
