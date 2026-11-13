import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/app_colors.dart';

/// Halaman untuk mengubah data profil.
/// Mengembalikan [User] baru lewat Navigator.pop jika disimpan,
/// atau null jika dibatalkan.
class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _ageController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _ageController = TextEditingController(text: user.age.toString());
    _phoneController = TextEditingController(text: user.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ---------- Validasi ----------

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email tidak boleh kosong';
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(text)) return 'Format email tidak valid';
    return null;
  }

  String? _validateAge(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Umur tidak boleh kosong';
    final age = int.tryParse(text);
    if (age == null) return 'Umur harus berupa angka';
    if (age < 1 || age > 120) return 'Umur tidak valid';
    return null;
  }

  // Nomor telepon boleh kosong, tapi jika diisi harus valid
  String? _validatePhone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final regex = RegExp(r'^\+?[0-9]{9,15}$');
    if (!regex.hasMatch(text)) {
      return 'Nomor telepon tidak valid (9-15 digit)';
    }
    return null;
  }

  // ---------- Simpan ----------

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final old = widget.user;
    final phone = _phoneController.text.trim();

    // NIM, password, dan role tidak diubah di halaman ini.
    // User dibuat langsung (bukan copyWith) agar nomor telepon
    // bisa dikosongkan kembali menjadi null.
    final updated = User(
      name: _nameController.text.trim(),
      nim: old.nim,
      email: _emailController.text.trim(),
      password: old.password,
      age: int.parse(_ageController.text.trim()),
      role: old.role,
      phone: phone.isEmpty ? null : phone,
    );

    Navigator.pop(context, updated);
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final previewName = _nameController.text.trim();
    final initial =
        previewName.isNotEmpty ? previewName[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: _validateName,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    // NIM tidak boleh diubah
                    TextFormField(
                      initialValue: widget.user.nim,
                      readOnly: true,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'NIM',
                        prefixIcon: Icon(Icons.badge),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Umur',
                        prefixIcon: Icon(Icons.cake),
                        suffixText: 'tahun',
                      ),
                      validator: _validateAge,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Telepon (opsional)',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: _validatePhone,
                      onFieldSubmitted: (_) => _save(),
                    ),
                    const SizedBox(height: 16),

                    // Role tidak boleh diubah
                    TextFormField(
                      initialValue: widget.user.role,
                      readOnly: true,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        prefixIcon: Icon(Icons.school),
                      ),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan'),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: cs.primaryContainer,
                          foregroundColor: cs.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}