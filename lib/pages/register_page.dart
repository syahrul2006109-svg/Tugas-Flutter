import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user.dart';
import '../utils/app_colors.dart';
import '../utils/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Mengontrol Form
  final formKey = GlobalKey<FormState>();

  // Controller input
  final nameController = TextEditingController();
  final nimController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // State lokal
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  User? registeredUser;

  // Memproses registrasi
  void submitRegistration() {
    final isValid = formKey.currentState!.validate();

    if (!isValid) return;

    // Membuat object User dari data input
    final newUser = User(
      name: nameController.text.trim(),
      nim: nimController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      age: 18,
      role: 'Mahasiswa',
    );

    setState(() {
      registeredUser = newUser;
    });
  }

  // Mengirim data User ke halaman Login
  void continueToLogin() {
    if (registeredUser == null) return;

    Navigator.pop<User>(context, registeredUser!);
  }

  // Mereset seluruh form
  void resetRegistration() {
    formKey.currentState?.reset();

    nameController.clear();
    nimController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    setState(() {
      registeredUser = null;
      obscurePassword = true;
      obscureConfirmPassword = true;
    });
  }

  // Membersihkan controller
  @override
  void dispose() {
    nameController.dispose();
    nimController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Warna mengikuti tema aktif (terang / gelap)
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
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

                        // Ikon Registrasi
                        const Icon(
                          Icons.person_add,
                          size: 64,
                          color: AppColors.primary,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Buat Akun',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: cs.onSurface),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Lengkapi data berikut untuk membuat akun.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),

                        const SizedBox(height: 24),

                        // Input Nama
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Lengkap',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: validateNameInput,
                        ),

                        const SizedBox(height: 16),

                        // Input NIM
                        TextFormField(
                          controller: nimController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'NIM',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                          validator: validateNimInput,
                        ),

                        const SizedBox(height: 16),

                        // Input Email
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: validateEmailInput,
                        ),

                        const SizedBox(height: 16),

                        // Input Password
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Kata Sandi',
                            prefixIcon: const Icon(Icons.lock_outline),
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

                        const SizedBox(height: 16),

                        // Konfirmasi Password
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Konfirmasi Kata Sandi',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureConfirmPassword =
                                      !obscureConfirmPassword;
                                });
                              },
                              icon: Icon(
                                obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              validateConfirmPassword(
                            value,
                            passwordController.text,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Tombol Daftar
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: submitRegistration,
                            child: const Text('Daftar'),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Tombol Reset
                        TextButton.icon(
                          onPressed: resetRegistration,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset Form'),
                        ),

                        // Hasil Registrasi
                        if (registeredUser != null) ...[
                          const SizedBox(height: 16),

                          Card(
                            color: AppColors.primary.withValues(
                              alpha: isDark ? 0.20 : 0.12,
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.check_circle,
                                color: isDark
                                    ? Colors.greenAccent
                                    : Colors.green,
                              ),
                              title: Text(
                                'Registrasi berhasil: '
                                '${registeredUser!.name}',
                                style: TextStyle(color: cs.onSurface),
                              ),
                              subtitle: Text(
                                'NIM: ${registeredUser!.nim}\n'
                                'Email: ${registeredUser!.email}',
                                style: TextStyle(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Tombol Lanjut ke Login
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: continueToLogin,
                              icon: const Icon(Icons.login),
                              label: const Text(
                                'Lanjut ke Login',
                              ),
                            ),
                          ),
                        ],
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