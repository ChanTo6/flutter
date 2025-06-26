import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService(baseUrl: 'YOUR_BACKEND_URL');
  final loggedIn = await authService.isLoggedIn();
  runApp(DigitalLibraryApp(authService: authService, loggedIn: loggedIn));
}

class DigitalLibraryApp extends StatelessWidget {
  final AuthService authService;
  final bool loggedIn;
  const DigitalLibraryApp({super.key, required this.authService, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Library',
      initialRoute: loggedIn ? '/home' : '/',
      routes: {
        '/': (context) => LoginScreen(authService: authService),
        '/register': (context) => RegisterScreen(authService: authService),
        '/home': (context) => HomeScreen(authService: authService),
      },
    );
  }
}