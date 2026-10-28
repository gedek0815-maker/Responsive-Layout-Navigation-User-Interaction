import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'constants/supabase_config.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/responsive_shell.dart';
import 'services/course_api_service.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart';

Future<void> main() async {
  // Poin 61: Inisialisasikan Supabase sebelum runApp()
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    // ignore: deprecated_member_use
    anonKey: SupabaseConfig.anonKey,
  );

  // Tahap 16 - Poin 92: Pilih data source aktif di main.dart
  // Untuk Supabase:
  final CourseDataSource dataSource = CourseSupabaseService();
  // (Untuk REST: CourseApiService('https://jsonplaceholder.typicode.com'))

  final repository = CourseRepository(dataSource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Data Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ResponsiveShell(),
    );
  }
}
