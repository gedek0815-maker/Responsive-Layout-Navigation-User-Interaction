import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_page.dart';
import '../screens/course_form_page.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CourseCard({
    super.key,
    required this.course,
    this.onEdit,
    this.onDelete,
  });

  Future<void> _handleDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Course?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus course "${course.title}" (${course.code})?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm != true || !context.mounted) return;

    final success = await context.read<CourseProvider>().deleteCourse(
          course.code,
          course.id ?? 0,
        );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Course ${course.code} berhasil dihapus dari database'
              : 'Gagal menghapus course ${course.code}',
        ),
      ),
    );
  }

  void _handleEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseFormPage(course: course),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favorite = provider.isFavorite(course.code);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
          );
        },
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.menu_book,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${course.code} • ${course.credits} SKS • ${course.status}',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Favorit
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: favorite ? 'Hapus favorit' : 'Tambah favorit',
              icon: Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: favorite ? Colors.red : Colors.grey,
                size: 22,
              ),
              onPressed: () {
                context.read<CourseProvider>().toggleFavorite(course.code);
              },
            ),
            // Tombol Edit
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: 'Edit course',
              icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 22),
              onPressed: onEdit ?? () => _handleEdit(context),
            ),
            // Tombol Hapus
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: 'Hapus course',
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
              onPressed: onDelete ?? () => _handleDelete(context),
            ),
          ],
        ),
      ),
    );
  }
}
