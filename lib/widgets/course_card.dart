import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<CourseProvider, bool>(
      (provider) => provider.isFavorite(course.code),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.menu_book),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            'Kode: ${course.code}\n'
            'SKS: ${course.credits} | Status: ${course.status}',
          ),
        ),
        isThreeLine: true,
        trailing: IconButton(
          tooltip: isFavorite ? 'Hapus dari favorites' : 'Tambah ke favorites',
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            context.read<CourseProvider>().toggleFavorite(course.code);
          },
        ),
      ),
    );
  }
}
