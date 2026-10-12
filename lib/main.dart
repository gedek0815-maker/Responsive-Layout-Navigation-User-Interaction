import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/course_explorer_page.dart';
import 'services/course_service.dart';

void main() {
  final courseService = CourseService();
  final courseRepository = CourseRepository(courseService);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(courseRepository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CourseExplorerPage(),
    );
  }
}
