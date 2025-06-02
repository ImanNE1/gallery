// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Untuk animasi
import '../utils/app_colors.dart'; // Warna kustom Anda
import '../utils/app_theme.dart'; // Tema kustom Anda (jika ada font atau gaya teks spesifik)
import 'dashboard_screen.dart'; // Halaman dashboard Anda
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _performLogin() {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      // Navigasi ke DashboardScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme appTextTheme =
        Theme.of(context).textTheme; // Ambil TextTheme dari AppTheme
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Kita tidak menggunakan AppBar di sini untuk tampilan login yang lebih imersif
      body: Container(
        decoration: BoxDecoration(
          // Memberikan gradient background yang mewah
          gradient: LinearGradient(
            colors: isDarkTheme
                ? [
                    AppColors.primaryBackground,
                    AppColors.cardBackground.withOpacity(0.8)
                  ]
                : [
                    Colors.blueGrey.shade100,
                    Colors.lightBlue.shade100
                  ], // Contoh untuk tema terang
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            // Agar bisa di-scroll jika konten melebihi layar (misal keyboard muncul)
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Judul Aplikasi atau Logo (Contoh Sederhana)
                Icon(
                  Icons.qr_code, // Ganti dengan logo Anda jika ada
                  size: 80,
                  color: isDarkTheme
                      ? AppColors.accentColor
                      : Theme.of(context).primaryColor,
                ).animate().fade(duration: 900.ms).scale(delay: 300.ms),
                const SizedBox(height: 16),
                Text(
                  'QR Code', // Nama Aplikasi Anda
                  textAlign: TextAlign.center,
                  style: appTextTheme.displayLarge?.copyWith(
                    color:
                        isDarkTheme ? AppColors.headlineText : Colors.black87,
                    fontSize: 28, // Sedikit lebih kecil untuk login screen
                  ),
                )
                    .animate()
                    .fade(duration: 900.ms)
                    .slideY(begin: -0.2, delay: 500.ms),
                const SizedBox(height: 48),

                // Email TextField
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                      color: isDarkTheme ? AppColors.bodyText : Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Email atau Username',
                    labelStyle: TextStyle(
                        color: isDarkTheme
                            ? AppColors.bodyText.withOpacity(0.7)
                            : Colors.grey.shade700),
                    hintText: 'contoh@email.com',
                    hintStyle: TextStyle(
                        color: isDarkTheme
                            ? AppColors.bodyText.withOpacity(0.4)
                            : Colors.grey.shade500),
                    prefixIcon: Icon(Icons.email_outlined,
                        color: isDarkTheme
                            ? AppColors.accentColor.withOpacity(0.7)
                            : Theme.of(context).primaryColor),
                    filled: true,
                    fillColor: isDarkTheme
                        ? AppColors.cardBackground.withOpacity(0.5)
                        : Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                          color: isDarkTheme
                              ? AppColors.accentColor
                              : Theme.of(context).primaryColor,
                          width: 2),
                    ),
                  ),
                )
                    .animate()
                    .fade(duration: 700.ms)
                    .slideX(begin: -0.5, delay: 700.ms),
                const SizedBox(height: 20),

                // Password TextField
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Sembunyikan teks password
                  style: TextStyle(
                      color: isDarkTheme ? AppColors.bodyText : Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        color: isDarkTheme
                            ? AppColors.bodyText.withOpacity(0.7)
                            : Colors.grey.shade700),
                    hintText: 'Masukkan password Anda',
                    hintStyle: TextStyle(
                        color: isDarkTheme
                            ? AppColors.bodyText.withOpacity(0.4)
                            : Colors.grey.shade500),
                    prefixIcon: Icon(Icons.lock_outline,
                        color: isDarkTheme
                            ? AppColors.accentColor.withOpacity(0.7)
                            : Theme.of(context).primaryColor),
                    filled: true,
                    fillColor: isDarkTheme
                        ? AppColors.cardBackground.withOpacity(0.5)
                        : Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                          color: isDarkTheme
                              ? AppColors.accentColor
                              : Theme.of(context).primaryColor,
                          width: 2),
                    ),
                  ),
                )
                    .animate()
                    .fade(duration: 700.ms)
                    .slideX(begin: 0.5, delay: 700.ms),
                const SizedBox(height: 12),

                // Lupa Password (Dummy)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Aksi dummy, tidak melakukan apa-apa
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Fitur "Lupa Password" belum tersedia.')),
                      );
                    },
                    child: Text(
                      'Lupa Password?',
                      style: TextStyle(
                          color: isDarkTheme
                              ? AppColors.accentColor.withOpacity(0.9)
                              : Theme.of(context).primaryColorDark),
                    ),
                  ),
                ).animate().fade(delay: 900.ms),
                const SizedBox(height: 28),

                // Tombol Login
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: isDarkTheme
                                ? AppColors.accentColor
                                : Theme.of(context).primaryColor))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // Menggunakan gaya dari ElevatedButtonThemeData di AppTheme
                          // backgroundColor: AppColors.accentColor, // Bisa di-override jika perlu
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: appTextTheme.labelLarge?.copyWith(
                              fontSize: 18), // Sesuaikan dengan textTheme
                        ),
                        onPressed: _performLogin,
                        child: const Text('Login'),
                      ).animate().shake(
                        delay: 900.ms,
                        duration: 600.ms,
                        hz: 3), // Efek getar sedikit

                const SizedBox(height: 32),

                // Pemisah atau Teks "ATAU" (Dummy)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Divider(
                            color:
                                (isDarkTheme ? AppColors.bodyText : Colors.grey)
                                    .withOpacity(0.5))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'ATAU',
                        style: appTextTheme.bodyMedium?.copyWith(
                            color: (isDarkTheme
                                    ? AppColors.bodyText
                                    : Colors.grey.shade700)
                                .withOpacity(0.8)),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                            color:
                                (isDarkTheme ? AppColors.bodyText : Colors.grey)
                                    .withOpacity(0.5))),
                  ],
                ).animate().fade(delay: 1100.ms),
                const SizedBox(height: 24),

                // Tombol Sosial Media (Dummy) - Contoh Google
                OutlinedButton.icon(
                  icon: Image.asset('assets/icons/google_logo.png',
                      height: 20,
                      width:
                          20), // Anda perlu menambahkan logo google ke assets/icons/
                  label: Text('Login dengan Google',
                      style: TextStyle(
                          color: isDarkTheme
                              ? AppColors.bodyText
                              : Colors.black87)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: (isDarkTheme ? AppColors.bodyText : Colors.grey)
                            .withOpacity(0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Login dengan Google belum tersedia.')),
                    );
                  },
                )
                    .animate()
                    .fade(delay: 1300.ms)
                    .slideY(begin: 0.5, duration: 700.ms),

                const SizedBox(height: 40),
                // Link Daftar (Dummy)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: appTextTheme.bodyMedium?.copyWith(
                          color: isDarkTheme
                              ? AppColors.bodyText
                              : Colors.grey.shade800),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Fitur "Daftar" belum tersedia.')),
                        );
                      },
                      child: Text(
                        'Daftar Sekarang',
                        style: appTextTheme.bodyMedium?.copyWith(
                          color: isDarkTheme
                              ? AppColors.accentColor
                              : Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ).animate().fade(delay: 1500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
