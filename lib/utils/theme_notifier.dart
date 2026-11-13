import 'package:flutter/material.dart';

/// Menyimpan mode tema aplikasi (terang/gelap).
/// Simpan file ini di: lib/utils/theme_notifier.dart
final ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.light);