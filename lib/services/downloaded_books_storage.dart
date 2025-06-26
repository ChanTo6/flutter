import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';

class DownloadedBooksStorage {
  static const _fileName = 'downloaded_books.json';

  static Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  static Future<List<Book>> getDownloadedBooks() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((e) => Book.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> addDownloadedBook(Book book) async {
    final books = await getDownloadedBooks();
    books.add(book);
    final file = await _getLocalFile();
    await file.writeAsString(jsonEncode(books.map((b) => b.toJson()).toList()));
  }
}
