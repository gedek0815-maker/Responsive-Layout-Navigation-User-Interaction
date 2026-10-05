import 'package:flutter/material.dart';

const String studentName = 'Gede Krisna Adi Pramana';
const String studentId = '2415051036';

void main() => runApp(const TahapDuabelasApp());

class TahapDuabelasApp extends StatelessWidget {
  const TahapDuabelasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tahap12Page(),
    );
  }
}

class Tahap12Page extends StatefulWidget {
  const Tahap12Page({super.key});

  @override
  State<Tahap12Page> createState() => _Tahap12PageState();
}

class _Tahap12PageState extends State<Tahap12Page> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 12: Interaction & InkWell'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                onLongPress: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Long Press terdeteksi pada Card!'),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flutter UI Fundamentals',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('MOB03 • 3 SKS'),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tips: Ketuk card untuk mengubah status favorit (dengan efek ripple InkWell), atau tekan lama (long-press) untuk memunculkan SnackBar.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
