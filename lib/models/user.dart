class User {
  // Data utama pengguna
  final String name;
  final String nim;
  final String email;
  final String password;
  final int age;
  final String role;
  final String? phone;

  // Constructor
  const User({
    required this.name,
    required this.nim,
    required this.email,
    required this.password,
    required this.age,
    required this.role,
    this.phone,
  });

  // Membuat salinan User dengan sebagian data diubah.
  // Dipakai untuk fitur Edit Profil, karena semua field bersifat final.
  User copyWith({
    String? name,
    String? nim,
    String? email,
    String? password,
    int? age,
    String? role,
    String? phone,
  }) {
    return User(
      name: name ?? this.name,
      nim: nim ?? this.nim,
      email: email ?? this.email,
      password: password ?? this.password,
      age: age ?? this.age,
      role: role ?? this.role,
      phone: phone ?? this.phone,
    );
  }

  // Menampilkan sapaan pengguna
  String get greeting => 'Hello, $name!';

  // Huruf pertama nama, untuk avatar
  String get initial => name.trim().isNotEmpty
      ? name.trim()[0].toUpperCase()
      : '?';

  // Menampilkan umur, contoh: "20 tahun"
  String get ageDisplay => '$age tahun';

  // Menampilkan nomor telepon
  String get phoneDisplay =>
      (phone == null || phone!.isEmpty) ? 'Belum diisi' : phone!;

  // Memeriksa usia pengguna
  bool get isAdult => age >= 18;

  // Memeriksa kelengkapan profil
  bool get isProfileComplete {
    return name.isNotEmpty &&
        nim.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        phone != null &&
        phone!.isNotEmpty;
  }

  // Menampilkan status profil
  String get profileStatus {
    return isProfileComplete ? 'Profil lengkap' : 'Profil belum lengkap';
  }

  // Dua User dianggap sama jika semua datanya sama
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is User &&
            other.name == name &&
            other.nim == nim &&
            other.email == email &&
            other.password == password &&
            other.age == age &&
            other.role == role &&
            other.phone == phone;
  }

  @override
  int get hashCode =>
      Object.hash(name, nim, email, password, age, role, phone);
}