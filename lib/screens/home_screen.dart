import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/book_service.dart';
import 'book_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthService authService;
  const HomeScreen({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await authService.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.menu_book),
              label: const Text('View Books'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(180, 48)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookListScreen(
                      bookService: BookService(baseUrl: 'YOUR_BACKEND_URL'),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
