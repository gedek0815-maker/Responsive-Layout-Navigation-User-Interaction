import 'package:flutter/material.dart';

const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

void main() {
  runApp(const TahapEnamApp());
}

class TahapEnamApp extends StatelessWidget {
  const TahapEnamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 6: Scrollable Content',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
        useMaterial3: true,
      ),
      home: const ScrollableFormPage(),
    );
  }
}

class ScrollableFormPage extends StatelessWidget {
  const ScrollableFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Tahap 6: Scrollable & Keyboard',
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
      // SingleChildScrollView mencegah terjadinya overflow saat keyboard virtual muncul
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profil
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    studentName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'NIM: $studentId | Kelas PTI 5B',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),

            const Text(
              'Formulir Uji Keyboard Overflow',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Daftar Input Fields yang panjang ke bawah
            _buildInputField('Nama Lengkap', initialValue: studentName),
            _buildInputField('Nomor Induk Mahasiswa', initialValue: studentId),
            _buildInputField(
              'Mata Kuliah',
              initialValue: 'Pemrograman Aplikasi Bergerak',
            ),
            _buildInputField(
              'Dosen Pengampu',
              initialValue: 'Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom',
            ),
            _buildInputField(
              'Topik Praktikum',
              initialValue: 'Pertemuan 5: Responsive, Navigation, Interaction',
            ),
            _buildInputField(
              'Catatan Refleksi',
              hint: 'Ketik catatan di sini untuk menguji keyboard...',
              maxLines: 3,
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Simpan Data Profil'),
                onPressed: () {
                  FocusScope.of(context).unfocus(); // Menutup keyboard
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Formulir berhasil diproses!'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label, {
    String? initialValue,
    String? hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }
}
