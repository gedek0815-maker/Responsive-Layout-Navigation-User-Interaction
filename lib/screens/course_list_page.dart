import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'course_form_page.dart';

const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  void _openCreateCourse(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CourseFormPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Column(
      children: [
        // Indikator saat sedang memuat/memperbarui data
        if (provider.isLoading && provider.courses.isNotEmpty)
          const LinearProgressIndicator(),

        Expanded(
          child: RefreshIndicator(
            onRefresh: provider.loadCourses,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                // Banner NIM • Nama Mahasiswa (sesuai Mockup Tahap 16)
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$studentId • $studentName',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol + Tambah Course (sesuai Mockup Tahap 16)
                SizedBox(
                  height: 46,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.green.shade50,
                      side: BorderSide(color: Colors.green.shade400, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _openCreateCourse(context),
                    icon: const Icon(Icons.add, color: Colors.green),
                    label: const Text(
                      'Tambah Course',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tampilkan Banner Error jika ada error koneksi (saat data lama masih ada di list)
                if (provider.error != null && provider.courses.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Koneksi Terputus / Gagal Memperbarui',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                provider.error!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red.shade900,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: provider.loadCourses,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),

                // State Handling 1: Loading (saat list masih kosong)
                if (provider.isLoading && provider.courses.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Sedang memuat data dari Supabase...'),
                        ],
                      ),
                    ),
                  )
                // State Handling 2: Full ErrorView (saat data kosong dan terjadi error)
                else if (provider.error != null && provider.courses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: ErrorView(
                      message: provider.error!,
                      onRetry: provider.loadCourses,
                    ),
                  )
                // State Handling 3: Empty State (saat tidak ada error dan database kosong)
                else if (provider.courses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'Data course belum tersedia di database.',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                // State Handling 4: Success List of Courses
                else
                  ...provider.courses.map((course) => CourseCard(course: course)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
