import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import 'course_list_page.dart';
import 'favorites_page.dart';

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    CourseListPage(),
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedIndex == 0 ? 'Course Data Manager' : 'Mata Kuliah Favorit',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              '$studentName | NIM: $studentId',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh Data',
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await context.read<CourseProvider>().loadCourses();
              if (context.mounted) {
                final error = context.read<CourseProvider>().error;
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red.shade700,
                      content: Text('Koneksi terputus: $error'),
                      duration: const Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'Coba Lagi',
                        textColor: Colors.white,
                        onPressed: () =>
                            context.read<CourseProvider>().loadCourses(),
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Navigasi Lebar (Tablet / Web / Desktop)
          if (isWideScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book),
                  label: Text('Courses'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: Text('Favorit'),
                ),
              ],
            ),
          if (isWideScreen) const VerticalDivider(thickness: 1, width: 1),

          // Konten Halaman Aktif
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      // Navigasi Bawah (Mobile / Layar Sempit)
      bottomNavigationBar: isWideScreen
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book),
                  label: 'Courses',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: 'Favorit',
                ),
              ],
            ),
    );
  }
}
