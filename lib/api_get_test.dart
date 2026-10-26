import 'package:flutter/material.dart';

import 'models/api_post.dart';
import 'services/api_service.dart';

class ApiGetTestPage extends StatefulWidget {
  const ApiGetTestPage({super.key});

  @override
  State<ApiGetTestPage> createState() => _ApiGetTestPageState();
}

class _ApiGetTestPageState extends State<ApiGetTestPage> {
  final ApiService apiService = ApiService();

  bool isLoading = false;
  String? errorMessage;
  List<ApiPost> posts = [];

  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      posts = [];
    });

    try {
      final result = await apiService.fetchPosts();

      if (!mounted) return;

      setState(() {
        posts = result;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengujian REST API')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tahap 4: Pemisahan Service Layer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('HTTP GET dan parsing JSON dikelola oleh ApiService.'),
            const SizedBox(height: 8),
            const SelectableText('https://jsonplaceholder.typicode.com/posts'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : fetchPosts,
                icon: const Icon(Icons.cloud_download),
                label: const Text('Ambil Data dari API'),
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading) const Center(child: CircularProgressIndicator()),
            if (errorMessage != null)
              Text(
                'Terjadi kesalahan: $errorMessage',
                style: const TextStyle(color: Colors.red),
              ),
            if (!isLoading && posts.isNotEmpty) ...[
              const Text(
                'Status: Data berhasil diterima',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Jumlah data diterima: ${posts.length}'),
              const SizedBox(height: 8),
              const Text(
                'Contoh data pertama:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: SelectableText(posts.first.toJson().toString()),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
