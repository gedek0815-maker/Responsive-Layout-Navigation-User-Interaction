import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'favorites_page.dart';

const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

class CourseExplorerPage extends StatefulWidget {
  const CourseExplorerPage({super.key});

  @override
  State<CourseExplorerPage> createState() => _CourseExplorerPageState();
}

class _CourseExplorerPageState extends State<CourseExplorerPage> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';
  bool filterFavorites = false;
  int selectedIndex = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> testAsyncState() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      searchQuery = 'Pemrograman';
      searchController.text = searchQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.sizeOf(context).width >= 600;

    final pages = [_buildCoursePage(), const FavoritesPage()];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedIndex == 0 ? 'Course Explorer' : 'Mata Kuliah Favorit',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer),
            tooltip: 'Uji Async State',
            onPressed: testAsyncState,
          ),
        ],
      ),
      body: Row(
        children: [
          if (isWideScreen)
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: changePage,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book),
                  label: Text('Mata Kuliah'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: Text('Favorit'),
                ),
              ],
            ),
          if (isWideScreen) const VerticalDivider(width: 1),
          Expanded(
            child: IndexedStack(index: selectedIndex, children: pages),
          ),
        ],
      ),
      bottomNavigationBar: isWideScreen
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: changePage,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book),
                  label: 'Mata Kuliah',
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

  Widget _buildCoursePage() {
    final provider = context.watch<CourseProvider>();

    final List<Course> displayedCourses = provider.courses.where((course) {
      final query = searchQuery.toLowerCase();

      final matchesSearch =
          course.title.toLowerCase().contains(query) ||
          course.code.toLowerCase().contains(query) ||
          course.status.toLowerCase().contains(query);

      final matchesFavorite =
          !filterFavorites || provider.isFavorite(course.code);

      return matchesSearch && matchesFavorite;
    }).toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                studentName,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text('NIM: $studentId'),
              const SizedBox(height: 8),
              Text('Total mata kuliah: ${provider.courses.length}'),
              Text('Total favorit: ${provider.favorites.length}'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Cari mata kuliah...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              FilterChip(
                avatar: const Icon(Icons.favorite_border),
                label: const Text('Favorit saja'),
                selected: filterFavorites,
                onSelected: (value) {
                  setState(() {
                    filterFavorites = value;
                  });
                },
              ),
              const Spacer(),
              Text('${displayedCourses.length} mata kuliah'),
            ],
          ),
        ),
        Expanded(
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.error != null
              ? _buildError(provider)
              : displayedCourses.isEmpty
              ? const Center(child: Text('Mata kuliah tidak ditemukan.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: displayedCourses.length,
                  itemBuilder: (context, index) {
                    return CourseCard(course: displayedCourses[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildError(CourseProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            const Text('Gagal memuat mata kuliah.'),
            const SizedBox(height: 8),
            Text(provider.error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CourseProvider>().loadCourses();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
