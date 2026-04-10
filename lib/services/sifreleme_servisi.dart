import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as enc;

class SifrelemeServisi {
  static final SifrelemeServisi _instance = SifrelemeServisi._();
  factory SifrelemeServisi() => _instance;
  SifrelemeServisi._();

  /// Kullanıcı ID'sinden 32-byte AES anahtarı türet
  enc.Key _anahtar(String kullaniciId) {
    final seed = utf8.encode('ZK_AES256_$kullaniciId');
    // SHA-256 benzeri basit hash — 32 byte üret
    final hash = List<int>.filled(32, 0);
    for (var i = 0; i < seed.length; i++) {
      hash[i % 32] = (hash[i % 32] + seed[i]) % 256;
    }
    // Ek karıştırma
    for (var round = 0; round < 16; round++) {
      for (var i = 0; i < 32; i++) {
        hash[i] = (hash[i] ^ hash[(i + 7) % 32]) + round & 0xFF;
      }
    }
    return enc.Key(Uint8List.fromList(hash));
  }

  /// Rastgele IV üret
  enc.IV _rastgeleIV() {
    final rng = Random.secure();
    return enc.IV(Uint8List.fromList(
      List.generate(16, (_) => rng.nextInt(256)),
    ));
  }

  /// Metin şifrele — IV + şifreli veri base64 olarak döner
  String sifrele(String metin, String kullaniciId) {
    if (metin.isEmpty) return '';
    try {
      final key = _anahtar(kullaniciId);
      final iv = _rastgeleIV();
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      final encrypted = encrypter.encrypt(metin, iv: iv);
      // IV + encrypted data birleştir
      final combined = [...iv.bytes, ...encrypted.bytes];
      return base64Url.encode(combined);
    } catch (e) {
      debugLog('Şifreleme hatası: $e');
      return '';
    }
  }

  /// Şifreli metni çöz
  String coz(String sifreliMetin, String kullaniciId) {
    if (sifreliMetin.isEmpty) return '';
    try {
      final key = _anahtar(kullaniciId);
      final bytes = base64Url.decode(sifreliMetin);
      final iv = enc.IV(Uint8List.fromList(bytes.sublist(0, 16)));
      final encrypted = enc.Encrypted(Uint8List.fromList(bytes.sublist(16)));
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      debugLog('Şifre çözme hatası: $e');
      return '[Çözülemedi]';
    }
  }

  /// Ses dosyasını şifrele
  Uint8List sesSifrele(Uint8List data, String kullaniciId) {
    try {
      final key = _anahtar(kullaniciId);
      final iv = _rastgeleIV();
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      final encrypted = encrypter.encryptBytes(data.toList(), iv: iv);
      return Uint8List.fromList([...iv.bytes, ...encrypted.bytes]);
    } catch (e) {
      debugLog('Ses şifreleme hatası: $e');
      return data;
    }
  }

  /// Şifreli ses dosyasını çöz
  Uint8List sesCoz(Uint8List data, String kullaniciId) {
    try {
      final key = _anahtar(kullaniciId);
      final iv = enc.IV(Uint8List.fromList(data.sublist(0, 16)));
      final encrypted = enc.Encrypted(Uint8List.fromList(data.sublist(16)));
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      final decrypted = encrypter.decryptBytes(encrypted, iv: iv);
      return Uint8List.fromList(decrypted);
    } catch (e) {
      debugLog('Ses çözme hatası: $e');
      return data;
    }
  }

  /// Input temizleme
  static String inputTemizle(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'[<>"\x00-\x1F]'), '')
        .trim();
  }

  static void debugLog(String msg) {
    assert(() {
      // ignore: avoid_print
      print('[SifrelemeServisi] $msg');
      return true;
    }());
  }
}
