import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class CreateCoursePage extends StatefulWidget {
  const CreateCoursePage({super.key});

  @override
  State<CreateCoursePage> createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();

  // Tahap 13 - Poin 77: Validasi status dengan pilihan planned / active / done
  static const List<String> _statusOptions = [
    'planned',
    'active',
    'done',
  ];

  String _status = 'planned';

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) return;

    final course = Course(
      code: _codeController.text.trim(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _status,
    );

    final provider = context.read<CourseProvider>();
    final success = await provider.createCourse(course);

    if (!mounted) return;

    // Tahap 13 - Poin 79: Tampilkan notifikasi setelah berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Course ${course.code} berhasil ditambahkan ke database!'
              : 'Gagal menambah course: ${provider.error ?? "Periksa koneksi"}',
        ),
      ),
    );

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<CourseProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tambah Course',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Gede Krisna Adi Pramana | NIM: 2415051036',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Code',
                hintText: 'Contoh: PTI106',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Code wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Nama course',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _creditsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Credits',
                hintText: 'Contoh: 3',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Credits wajib diisi';
                }

                final credits = int.tryParse(value.trim());

                if (credits == null || credits <= 0) {
                  return 'Credits harus berupa angka positif';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: _statusOptions.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          _status = value;
                        });
                      }
                    },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSaving ? null : _saveCourse,
              child: isSaving
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Menyimpan...'),
                      ],
                    )
                  : const Text('Simpan Course'),
            ),
          ],
        ),
      ),
    );
  }
}
