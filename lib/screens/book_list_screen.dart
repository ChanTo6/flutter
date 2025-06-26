import 'package:flutter/material.dart';
import '../services/book_service.dart';
import '../models/book.dart';
import 'book_detail_screen.dart';

class BookListScreen extends StatefulWidget {
  final BookService bookService;
  const BookListScreen({super.key, required this.bookService});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> _books = [];
  bool _loading = true;
  String? _selectedAuthor;
  String? _selectedGenre;
  List<String> _authors = [];
  List<String> _genres = [];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() => _loading = true);
    try {
      final books = await widget.bookService.fetchBooks(
        author: _selectedAuthor,
        genre: _selectedGenre,
      );
      setState(() {
        _books = books;
        _authors = books.map((b) => b.author).toSet().toList();
        _genres = books.map((b) => b.genre).toSet().toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load books: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Books')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Author'),
                    value: _selectedAuthor,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Authors')),
                      ..._authors.map((author) => DropdownMenuItem(
                        value: author,
                        child: Text(author),
                      )),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedAuthor = value);
                      _fetchBooks();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Genre'),
                    value: _selectedGenre,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Genres')),
                      ..._genres.map((genre) => DropdownMenuItem(
                        value: genre,
                        child: Text(genre),
                      )),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedGenre = value);
                      _fetchBooks();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _books.isEmpty
                    ? const Center(child: Text('No books found.'))
                    : ListView.builder(
                        itemCount: _books.length,
                        itemBuilder: (context, index) {
                          final book = _books[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            elevation: 2,
                            child: ListTile(
                              title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('${book.author} • ${book.genre}'),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetailScreen(book: book),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
