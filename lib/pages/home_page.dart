import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/app_colors.dart';
import '../utils/theme_notifier.dart';
import 'edit_profile_page.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({
    super.key,
    required this.user,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Salinan data user yang bisa berubah setelah Edit Profil
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  // Riwayat aktivitas sederhana (disimpan di memori)
  final List<String> _activities = ['Login ke aplikasi'];

  void _addActivity(String text) {
    setState(() => _activities.add(text));
  }

  // ---------- Aksi ----------

  Future<void> confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda ingin kembali ke halaman awal?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  Future<void> _editProfile() async {
    final updated = await Navigator.push<User>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(user: _user),
      ),
    );

    if (!mounted) return;

    // null berarti dibatalkan
    if (updated == null) {
      _addActivity('Membatalkan Edit Profil');
      return;
    }

    // Tidak ada perubahan data
    if (updated == _user) {
      _addActivity('Edit Profil tanpa perubahan');
      return;
    }

    setState(() {
      _user = updated;
      _activities.add('Memperbarui profil');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui')),
    );
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat Aktivitas',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _activities.length,
                    itemBuilder: (context, index) {
                      final item =
                          _activities[_activities.length - 1 - index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.history),
                        title: Text(item),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final user = _user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final initial =
        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          // Tombol riwayat dengan jumlah aktivitas
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: OutlinedButton.icon(
              onPressed: _showHistory,
              icon: const Icon(Icons.history),
              label: Text('${_activities.length}'),
            ),
          ),
        ],
      ),

      // ---------- Drawer ----------
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.primary,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + 80,
                16,
                16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${user.nim} | ${user.email}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profil'),
              onTap: () {
                Navigator.pop(context);
                _editProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat Aktivitas'),
              onTap: () {
                Navigator.pop(context);
                _showHistory();
              },
            ),

            // Toggle Mode Gelap
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, mode, _) {
                return SwitchListTile(
                  secondary: const Icon(Icons.dark_mode),
                  title: const Text('Mode Gelap'),
                  value: mode == ThemeMode.dark,
                  onChanged: (value) {
                    themeNotifier.value =
                        value ? ThemeMode.dark : ThemeMode.light;
                    _addActivity(
                      value ? 'Mengaktifkan Mode Gelap' : 'Mematikan Mode Gelap',
                    );
                  },
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () {
                Navigator.pop(context);
                confirmLogout(context);
              },
            ),
          ],
        ),
      ),

      // ---------- Body ----------
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                elevation: 3,
                color: isDark ? cs.surfaceContainer : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          initial,
                          style: const TextStyle(
                            fontSize: 44,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.nim,
                        style: TextStyle(
                          fontSize: 20,
                          color: cs.onSurface.withOpacity(0.6),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      _InfoRow(icon: Icons.email, text: user.email),
                      _InfoRow(icon: Icons.cake, text: '${user.age} tahun'),
                      _InfoRow(icon: Icons.school, text: user.role),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _editProfile,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profil'),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryDark, size: 28),
          const SizedBox(width: 20),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}