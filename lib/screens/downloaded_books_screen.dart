import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/downloaded_books_storage.dart';
import 'book_detail_screen.dart';

class DownloadedBooksScreen extends StatefulWidget {
  const DownloadedBooksScreen({super.key});

  @override
  State<DownloadedBooksScreen> createState() => _DownloadedBooksScreenState();
}

class _DownloadedBooksScreenState extends State<DownloadedBooksScreen> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = DownloadedBooksStorage.getDownloadedBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloaded Books')),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No downloaded books.'));
          }
          final books = snapshot.data!;
          return ListView.separated(
            itemCount: books.length,
            separatorBuilder: (context, i) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(book.author),
                trailing: const Icon(Icons.picture_as_pdf),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailScreen(book: book),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
