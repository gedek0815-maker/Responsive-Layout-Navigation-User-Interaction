import 'dart:convert';

import 'package:flutter/material.dart';

import 'models/api_post.dart';

class ModelTestPage extends StatelessWidget {
  const ModelTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final jsonData = <String, dynamic>{
      'userId': 1,
      'id': 1,
      'title': 'Belajar REST API',
      'body': 'Menguji parsing JSON ke objek Dart.',
    };

    final post = ApiPost.fromJson(jsonData);
    final convertedJson = post.toJson();

    return Scaffold(
      appBar: AppBar(title: const Text('Pengujian Model JSON')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tahap 3: Model Course dan JSON Mapping',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pengujian konversi data JSON menjadi objek Dart '
            'menggunakan fromJson() dan mengembalikannya '
            'menjadi JSON menggunakan toJson().',
          ),
          const SizedBox(height: 16),
          const Text(
            'Data JSON sumber:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SelectableText(const JsonEncoder.withIndent('  ').convert(jsonData)),
          const SizedBox(height: 16),
          const Text(
            'Hasil Model setelah fromJson():',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('User ID: ${post.userId}'),
          Text('ID: ${post.id}'),
          Text('Judul: ${post.title}'),
          Text('Isi: ${post.body}'),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Expanded(child: Text('Pengujian fromJson() berhasil')),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Hasil toJson():',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SelectableText(
            const JsonEncoder.withIndent('  ').convert(convertedJson),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Expanded(child: Text('Pengujian toJson() berhasil')),
            ],
          ),
        ],
      ),
    );
  }
}
