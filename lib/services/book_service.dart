import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../models/book.dart';

class BookService {
  final String baseUrl;
  BookService({required this.baseUrl});

  Future<List<Book>> fetchBooks({String? author, String? genre, String? status}) async {
    final queryParams = <String, String>{};
    if (author != null && author.isNotEmpty) queryParams['author'] = author;
    if (genre != null && genre.isNotEmpty) queryParams['genre'] = genre;
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    final uri = Uri.parse('$baseUrl/api/books').replace(queryParameters: queryParams);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch books: ${response.body}');
    }
  }

  Future<void> approveBook(String bookId, String token) async {
    final uri = Uri.parse('$baseUrl/api/books/$bookId/approve');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to approve book: ${response.body}');
    }
  }

  Future<String> downloadBookFile(String fileUrl, String fileName) async {
    final response = await http.get(Uri.parse(fileUrl));
    if (response.statusCode == 200) {
      final dir = await getApplicationSupportDirectory(); // More hidden than documents
      final file = File('${dir.path}/.$fileName'); // Dot prefix makes it hidden on Unix
      // Encrypt the file content
      final key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 chars
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encryptBytes(response.bodyBytes, iv: iv);
      await file.writeAsBytes(encrypted.bytes);
      return file.path;
    } else {
      throw Exception('Failed to download file: ${response.body}');
    }
  }
}
