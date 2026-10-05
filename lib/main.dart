import 'package:flutter/material.dart';

// Identitas Mahasiswa wajib dicantumkan
const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

void main() {
  runApp(const TahapTigaApp());
}

class TahapTigaApp extends StatelessWidget {
  const TahapTigaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tahap 3: LayoutBuilder & Breakpoint'),
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
        ),
        // LayoutBuilder membaca constraints yang diberikan parent
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return const CompactLayout();
            } else if (constraints.maxWidth < 840) {
              return const MediumLayout();
            } else {
              return const ExpandedLayout();
            }
          },
        ),
      ),
    );
  }
}

// 1. Tampilan Layar Compact (< 600 px) - Tumpukan Vertikal 1 Kolom
class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber.shade50,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.phone_android, size: 70, color: Colors.amber),
          const SizedBox(height: 16),
          const Text(
            'Kategori: COMPACT (< 600 px)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '$studentId - $studentName',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Tampilan 1 Kolom Vertikal (Cocok untuk Smartphone Portrait)',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. Tampilan Layar Medium (600 - 839 px) - Susunan Berdampingan 2 Kartu
class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue.shade50,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.tablet, size: 70, color: Colors.blue),
          const SizedBox(height: 16),
          const Text(
            'Kategori: MEDIUM (600 - 839 px)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '$studentId - $studentName',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Panel Kiri: Daftar Konten',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Panel Kanan: Pratinjau',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 3. Tampilan Layar Expanded (>= 840 px) - Dashboard Lebar Berwarna Hijau
class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightGreen.shade50,
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.desktop_windows, size: 80, color: Colors.green),
          const SizedBox(height: 16),
          const Text(
            'Kategori: EXPANDED (>= 840 px)',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '$studentId - $studentName',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          Row(
            children: const [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Navigasi Samping',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Area Kerja Utama (Expanded View)',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Panel Info Detail',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
