// lib/main.dart

import 'package:flutter/material.dart';
// import 'screens/dashboard_screen.dart'; 
import 'screens/login_screen.dart'; // 
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code', 
      theme: AppTheme.luxuriousDarkTheme, 
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
