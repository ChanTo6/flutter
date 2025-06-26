import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String author;

  @HiveField(3)
  String genre;

  @HiveField(4)
  String description;

  @HiveField(5)
  String? fileUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
    this.fileUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      genre: json['genre'] ?? '',
      description: json['description'] ?? '',
      fileUrl: json['fileUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'genre': genre,
        'description': description,
        'fileUrl': fileUrl,
      };
}
