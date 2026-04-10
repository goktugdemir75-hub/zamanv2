import 'package:flutter/material.dart';

class T {
  // Derin siyahlar — luxury dark
  static const bg = Color(0xFF030308);
  static const yuzey = Color(0xFF0A0A16);
  static const yuzeyY = Color(0xFF111122);
  static const sinir = Color(0xFF1A1A30);
  static const sinir2 = Color(0xFF222240);

  // Premium aksan renkleri
  static const birincil = Color(0xFFE8364F);
  static const ikincil = Color(0xFF38D9A9);
  static const altin = Color(0xFFFFD700);
  static const basari = Color(0xFF51CF66);
  static const mor = Color(0xFFBE4BDB);
  static const mavi = Color(0xFF5C7CFA);

  // Metin
  static const metin = Color(0xFFF8F8FF);
  static const metin2 = Color(0xFF8888B0);
  static const metin3 = Color(0xFF44446A);

  static const renkler = [
    Color(0xFFE8364F), Color(0xFF38D9A9), Color(0xFFFFD700), Color(0xFFBE4BDB),
    Color(0xFF51CF66), Color(0xFFFF922B), Color(0xFF5C7CFA), Color(0xFFFF6B9D),
  ];

  static const emojiler = [
    '🎵', '❤️', '🌟', '🎂', '🌙', '☀️', '🌊', '🔮',
    '🦋', '🌸', '🎈', '💫', '🎯', '🏆', '🌈', '✨',
  ];

  static const gradBirincil = LinearGradient(
    colors: [Color(0xFFE8364F), Color(0xFFFF6B9D)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const gradAltin = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const gradMor = LinearGradient(
    colors: [Color(0xFF7B2FBE), Color(0xFFBE4BDB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

String sureFmt(int s) =>
    '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
