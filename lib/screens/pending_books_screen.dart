import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class PendingBooksScreen extends StatefulWidget {
  final BookService bookService;
  const PendingBooksScreen({super.key, required this.bookService});

  @override
  State<PendingBooksScreen> createState() => _PendingBooksScreenState();
}

class _PendingBooksScreenState extends State<PendingBooksScreen> {
  late Future<List<Book>> _pendingBooksFuture;

  @override
  void initState() {
    super.initState();
    _pendingBooksFuture = _fetchPendingBooks();
  }

  Future<List<Book>> _fetchPendingBooks() async {
    // Assuming your backend supports a 'status' filter
    return widget.bookService.fetchBooks(genre: null, author: null, status: 'pending');
  }

  Future<void> _approveBook(Book book) async {
    // TODO: Call backend to approve book
    setState(() {
      _pendingBooksFuture = _fetchPendingBooks();
    });
  }

  Future<void> _rejectBook(Book book) async {
    // TODO: Call backend to reject book
    setState(() {
      _pendingBooksFuture = _fetchPendingBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Books')),
      body: FutureBuilder<List<Book>>(
        future: _pendingBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pending books.'));
          }
          final books = snapshot.data!;
          return ListView.separated(
            itemCount: books.length,
            separatorBuilder: (context, i) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                elevation: 2,
                child: ListTile(
                  title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(book.author),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        tooltip: 'Approve',
                        onPressed: () => _approveBook(book),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        tooltip: 'Reject',
                        onPressed: () => _rejectBook(book),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
