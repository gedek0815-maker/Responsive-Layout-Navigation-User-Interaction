import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiGetTestPage extends StatefulWidget {
  const ApiGetTestPage({super.key});

  @override
  State<ApiGetTestPage> createState() => _ApiGetTestPageState();
}

class _ApiGetTestPageState extends State<ApiGetTestPage> {
  bool isLoading = false;
  String? errorMessage;
  int? statusCode;
  List<dynamic> posts = [];

  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      statusCode = null;
      posts = [];
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (!mounted) return;

      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        setState(() {
          posts = data;
        });
      } else {
        setState(() {
          errorMessage = 'Request gagal. HTTP ${response.statusCode}';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
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
              'Tahap 2: HTTP GET dan Parsing JSON',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
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
            if (statusCode != null) Text('HTTP Status Code: $statusCode'),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            if (!isLoading && posts.isNotEmpty) ...[
              Text('Jumlah data diterima: ${posts.length}'),
              const SizedBox(height: 8),
              const Text(
                'Contoh data pertama:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: SelectableText(
                    const JsonEncoder.withIndent('  ').convert(posts.first),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
