
String? validateNameInput(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Nama tidak boleh kosong';
  }
  return null;
}


String? validateNimInput(String? value) {
  final nim = value?.trim() ?? '';
  if (nim.isEmpty) return 'NIM tidak boleh kosong';
  if (!RegExp(r'^\d+$').hasMatch(nim)) return 'NIM harus berupa angka';
  if (nim.length < 9) return 'NIM minimal terdiri dari 9 angka';
  return null;
}


String? validateEmailInput(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Email tidak boleh kosong';
  if (!email.contains('@') || !email.contains('.')) {
    return 'Format email tidak valid';
  }
  return null;
}


String? validatePasswordInput(String? value) {
  if (value == null || value.isEmpty) {
    return 'Kata sandi tidak boleh kosong';
  }
  if (value.length < 6) return 'Kata sandi minimal 6 karakter';
  return null;
}


String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Konfirmasi kata sandi tidak boleh kosong';
  }
  if (value != password) return 'Konfirmasi kata sandi tidak sama';
  return null;
}