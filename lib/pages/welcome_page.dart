import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/app_colors.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  final User account;

  const WelcomePage({
    super.key,
    required this.account,
  });

  // Navigasi ke halaman Login
  void openLogin(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(account: user),
      ),
    );
  }

  // Navigasi ke halaman Register
  Future<void> openRegister(BuildContext context) async {
    final User? newUser = await Navigator.push<User>(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );

    // Jika pendaftaran berhasil, lanjutkan ke halaman Login
    if (!context.mounted || newUser == null) return;

    openLogin(context, newUser);
  }

  @override
  Widget build(BuildContext context) {
    // Warna mengikuti tema aktif (terang / gelap)
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo ITH
                Image.asset(
                  'assets/images/ith_orange.png',
                  width: 110,
                  height: 110,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.school,
                      size: 100,
                      color: AppColors.primary,
                    );
                  },
                ),

                const SizedBox(height: 24),

                Text(
                  'Aplikasi Profil Mahasiswa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Kelola informasi profil mahasiswa '
                  'dengan mudah dan aman.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 32),

                // Tombol Masuk
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      openLogin(context, account);
                    },
                    child: const Text('Masuk'),
                  ),
                ),

                const SizedBox(height: 14),

                // Tombol Daftar
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      // Di mode gelap pakai oranye terang agar kontras
                      foregroundColor:
                          isDark ? AppColors.primary : AppColors.primaryDark,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      openRegister(context);
                    },
                    child: const Text('Daftar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}