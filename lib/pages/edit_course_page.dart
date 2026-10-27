import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class EditCoursePage extends StatefulWidget {
  final Course course;
  final int apiId;

  const EditCoursePage({super.key, required this.course, required this.apiId});

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _titleController;
  late final TextEditingController _creditsController;

  static const List<String> _statusOptions = [
    'Aktif',
    'Planned',
    'Active',
    'Done',
  ];

  late String _status;

  List<String> get _dropdownOptions {
    if (!_statusOptions.contains(_status)) {
      return [_status, ..._statusOptions];
    }
    return _statusOptions;
  }

  @override
  void initState() {
    super.initState();

    // 42. Isi form edit dengan data lama; field code dibuat read-only
    _codeController = TextEditingController(text: widget.course.code);
    _titleController = TextEditingController(text: widget.course.title);
    _creditsController = TextEditingController(
      text: '${widget.course.credits}',
    );

    final currentStatus = widget.course.status;
    _status = _statusOptions.firstWhere(
      (s) => s.toLowerCase() == currentStatus.toLowerCase(),
      orElse: () => currentStatus,
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedCourse = Course(
      code: widget.course.code,
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _status,
    );

    // 43 & 44. Kirim perubahan menggunakan PUT/PATCH via CourseProvider
    final success = await context.read<CourseProvider>().updateCourse(
      widget.apiId,
      updatedCourse,
    );

    // 44. Pemeriksaan context.mounted sebelum menampilkan SnackBar
    if (!mounted) return;

    // 45. Tampilkan hasil
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Request update berhasil.' : 'Gagal memperbarui course.',
        ),
      ),
    );

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 44. Terapkan guard submit ganda
    final isSaving = context.watch<CourseProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Course')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 42. Field code dibuat read-only
            TextFormField(
              controller: _codeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Code (tidak dapat diubah)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Title wajib diisi'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _creditsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Credits',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final credits = int.tryParse(value ?? '');
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
              items: _dropdownOptions.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _status = value);
                      }
                    },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSaving ? null : _submit,
              child: isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
