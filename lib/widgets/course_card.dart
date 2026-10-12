import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_page.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favorite = provider.isFavorite(course.code);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
          );
        },
        leading: const CircleAvatar(child: Icon(Icons.menu_book)),
        title: Text(course.title),
        subtitle: Text(
          '${course.code} • ${course.credits} SKS • ${course.status}',
        ),
        trailing: IconButton(
          tooltip: favorite ? 'Hapus favorit' : 'Tambah favorit',
          icon: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            color: favorite ? Colors.red : null,
          ),
          onPressed: () {
            context.read<CourseProvider>().toggleFavorite(course.code);
          },
        ),
      ),
    );
  }
}
