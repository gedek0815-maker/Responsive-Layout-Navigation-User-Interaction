import 'package:flutter/material.dart';

// ============================================================================
// IDENTITAS MAHASISWA (SESUAI WORKSHEET)
// ============================================================================
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
      title: 'Course Explorer - Tahap 3',
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

// ============================================================================
// PARENT WIDGET: Single Source of Truth (Lifting State Up)
// ============================================================================
class MainResponsiveNavigation extends StatefulWidget {
  const MainResponsiveNavigation({super.key});

  @override
  State<MainResponsiveNavigation> createState() =>
      _MainResponsiveNavigationState();
}

class _MainResponsiveNavigationState extends State<MainResponsiveNavigation> {
  int _selectedIndex = 0;

  // [SINGLE SOURCE OF TRUTH]
  // Hanya ada satu Set data favorit terpusat di parent
  final Set<String> _favoriteCourseCodes = {'CS101'};

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
      'desc': 'Konsep object-oriented programming (OOP), asynchronous Dart, collection, dan functional styling.',
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

  // Callback terpusat untuk memutasi data Single Source of Truth di Parent
  void _handleFavoriteChanged(String courseCode) {
    setState(() {
      if (_favoriteCourseCodes.contains(courseCode)) {
        _favoriteCourseCodes.remove(courseCode);
      } else {
        _favoriteCourseCodes.add(courseCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint responsif: jika lebar >= 600 maka tampilkan NavigationRail
        final bool isDesktopOrTablet = constraints.maxWidth >= 600;

        final List<Widget> pages = [
          DashboardHomePage(
            courses: _courses,
            favoriteCourseCodes: _favoriteCourseCodes,
            onFavoriteChanged: _handleFavoriteChanged,
          ),
          CoursesListPage(
            courses: _courses,
            favoriteCourseCodes: _favoriteCourseCodes,
            onFavoriteChanged: _handleFavoriteChanged,
          ),
          FavoritesPage(
            courses: _courses,
            favoriteCourseCodes: _favoriteCourseCodes,
            onFavoriteChanged: _handleFavoriteChanged,
          ),
        ];

        if (isDesktopOrTablet) {
          // Layout Layar Lebar / Tablet / Landscape
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Course Explorer (Lifting State Up)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 1,
            ),
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => _selectedIndex = index);
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
          // Layout Ponsel / Layar Kompak
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Course Explorer (Lifting State Up)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 1,
            ),
            body: pages[_selectedIndex],
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
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
// DASHBOARD VIEW
// ============================================================================
class DashboardHomePage extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  final Set<String> favoriteCourseCodes;
  final ValueChanged<String> onFavoriteChanged;

  const DashboardHomePage({
    super.key,
    required this.courses,
    required this.favoriteCourseCodes,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Profil Identitas Mahasiswa
          Card(
            elevation: 2,
            color: const Color(0xFFE8F0FE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF1E3A5F),
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
                          '$studentId - $studentName',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A5F),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Tahap 3: Lifting State Up & Single Source of Truth',
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

          // Ringkasan Metrics
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Total Courses',
                  value: courses.length.toString(),
                  icon: Icons.note_outlined,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Favorites',
                  value: favoriteCourseCodes.length.toString(),
                  icon: Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'Highlight Courses:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Daftar 3 Kursus Teratas (Dilengkapi Key unik agar state expand aman)
          ...courses
              .take(3)
              .map(
                (c) => CourseCard(
                  key: ValueKey(c['code']),
                  courseData: c,
                  isFavorite: favoriteCourseCodes.contains(c['code']),
                  onFavoriteChanged: () => onFavoriteChanged(c['code']),
                ),
              ),

          const SizedBox(height: 8),

          // ==================================================================
          // CARD TAHAP 3: LIFTING STATE UP & SINGLE SOURCE OF TRUTH
          // ==================================================================
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF81C784), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tahap 3: Lifting State Up & Single Source of Truth',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$studentId • $studentName',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Parent Source: ${favoriteCourseCodes.length} Fav',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Ganti baris Container child di Card Tahap 3:
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Bungkus teks dengan Expanded agar otomatis menyesuaikan lebar layar
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Widget A & Widget B:',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Konsisten: ${favoriteCourseCodes.length} Item',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Tombol callback ke single source of truth
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () {
                          onFavoriteChanged('CS102');
                        },
                        icon: const Icon(Icons.sync, size: 14),
                        label: const Text(
                          'Toggle CS102',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 0.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 26, color: color),
            const SizedBox(width: 10),
            Expanded(
              // <-- Pastikan ini memakai Expanded
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// COURSES LIST VIEW
// ============================================================================
class CoursesListPage extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  final Set<String> favoriteCourseCodes;
  final ValueChanged<String> onFavoriteChanged;

  const CoursesListPage({
    super.key,
    required this.courses,
    required this.favoriteCourseCodes,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return CourseCard(
          key: ValueKey(course['code']),
          courseData: course,
          isFavorite: favoriteCourseCodes.contains(course['code']),
          onFavoriteChanged: () => onFavoriteChanged(course['code']),
        );
      },
    );
  }
}

// ============================================================================
// FAVORITES VIEW
// ============================================================================
class FavoritesPage extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  final Set<String> favoriteCourseCodes;
  final ValueChanged<String> onFavoriteChanged;

  const FavoritesPage({
    super.key,
    required this.courses,
    required this.favoriteCourseCodes,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final favList = courses
        .where((c) => favoriteCourseCodes.contains(c['code']))
        .toList();

    if (favList.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada mata kuliah favorit.',
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: favList.length,
      itemBuilder: (context, index) {
        final course = favList[index];
        return CourseCard(
          key: ValueKey('fav_${course['code']}'),
          courseData: course,
          isFavorite: true,
          onFavoriteChanged: () => onFavoriteChanged(course['code']),
        );
      },
    );
  }
}

// ============================================================================
// LEAF WIDGET: CourseCard (Bisa di-expand dengan klik tombol maupun klik bodi kartu)
// ============================================================================
class CourseCard extends StatefulWidget {
  final Map<String, dynamic> courseData;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseCard({
    super.key,
    required this.courseData,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final status = widget.courseData['status'] as String;

    Color badgeColor = Colors.orange;
    if (status == 'done') badgeColor = Colors.green;
    if (status == 'active') badgeColor = Colors.blue;

    return Card(
      elevation: 0.5,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
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
                            fontSize: 15,
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
                                color: badgeColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
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
                  // Tombol Favorit
                  IconButton(
                    tooltip: 'Ubah Favorit',
                    icon: Icon(
                      widget.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: widget.onFavoriteChanged,
                  ),
                  // Tombol Expand dengan animasi rotasi ikon
                  IconButton(
                    tooltip: 'Detail Info',
                    icon: AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.expand_more),
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const Divider(height: 18),
                Text(
                  widget.courseData['desc'] as String,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
