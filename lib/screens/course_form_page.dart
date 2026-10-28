import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseFormPage extends StatefulWidget {
  final Course? course;

  const CourseFormPage({super.key, this.course});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _titleController;
  late final TextEditingController _creditsController;

  static const List<String> _statusOptions = [
    'planned',
    'active',
    'done',
  ];

  late String _status;
  bool get isEditing => widget.course != null;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.course?.code ?? '');
    _titleController = TextEditingController(text: widget.course?.title ?? '');
    _creditsController = TextEditingController(
      text: widget.course != null ? '${widget.course!.credits}' : '',
    );

    final currentStatus = widget.course?.status.toLowerCase() ?? 'planned';
    _status = _statusOptions.contains(currentStatus) ? currentStatus : 'planned';
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

    final provider = context.read<CourseProvider>();

    if (isEditing) {
      final updatedCourse = Course(
        id: widget.course!.id,
        code: widget.course!.code,
        title: _titleController.text.trim(),
        credits: int.parse(_creditsController.text.trim()),
        status: _status,
      );

      final success = await provider.updateCourse(
        widget.course!.id ?? 0,
        updatedCourse,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Course ${widget.course!.code} berhasil diperbarui di database!'
                : 'Gagal memperbarui course: ${provider.error ?? "Periksa koneksi"}',
          ),
        ),
      );

      if (success) Navigator.pop(context);
    } else {
      final newCourse = Course(
        code: _codeController.text.trim(),
        title: _titleController.text.trim(),
        credits: int.parse(_creditsController.text.trim()),
        status: _status,
      );

      final success = await provider.createCourse(newCourse);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Course ${newCourse.code} berhasil ditambahkan ke database!'
                : 'Gagal menambah course: ${provider.error ?? "Periksa koneksi"}',
          ),
        ),
      );

      if (success) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<CourseProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditing ? 'Edit Course' : 'Tambah Course',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
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
              readOnly: isEditing,
              decoration: InputDecoration(
                labelText: isEditing ? 'Code (tidak dapat diubah)' : 'Code',
                hintText: 'Contoh: CS301',
                border: const OutlineInputBorder(),
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
                        setState(() => _status = value);
                      }
                    },
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: isSaving ? null : _submit,
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
                    : Text(isEditing ? 'Simpan Perubahan' : 'Simpan Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

