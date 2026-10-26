import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/error_view.dart';

class CourseExplorerPage extends StatefulWidget {
  const CourseExplorerPage({super.key});

  @override
  State<CourseExplorerPage> createState() => _CourseExplorerPageState();
}

class _CourseExplorerPageState extends State<CourseExplorerPage> {
  @override
  void initState() {
    super.initState();

    // Panggil loadCourses saat halaman dibuat,
    // bukan di dalam build().
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CourseProvider>().loadCourses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    // 1. Loading State
    if (provider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Explorer')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Sedang memuat data course...'),
            ],
          ),
        ),
      );
    }

    // 2. Error State
    if (provider.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Explorer')),
        body: ErrorView(
          message: provider.error.toString(),
          onRetry: provider.loadCourses,
        ),
      );
    }

    // 3. Empty State
    if (provider.courses.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Explorer')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, size: 56, color: Colors.grey),
              SizedBox(height: 12),
              Text('Data course belum tersedia'),
            ],
          ),
        ),
      );
    }

    // 4. Success State
    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      body: RefreshIndicator(
        onRefresh: provider.loadCourses,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: provider.courses.length,
          itemBuilder: (context, index) {
            final course = provider.courses[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(course.code.toString()),
                subtitle: const Text('Data course berhasil dimuat'),
              ),
            );
          },
        ),
      ),
    );
  }
}
