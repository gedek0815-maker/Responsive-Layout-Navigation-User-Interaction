import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/course_explorer_page.dart';
import 'services/course_service.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sengaja mengakses Provider tanpa ChangeNotifierProvider
    context.watch<CourseProvider>();

    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Pengujian Provider'))),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sengaja salah untuk pengujian Kasus B
    context.watch<CourseProvider>();

    return MaterialApp(
      title: 'Course Explorer v2',
      debugShowCheckedModeBanner: false,
      home: const CourseExplorerPage(),
    );
  }
}
