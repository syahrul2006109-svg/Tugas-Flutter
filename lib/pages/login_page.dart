import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user.dart';
import '../utils/app_colors.dart';
import '../utils/validators.dart';

import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final User account;

  const LoginPage({
    super.key,
    required this.account,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Mengontrol Form
  final formKey = GlobalKey<FormState>();

  // Controller input
  final nimController = TextEditingController();
  final passwordController = TextEditingController();

  // State lokal
  bool obscurePassword = true;
  bool loginSuccess = false;

  String message = '';
  int failedAttempts = 0;

  @override
  void dispose() {
    nimController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk memproses login
  void submitLogin() {
    final isValid = formKey.currentState!.validate();

    if (!isValid) {
      setState(() {
        loginSuccess = false;
        message = '';
      });
      return;
    }

    // Membandingkan NIM dan password
    final success =
        nimController.text.trim() == widget.account.nim &&
        passwordController.text == widget.account.password;

    if (!success) {
      setState(() {
        loginSuccess = false;
        failedAttempts++;

        message = failedAttempts >= 3
            ? 'Login gagal 3 kali. Periksa kembali NIM dan kata sandi.'
            : 'NIM atau kata sandi salah';
      });

      return;
    }

    // Login berhasil
    setState(() {
      loginSuccess = true;
      failedAttempts = 0;
      message = 'Login berhasil. Hello, ${widget.account.name}';
    });

    // Pindah ke Home dan mengirim data User
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          user: widget.account,
        ),
      ),
    );
  }

  // Fungsi Reset Login
  void resetLogin() {
    formKey.currentState?.reset();

    nimController.clear();
    passwordController.clear();

    setState(() {
      message = '';
      loginSuccess = false;
      failedAttempts = 0;
      obscurePassword = true;
    });
  }

  // Navigasi ke Register dan menerima akun baru
  Future<void> openRegister() async {
    final newUser = await Navigator.push<User>(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );

    if (!mounted || newUser == null) return;

    // Mengganti Login lama dengan Login akun baru
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          account: newUser,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Warna mengikuti tema aktif (terang / gelap)
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Warna pesan: lebih terang di mode gelap agar tetap terbaca
    final successColor = isDark ? Colors.greenAccent : Colors.green;
    final errorColor = isDark ? Colors.redAccent.shade100 : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                // Putih di mode terang, gelap di mode gelap
                color: isDark ? cs.surfaceContainer : AppColors.surface,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        // Logo ITH
                        Image.asset(
                          'assets/images/ITH Tulisan Orange.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.login,
                              size: 64,
                              color: AppColors.primary,
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Masuk ke Akun',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: cs.onSurface),
                        ),

                        const SizedBox(height: 24),

                        // Input NIM
                        TextFormField(
                          controller: nimController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'NIM',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: validateNimInput,
                        ),

                        const SizedBox(height: 16),

                        // Input Password
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Kata Sandi',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword =
                                      !obscurePassword;
                                });
                              },
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: validatePasswordInput,
                        ),

                        const SizedBox(height: 24),

                        // Tombol Masuk
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: submitLogin,
                            child: const Text('Masuk'),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Tombol Reset
                        TextButton.icon(
                          onPressed: resetLogin,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset Login'),
                        ),

                        // Pesan Login
                        if (message.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    loginSuccess ? successColor : errorColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                        // Penghitung Login Gagal
                        if (failedAttempts > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Percobaan gagal: $failedAttempts',
                              style: TextStyle(
                                color: errorColor,
                              ),
                            ),
                          ),

                        const SizedBox(height: 16),

                        // Navigasi Register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                'Belum memiliki akun?',
                                style: TextStyle(color: cs.onSurface),
                              ),
                            ),

                            TextButton(
                              onPressed: openRegister,
                              child: Text(
                                'Daftar',
                                style: TextStyle(
                                  // Oranye terang di mode gelap agar kontras
                                  color: isDark
                                      ? AppColors.primary
                                      : AppColors.primaryDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}