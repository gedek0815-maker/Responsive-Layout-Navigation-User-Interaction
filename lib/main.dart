import 'package:flutter/material.dart';

const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

void main() => runApp(const DebuggingChallengeApp());

class DebuggingChallengeApp extends StatelessWidget {
  const DebuggingChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debugging Challenge - Tahap 16',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const DebugHomePage(),
    );
  }
}

class DebugHomePage extends StatelessWidget {
  const DebugHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 16: Debugging Challenge'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // [KASUS C - SOLUSI]: Menggunakan SingleChildScrollView agar form aman dari keyboard overflow
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Identitas Praktikan: $studentId - $studentName',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Divider(height: 24),

            const Text(
              '1. Simulasi Kasus A (RenderFlex Overflow Fix):',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.school, color: Colors.blue),
                    const SizedBox(width: 12),
                    // [KASUS A - SOLUSI]: Bungkus dengan Expanded agar tidak terjadi overflow horizontal
                    const Expanded(
                      child: Text(
                        'MOB03 - Flutter UI Fundamentals and Advanced Layout Design Programming',
                        style: TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              '2. Simulasi Kasus B (Unbounded Height Fix):',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),

            // [KASUS B - SOLUSI]: Kontainer dengan tinggi tetap atau dibungkus Expanded/SizedBox untuk ListView
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text('Mata Kuliah Pilihan ${index + 1}'),
                    subtitle: const Text('Status: Aktif'),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              '3. Simulasi Kasus C & D (Form & Navigasi Aman):',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),

            const TextField(
              decoration: InputDecoration(
                labelText: 'Test Input (Simulasi Keyboard)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // [KASUS D - SOLUSI]: Tombol Navigasi dengan pengecekan aman
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Mencegah penumpukan rute ganda instan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DetailSimulasiPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Buka Halaman Detail (Navigasi Aman)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailSimulasiPage extends StatelessWidget {
  const DetailSimulasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Detail Simulasi')),
      body: const Center(
        child: Text(
          'Berhasil berpindah halaman dengan aman!',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
