import 'package:flutter/material.dart';

import 'models/user.dart';
import 'pages/welcome_page.dart';
import 'utils/app_colors.dart';
import 'utils/theme_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Data sampel pengguna
  static const User sampleUser = User(
    name: 'Syahrul Ramadhan',
    nim: '241011125',
    email: 'syahrul@ith.ac.id',
    password: '241011125',
    age: 20,
    role: 'Mahasiswa',
    phone: '+6282193279162',
  );

  // Dekorasi input yang dipakai di tema terang dan gelap
  static const InputDecorationTheme _inputTheme = InputDecorationTheme(
    border: OutlineInputBorder(),
    filled: true,
  );

  @override
  Widget build(BuildContext context) {
    // Membangun ulang MaterialApp setiap kali mode tema berubah
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Profil Mahasiswa',

          // Mode tema (terang / gelap) dikontrol dari Drawer
          themeMode: mode,

          // Tema terang
          theme: ThemeData(
            fontFamily: 'Poppins',
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: AppColors.background,
            inputDecorationTheme: _inputTheme,
          ),

          // Tema gelap
          darkTheme: ThemeData(
            fontFamily: 'Poppins',
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.dark,
            ),
            inputDecorationTheme: _inputTheme,
          ),

          // Halaman pertama aplikasi
          // Mengirim data sampel ke WelcomePage
          home: const WelcomePage(
            account: sampleUser,
          ),
        );
      },
    );
  }
}