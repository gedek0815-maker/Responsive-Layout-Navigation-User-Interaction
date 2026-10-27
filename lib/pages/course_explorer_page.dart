import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/error_view.dart';
import 'create_course_page.dart';
import 'edit_course_page.dart';

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

  // Tahap 8: Fungsi hapus course
  Future<void> _deleteCourse(Course course, int apiId) async {
    // 47. Tampilkan AlertDialog konfirmasi sebelum menghapus
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

    // 48. Jalankan DELETE setelah user menyetujui
    if (confirm != true || !mounted) return;

    final success = await context
        .read<CourseProvider>()
        .deleteCourse(course.code, apiId);

    // 50. Setelah dialog dan await DELETE, periksa context.mounted sebelum menampilkan SnackBar
    if (!mounted) return;

    // 49. Refresh list dan tampilkan SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Course ${course.code} berhasil dihapus'
              : 'Gagal menghapus course ${course.code}',
        ),
      ),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditCoursePage(
                              course: course,
                              apiId: index + 1,
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(course.code),
                      subtitle: Text(
                        '${course.title}\n'
                        'Credits: ${course.credits} | '
                        'Status: ${course.status}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 41. Tambahkan tombol Edit pada ListTile (Tahap 7)
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Edit course',
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditCoursePage(
                                    course: course,
                                    apiId: index + 1,
                                  ),
                                ),
                              );
                            },
                          ),
                          // 46. Tambahkan tombol Delete (Tahap 8)
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Hapus course',
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => _deleteCourse(course, index + 1),
                          ),
                          // Tombol Favorit
                          IconButton(
                            visualDensity: VisualDensity.compact,
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
                        ],
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
