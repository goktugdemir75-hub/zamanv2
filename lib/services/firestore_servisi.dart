import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kapsul.dart';

class FirestoreServisi {
  static final FirestoreServisi _instance = FirestoreServisi._();
  factory FirestoreServisi() => _instance;
  FirestoreServisi._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _kapsullerRef(String uid) =>
      _db.collection('kullanicilar').doc(uid).collection('kapsuller');

  // ═══════════════════════════════════════════════════════════════
  // KAPSÜL CRUD
  // ═══════════════════════════════════════════════════════════════

  Future<String> kapsulEkle(String uid, Kapsul kapsul) async {
    try {
      final docRef = await _kapsullerRef(uid).add(kapsul.toMap());
      _log('Kapsül eklendi: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _log('Kapsül ekleme hatası: $e');
      rethrow;
    }
  }

  Future<List<Kapsul>> kapsulleriGetir(String uid) async {
    try {
      final snapshot = await _kapsullerRef(uid)
          .orderBy('olusturmaTarihi', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Kapsul.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      _log('Kapsül getirme hatası: $e');
      return [];
    }
  }

  Stream<List<Kapsul>> kapsulleriDinle(String uid) {
    return _kapsullerRef(uid)
        .orderBy('olusturmaTarihi', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Kapsul.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> kapsulGuncelle(
      String uid, String kapsulId, Map<String, dynamic> data) async {
    try {
      await _kapsullerRef(uid).doc(kapsulId).update(data);
    } catch (e) {
      _log('Kapsül güncelleme hatası: $e');
      rethrow;
    }
  }

  Future<void> kapsulSil(String uid, String kapsulId) async {
    try {
      await _kapsullerRef(uid).doc(kapsulId).delete();
      _log('Kapsül silindi: $kapsulId');
    } catch (e) {
      _log('Kapsül silme hatası: $e');
      rethrow;
    }
  }

  Future<void> acildiIsaretle(String uid, String kapsulId) async {
    await kapsulGuncelle(uid, kapsulId, {
      'acildiMi': true,
      'dinlendiMi': true,
    });
  }

  void _log(String msg) {
    assert(() {
      // ignore: avoid_print
      print('[FirestoreServisi] $msg');
      return true;
    }());
  }
}
