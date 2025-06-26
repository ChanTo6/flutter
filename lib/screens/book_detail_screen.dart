import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Author: ${book.author}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Genre: ${book.genre}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(book.description, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Download'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(160, 48)),
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Download started...')),
                  );
                  // TODO: Implement download logic and show success/error
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
