import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/error_view.dart';
import 'create_course_page.dart';

class CourseExplorerPage extends StatefulWidget {
  const CourseExplorerPage({super.key});

  @override
  State<CourseExplorerPage> createState() => _CourseExplorerPageState();
}

class _CourseExplorerPageState extends State<CourseExplorerPage> {
  @override
  void initState() {
    super.initState();

    // Memuat data satu kali saat halaman dibuat.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CourseProvider>().loadCourses();
      }
    });
  }

  void _openCreateCoursePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateCoursePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    // Loading State
    if (provider.isLoading && provider.courses.isEmpty) {
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

    // Error State ketika belum ada data.
    if (provider.error != null && provider.courses.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Explorer')),
        body: ErrorView(
          message: provider.error!,
          onRetry: provider.loadCourses,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openCreateCoursePage,
          tooltip: 'Tambah course',
          child: const Icon(Icons.add),
        ),
      );
    }

    // Empty State
    if (provider.courses.isEmpty && !provider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Course Explorer'),
          actions: [
            IconButton(
              tooltip: 'Muat ulang',
              onPressed: provider.loadCourses,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: _openCreateCoursePage,
          tooltip: 'Tambah course',
          child: const Icon(Icons.add),
        ),
      );
    }

    // Success State
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang data',
            onPressed: provider.loadCourses,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Pesan jika refresh gagal tetapi data lama masih tersedia.
          if (provider.error != null)
            MaterialBanner(
              content: Text('Gagal memperbarui data: ${provider.error}'),
              actions: [
                TextButton(
                  onPressed: provider.loadCourses,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),

          // Indikator kecil saat memperbarui data.
          if (provider.isLoading) const LinearProgressIndicator(),

          Expanded(
            child: RefreshIndicator(
              onRefresh: provider.loadCourses,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: provider.courses.length,
                itemBuilder: (context, index) {
                  final course = provider.courses[index];
                  final favorite = provider.isFavorite(course.code);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(course.code),
                      subtitle: Text(
                        '${course.title}\n'
                        'Credits: ${course.credits} | '
                        'Status: ${course.status}',
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        tooltip: favorite
                            ? 'Hapus dari favorit'
                            : 'Tambah ke favorit',
                        icon: Icon(
                          favorite ? Icons.favorite : Icons.favorite_border,
                          color: favorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          provider.toggleFavorite(course.code);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateCoursePage,
        tooltip: 'Tambah course',
        child: const Icon(Icons.add),
      ),
    );
  }
}
