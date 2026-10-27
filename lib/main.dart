import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'constants/supabase_config.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_api_service.dart';
import 'pages/course_explorer_page.dart';

Future<void> main() async {
  // Poin 61: Inisialisasikan Supabase sebelum runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase Client (Tahap 10)
  if (SupabaseConfig.url != 'YOUR_SUPABASE_URL' && SupabaseConfig.url.isNotEmpty) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      // ignore: deprecated_member_use
      anonKey: SupabaseConfig.anonKey,
    );
  }

  // Poin 62: Perakitan service -> repository -> provider tetap dilakukan di main() setelah Supabase.initialize
  const apiBaseUrl = 'https://jsonplaceholder.typicode.com';
  final repository = CourseRepository(CourseApiService(apiBaseUrl));

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
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CourseExplorerPage(),
    );
  }
}
