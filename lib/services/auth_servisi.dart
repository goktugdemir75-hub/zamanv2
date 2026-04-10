import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/kullanici.dart';

class AuthServisi {
  static final AuthServisi _instance = AuthServisi._();
  factory AuthServisi() => _instance;
  AuthServisi._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get mevcutFirebaseKullanici => _auth.currentUser;
  Stream<User?> get authDurumu => _auth.authStateChanges();

  // ═══════════════════════════════════════════════════════════════
  // GOOGLE GİRİŞ
  // ═══════════════════════════════════════════════════════════════

  Future<Kullanici?> googleIleGiris() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // İptal edildi

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return null;

      // Her girişte profil oluştur/güncelle — isNewUser güvenilmez
      return await _profilOlusturVeyaGuncelle(
        user: user,
        girisTipi: GirisTipi.google,
      );
    } catch (e) {
      _log('Google giriş hatası: $e');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // E-POSTA GİRİŞ / KAYIT
  // ═══════════════════════════════════════════════════════════════

  Future<Kullanici?> emailIleGiris(String email, String sifre) async {
    try {
      // Önce giriş dene
      UserCredential userCredential;
      try {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: sifre,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // Yeni hesap oluştur
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: sifre,
          );
        } else {
          rethrow;
        }
      }

      final user = userCredential.user;
      if (user == null) return null;

      return await _profilOlusturVeyaGuncelle(
        user: user,
        girisTipi: GirisTipi.email,
      );
    } catch (e) {
      _log('Email giriş hatası: $e');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // APPLE GİRİŞ
  // ═══════════════════════════════════════════════════════════════

  Future<Kullanici?> appleIleGiris() async {
    try {
      final appleProvider = AppleAuthProvider();
      final userCredential = await _auth.signInWithProvider(appleProvider);
      final user = userCredential.user;
      if (user == null) return null;

      return await _profilOlusturVeyaGuncelle(
        user: user,
        girisTipi: GirisTipi.apple,
      );
    } catch (e) {
      _log('Apple giriş hatası: $e');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // PROFİL OLUŞTUR / GÜNCELLE — Firestore
  // ═══════════════════════════════════════════════════════════════

  Future<Kullanici> _profilOlusturVeyaGuncelle({
    required User user,
    required GirisTipi girisTipi,
  }) async {
    final docRef = _db.collection('kullanicilar').doc(user.uid);

    try {
      final doc = await docRef.get();

      if (doc.exists) {
        // Mevcut profili güncelle (son giriş, fotoğraf vb.)
        await docRef.update({
          'fotograf': user.photoURL,
          'ad': user.displayName ?? doc.data()?['ad'] ?? 'Kullanıcı',
          'sonGiris': FieldValue.serverTimestamp(),
        });

        return Kullanici.fromMap(doc.data()!..['id'] = user.uid);
      } else {
        // Yeni profil oluştur
        final kullanici = Kullanici(
          id: user.uid,
          ad: user.displayName ?? _emaildenIsim(user.email),
          email: user.email ?? '',
          fotograf: user.photoURL,
          girisTipi: girisTipi,
          olusturmaTarihi: DateTime.now(),
        );

        await docRef.set({
          ...kullanici.toMap(),
          'sonGiris': FieldValue.serverTimestamp(),
        });

        _log('Yeni profil oluşturuldu: ${user.uid}');
        return kullanici;
      }
    } catch (e) {
      _log('Firestore profil hatası: $e');
      // Firestore başarısız olsa bile offline kullanıcı döndür
      return Kullanici(
        id: user.uid,
        ad: user.displayName ?? _emaildenIsim(user.email),
        email: user.email ?? '',
        fotograf: user.photoURL,
        girisTipi: girisTipi,
        olusturmaTarihi: DateTime.now(),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // KULLANICI BİLGİLERİNİ YÜKLE
  // ═══════════════════════════════════════════════════════════════

  Future<Kullanici?> kullaniciBilgileriniYukle() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc =
          await _db.collection('kullanicilar').doc(user.uid).get();

      if (doc.exists) {
        return Kullanici.fromMap(doc.data()!..['id'] = user.uid);
      }

      // Firestore'da profil yok — oluştur
      return await _profilOlusturVeyaGuncelle(
        user: user,
        girisTipi: GirisTipi.email,
      );
    } catch (e) {
      _log('Kullanıcı yükleme hatası: $e');
      // Offline fallback
      return Kullanici(
        id: user.uid,
        ad: user.displayName ?? _emaildenIsim(user.email),
        email: user.email ?? '',
        fotograf: user.photoURL,
        girisTipi: GirisTipi.email,
        olusturmaTarihi: DateTime.now(),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ÇIKIŞ
  // ═══════════════════════════════════════════════════════════════

  Future<void> cikisYap() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  // ═══════════════════════════════════════════════════════════════
  // YARDIMCILAR
  // ═══════════════════════════════════════════════════════════════

  String _emaildenIsim(String? email) {
    if (email == null || email.isEmpty) return 'Kullanıcı';
    return email.split('@').first;
  }

  void _log(String msg) {
    assert(() {
      // ignore: avoid_print
      print('[AuthServisi] $msg');
      return true;
    }());
  }
}
