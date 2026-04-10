import 'dart:async';
import 'package:flutter/material.dart';
import '../models/kullanici.dart';
import '../models/kapsul.dart';
import 'auth_servisi.dart';
import 'firestore_servisi.dart';

class AppState extends ChangeNotifier {
  final AuthServisi _auth = AuthServisi();
  final FirestoreServisi _firestore = FirestoreServisi();

  Kullanici? _kullanici;
  bool _yukleniyor = false;
  String? _hata;
  List<Kapsul> _kapsullar = [];
  StreamSubscription? _kapsulSub;

  Kullanici? get kullanici => _kullanici;
  bool get girisYapildi => _kullanici != null;
  bool get yukleniyor => _yukleniyor;
  String? get hata => _hata;
  List<Kapsul> get kapsullar => List.unmodifiable(_kapsullar);
  List<Kapsul> get kilitliler =>
      _kapsullar.where((k) => !k.acilabilirMi).toList();
  List<Kapsul> get aciklar =>
      _kapsullar.where((k) => k.acilabilirMi).toList();

  // ═══════════════════════════════════════════════════════════════
  // BAŞLATMA — Firebase auth durumunu kontrol et
  // ═══════════════════════════════════════════════════════════════

  Future<void> baslat() async {
    _yukleniyor = true;
    _hata = null;
    notifyListeners();

    try {
      if (_auth.mevcutFirebaseKullanici != null) {
        _kullanici = await _auth.kullaniciBilgileriniYukle();
        if (_kullanici != null) {
          _kapsulleriDinlemeBaslat();
        }
      }
    } catch (e) {
      _hata = e.toString();
      _log('Başlatma hatası: $e');
    } finally {
      _yukleniyor = false;
      notifyListeners();
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // GİRİŞ
  // ═══════════════════════════════════════════════════════════════

  Future<bool> googleIleGiris() async {
    _yukleniyor = true;
    _hata = null;
    notifyListeners();

    try {
      _kullanici = await _auth.googleIleGiris();
      if (_kullanici != null) {
        _kapsulleriDinlemeBaslat();
        _yukleniyor = false;
        notifyListeners();
        return true;
      }
      _yukleniyor = false;
      notifyListeners();
      return false;
    } catch (e) {
      _hata = e.toString();
      _yukleniyor = false;
      notifyListeners();
      _log('Google giriş hatası: $e');
      return false;
    }
  }

  Future<bool> emailIleGiris(String email, String sifre) async {
    _yukleniyor = true;
    _hata = null;
    notifyListeners();

    try {
      _kullanici = await _auth.emailIleGiris(email, sifre);
      if (_kullanici != null) {
        _kapsulleriDinlemeBaslat();
        _yukleniyor = false;
        notifyListeners();
        return true;
      }
      _yukleniyor = false;
      notifyListeners();
      return false;
    } catch (e) {
      _hata = e.toString();
      _yukleniyor = false;
      notifyListeners();
      _log('Email giriş hatası: $e');
      return false;
    }
  }

  Future<bool> appleIleGiris() async {
    _yukleniyor = true;
    _hata = null;
    notifyListeners();

    try {
      _kullanici = await _auth.appleIleGiris();
      if (_kullanici != null) {
        _kapsulleriDinlemeBaslat();
        _yukleniyor = false;
        notifyListeners();
        return true;
      }
      _yukleniyor = false;
      notifyListeners();
      return false;
    } catch (e) {
      _hata = e.toString();
      _yukleniyor = false;
      notifyListeners();
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ÇIKIŞ
  // ═══════════════════════════════════════════════════════════════

  Future<void> cikisYap() async {
    _kapsulSub?.cancel();
    _kapsulSub = null;
    _kapsullar = [];
    _kullanici = null;
    _hata = null;
    await _auth.cikisYap();
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════
  // KAPSÜL İŞLEMLERİ
  // ═══════════════════════════════════════════════════════════════

  void _kapsulleriDinlemeBaslat() {
    final uid = _kullanici?.id;
    if (uid == null) return;

    _kapsulSub?.cancel();
    _kapsulSub = _firestore.kapsulleriDinle(uid).listen(
      (liste) {
        _kapsullar = liste;
        notifyListeners();
      },
      onError: (e) {
        _log('Kapsül dinleme hatası: $e');
      },
    );
  }

  Future<void> kapsulEkle(Kapsul kapsul) async {
    final uid = _kullanici?.id;
    if (uid == null) return;

    try {
      await _firestore.kapsulEkle(uid, kapsul);
      // Stream otomatik güncelleyecek
    } catch (e) {
      _hata = e.toString();
      notifyListeners();
      _log('Kapsül ekleme hatası: $e');
    }
  }

  Future<void> kapsulAcildiIsaretle(String kapsulId) async {
    final uid = _kullanici?.id;
    if (uid == null) return;

    try {
      await _firestore.acildiIsaretle(uid, kapsulId);
    } catch (e) {
      _log('Açıldı işaretleme hatası: $e');
    }
  }

  Future<void> kapsulSil(String kapsulId) async {
    final uid = _kullanici?.id;
    if (uid == null) return;

    try {
      await _firestore.kapsulSil(uid, kapsulId);
    } catch (e) {
      _hata = e.toString();
      notifyListeners();
      _log('Kapsül silme hatası: $e');
    }
  }

  void hataTemizle() {
    _hata = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _kapsulSub?.cancel();
    super.dispose();
  }

  void _log(String msg) {
    assert(() {
      // ignore: avoid_print
      print('[AppState] $msg');
      return true;
    }());
  }
}

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppStateProvider>()!.notifier!;
}
