import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/l10n.dart';

class Kapsul {
  final String id;
  final String baslikSifreli;
  final int sureSaniye;
  final DateTime olusturmaTarihi;
  final DateTime acilisTarihi;
  final String? aliciSifreli;
  final int renkDegeri;
  final String emoji;
  final String paylasimKodu;
  final String sahipId;
  final String? sesDosyaYolu;
  bool acildiMi;
  bool dinlendiMi;

  Kapsul({
    required this.id,
    required this.baslikSifreli,
    required this.sureSaniye,
    required this.olusturmaTarihi,
    required this.acilisTarihi,
    this.aliciSifreli,
    required this.renkDegeri,
    required this.emoji,
    required this.paylasimKodu,
    required this.sahipId,
    this.sesDosyaYolu,
    this.acildiMi = false,
    this.dinlendiMi = false,
  });

  // ignore: deprecated_member_use
  Color get renk => Color(renkDegeri);
  bool get acilabilirMi => DateTime.now().isAfter(acilisTarihi);
  Duration get kalanSure => acilisTarihi.difference(DateTime.now());
  String get kalanSureMetni => l.kalanSureMetni(kalanSure);

  Map<String, dynamic> toMap() => {
    'baslikSifreli': baslikSifreli,
    'sureSaniye': sureSaniye,
    'olusturmaTarihi': Timestamp.fromDate(olusturmaTarihi),
    'acilisTarihi': Timestamp.fromDate(acilisTarihi),
    'aliciSifreli': aliciSifreli,
    'renkDegeri': renkDegeri,
    'emoji': emoji,
    'paylasimKodu': paylasimKodu,
    'sahipId': sahipId,
    'sesDosyaYolu': sesDosyaYolu,
    'acildiMi': acildiMi,
    'dinlendiMi': dinlendiMi,
  };

  factory Kapsul.fromMap(String id, Map<String, dynamic> m) => Kapsul(
    id: id,
    baslikSifreli: m['baslikSifreli'] as String,
    sureSaniye: m['sureSaniye'] as int,
    olusturmaTarihi: (m['olusturmaTarihi'] as Timestamp).toDate(),
    acilisTarihi: (m['acilisTarihi'] as Timestamp).toDate(),
    aliciSifreli: m['aliciSifreli'] as String?,
    renkDegeri: m['renkDegeri'] as int,
    emoji: m['emoji'] as String,
    paylasimKodu: m['paylasimKodu'] as String,
    sahipId: m['sahipId'] as String,
    sesDosyaYolu: m['sesDosyaYolu'] as String?,
    acildiMi: m['acildiMi'] as bool? ?? false,
    dinlendiMi: m['dinlendiMi'] as bool? ?? false,
  );

  static String kodUret() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random();
    return List.generate(6, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
