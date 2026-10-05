import 'package:flutter/material.dart';

const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

void main() => runApp(const TahapTigabelasApp());

class TahapTigabelasApp extends StatelessWidget {
  const TahapTigabelasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tahap13Page(),
    );
  }
}

class Tahap13Page extends StatefulWidget {
  const Tahap13Page({super.key});

  @override
  State<Tahap13Page> createState() => _Tahap13PageState();
}

class _Tahap13PageState extends State<Tahap13Page> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: studentName);
  final _nimController = TextEditingController(text: studentId);
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 13: Form & Validation'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(labelText: 'NIM'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'NIM wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Komentar / Feedback',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().length < 5) {
                    return 'Komentar minimal harus 5 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Form valid dan berhasil diproses!'),
                      ),
                    );
                  }
                },
                child: const Text('Kirim Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
