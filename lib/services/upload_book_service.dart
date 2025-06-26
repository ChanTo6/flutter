import 'dart:io';
import 'package:http/http.dart' as http;

class UploadBookService {
  final String baseUrl;
  UploadBookService({required this.baseUrl});

  Future<void> uploadBook({
    required String title,
    required String author,
    required String genre,
    required String description,
    required String filePath,
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/api/books/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['title'] = title
      ..fields['author'] = author
      ..fields['genre'] = genre
      ..fields['description'] = description
      ..fields['status'] = 'pending'
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('file', filePath));
    final response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 201) {
      final respStr = await response.stream.bytesToString();
      throw Exception('Upload failed: $respStr');
    }
  }
}
