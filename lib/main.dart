import 'package:flutter/material.dart';

const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainResponsiveNavigation(),
    );
  }
}

class MainResponsiveNavigation extends StatefulWidget {
  const MainResponsiveNavigation({super.key});

  @override
  State<MainResponsiveNavigation> createState() =>
      _MainResponsiveNavigationState();
}

class _MainResponsiveNavigationState extends State<MainResponsiveNavigation> {
  int _selectedIndex = 0;

  // Data representasi daftar mata kuliah
  final List<Map<String, dynamic>> _courses = [
    {
      'code': 'CS101',
      'title': 'Git & GitHub',
      'credits': 2,
      'status': 'done',
      'desc': 'Menguasai version control system, branching workflow, commit atomic, serta kolaborasi via GitHub repository.',
    },
    {
      'code': 'CS102',
      'title': 'Dart Fundamentals',
      'credits': 3,
      'status': 'done',
      'desc': 'Konsep object-oriented programming (OOP), asynchronous Dart (Future, async/await), collection, dan functional styling.',
    },
    {
      'code': 'CS103',
      'title': 'State Management',
      'credits': 3,
      'status': 'active',
      'desc': 'Memahami local vs shared state, limitasi setState, Provider architecture, dan separation of concerns.',
    },
    {
      'code': 'CS104',
      'title': 'Responsive & Adaptive UI',
      'credits': 3,
      'status': 'done',
      'desc': 'Pemanfaatan LayoutBuilder, MediaQuery, NavigationRail, dan master-detail adaptif berbagai ukuran layar.',
    },
    {
      'code': 'CS105',
      'title': 'Networking & API Integration',
      'credits': 4,
      'status': 'upcoming',
      'desc': 'Pengambilan data remote melalui HTTP REST API, serialization JSON, error handling, dan caching lokal.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktopOrTablet = constraints.maxWidth >= 640;

        final List<Widget> pages = [
          DashboardHomePage(courses: _courses),
          CoursesListPage(courses: _courses),
          FavoritesPlaceholderPage(),
        ];

        if (isDesktopOrTablet) {
          // Layout Layar Lebar: NavigationRail di sebelah kiri
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Course Explorer (Tahap 1)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 1,
            ),
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Icon(Icons.school, size: 36, color: Colors.blue),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book),
                      label: Text('Courses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_border),
                      selectedIcon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: pages[_selectedIndex]),
              ],
            ),
          );
        } else {
          // Layout Mobile / Layar Sempit: NavigationBar di bawah
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Course Explorer (Tahap 1)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 1,
            ),
            body: pages[_selectedIndex],
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book),
                  label: 'Courses',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// ============================================================================
// 1. DASHBOARD HOME PAGE (DENGAN IDENTITAS & STATS CARD)
// ============================================================================
class DashboardHomePage extends StatelessWidget {
  final List<Map<String, dynamic>> courses;

  const DashboardHomePage({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    final int doneCount = courses.where((c) => c['status'] == 'done').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Identitas Mahasiswa (Wajib)
          Card(
            elevation: 2,
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$studentId • $studentName',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Worksheet 6 - Local State vs Shared State',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Stat Ringkasan (Cards Responsif)
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  title: 'Total Courses',
                  value: courses.length.toString(),
                  icon: Icons.library_books,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  title: 'Completed',
                  value: doneCount.toString(),
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'Active Modules (Tahap 1 Demo):',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // List item course card dengan Local State
          ...courses.take(3).map((c) => ResponsiveCourseCard(courseData: c)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        child: Row(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 2. COURSES LIST PAGE
// ============================================================================
class CoursesListPage extends StatelessWidget {
  final List<Map<String, dynamic>> courses;

  const CoursesListPage({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return ResponsiveCourseCard(courseData: courses[index]);
      },
    );
  }
}

// ============================================================================
// 3. WIDGET DENGAN LOCAL STATE (FOKUS TAHAP 1)
// Menggunakan setState() untuk mengelola interaksi buka-tutup dan toggle lokal
// ============================================================================
class ResponsiveCourseCard extends StatefulWidget {
  final Map<String, dynamic> courseData;

  const ResponsiveCourseCard({super.key, required this.courseData});

  @override
  State<ResponsiveCourseCard> createState() => _ResponsiveCourseCardState();
}

class _ResponsiveCourseCardState extends State<ResponsiveCourseCard> {
  // [LOCAL STATE]: Status expand dan toggle lokal item ini
  bool _isExpanded = false;
  bool _isLocalFavorite = false;

  @override
  Widget build(BuildContext context) {
    final status = widget.courseData['status'] as String;

    Color badgeColor = Colors.orange;
    if (status == 'done') badgeColor = Colors.green;
    if (status == 'active') badgeColor = Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.courseData['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: badgeColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: badgeColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.courseData['code']} • ${widget.courseData['credits']} SKS',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Local State Action 1: Toggle Bookmark Lokal
                IconButton(
                  tooltip: 'Toggle Local Favorite',
                  icon: Icon(
                    _isLocalFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isLocalFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isLocalFavorite = !_isLocalFavorite;
                    });
                  },
                ),
                // Local State Action 2: Toggle Expand/Collapse Detail
                IconButton(
                  tooltip: 'Detail Info',
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
            // Rebuild terjadi hanya pada widget lokal ini saat di-expand
            if (_isExpanded) ...[
              const Divider(height: 18),
              Text(
                widget.courseData['desc'] as String,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              const Text(
                '* Catatan Tahap 1: State kartu ini (expand & icon favorite) dikelola secara lokal menggunakan setState().',
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Colors.black45,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 4. FAVORITES PLACEHOLDER PAGE
// ============================================================================
class FavoritesPlaceholderPage extends StatelessWidget {
  const FavoritesPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Favorites Screen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pada Tahap 1, daftar favorit masih berupa Local State pada tiap kartu di tab Courses sehingga belum tersinkronisasi di tab ini.\n(Akan disatukan dengan Shared State Provider pada Tahap berikutnya).',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
