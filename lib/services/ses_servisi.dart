import 'dart:async';
import 'dart:io';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'sifreleme_servisi.dart';

class SesServisi {
  static final SesServisi _instance = SesServisi._();
  factory SesServisi() => _instance;
  SesServisi._();

  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  final SifrelemeServisi _sifreleme = SifrelemeServisi();

  bool _kayitYapiliyor = false;
  bool _oynatiliyor = false;
  String? _sonKayitYolu;
  Timer? _amplitudTimer;

  bool get kayitYapiliyor => _kayitYapiliyor;
  bool get oynatiliyor => _oynatiliyor;
  String? get sonKayitYolu => _sonKayitYolu;

  // Amplitüd stream — visualizer için
  final _amplitudController = StreamController<double>.broadcast();
  Stream<double> get amplitudStream => _amplitudController.stream;

  // Oynatma durumu
  Stream<PlayerState> get oynatmaDurumu => _player.onPlayerStateChanged;
  Stream<Duration> get oynatmaPozisyonu => _player.onPositionChanged;
  Stream<Duration?> get oynatmaSuresi => _player.onDurationChanged;

  // ═══════════════════════════════════════════════════════════════
  // MİKROFON İZNİ
  // ═══════════════════════════════════════════════════════════════

  Future<bool> mikrofonIzniKontrol() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;

    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  // ═══════════════════════════════════════════════════════════════
  // KAYIT
  // ═══════════════════════════════════════════════════════════════

  Future<bool> kayitBaslat() async {
    try {
      final izin = await mikrofonIzniKontrol();
      if (!izin) return false;

      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) return false;

      final dir = await getApplicationDocumentsDirectory();
      final dosyaYolu =
          '${dir.path}/kayit_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: dosyaYolu,
      );

      _kayitYapiliyor = true;
      _sonKayitYolu = dosyaYolu;

      // Amplitüd oku — visualizer için
      _amplitudTimer = Timer.periodic(
        const Duration(milliseconds: 100),
        (_) async {
          try {
            final amp = await _recorder.getAmplitude();
            // dBFS → 0..1 normalize
            final normalized = ((amp.current + 50) / 50).clamp(0.0, 1.0);
            _amplitudController.add(normalized);
          } catch (_) {}
        },
      );

      _log('Kayıt başladı: $dosyaYolu');
      return true;
    } catch (e) {
      _log('Kayıt başlatma hatası: $e');
      _kayitYapiliyor = false;
      return false;
    }
  }

  Future<String?> kayitDurdur() async {
    try {
      _amplitudTimer?.cancel();
      _amplitudTimer = null;

      final yol = await _recorder.stop();
      _kayitYapiliyor = false;
      _sonKayitYolu = yol;

      _log('Kayıt durduruldu: $yol');
      return yol;
    } catch (e) {
      _log('Kayıt durdurma hatası: $e');
      _kayitYapiliyor = false;
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ŞİFRELİ KAYDET
  // ═══════════════════════════════════════════════════════════════

  Future<String?> kaydiSifreleVeKaydet(String kullaniciId) async {
    if (_sonKayitYolu == null) return null;

    try {
      final dosya = File(_sonKayitYolu!);
      if (!await dosya.exists()) return null;

      final bytes = await dosya.readAsBytes();
      final sifreliBytes = _sifreleme.sesSifrele(bytes, kullaniciId);

      final dir = await getApplicationDocumentsDirectory();
      final sifreliYol =
          '${dir.path}/enc_${DateTime.now().millisecondsSinceEpoch}.enc';
      final sifreliDosya = File(sifreliYol);
      await sifreliDosya.writeAsBytes(sifreliBytes);

      // Orijinal dosyayı sil
      await dosya.delete();

      _log('Şifreli kayıt: $sifreliYol');
      return sifreliYol;
    } catch (e) {
      _log('Şifreleme hatası: $e');
      return _sonKayitYolu; // Şifrelenemeyen orijinal dosyayı döndür
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // OYNATMA
  // ═══════════════════════════════════════════════════════════════

  Future<void> oynat(String dosyaYolu, {String? kullaniciId}) async {
    try {
      String oynatilacakYol = dosyaYolu;

      // Şifreli dosya ise çöz
      if (dosyaYolu.endsWith('.enc') && kullaniciId != null) {
        oynatilacakYol = await _sifreliDosyaCoz(dosyaYolu, kullaniciId);
      }

      await _player.play(DeviceFileSource(oynatilacakYol));
      _oynatiliyor = true;
      _log('Oynatma başladı: $oynatilacakYol');
    } catch (e) {
      _log('Oynatma hatası: $e');
      _oynatiliyor = false;
    }
  }

  Future<void> duraklat() async {
    await _player.pause();
    _oynatiliyor = false;
  }

  Future<void> devamEt() async {
    await _player.resume();
    _oynatiliyor = true;
  }

  Future<void> durdur() async {
    await _player.stop();
    _oynatiliyor = false;
  }

  /// Şifresiz dosyayı oynat (ön dinleme için)
  Future<void> kaydiOynat() async {
    if (_sonKayitYolu == null) return;
    await _player.play(DeviceFileSource(_sonKayitYolu!));
    _oynatiliyor = true;
  }

  Future<void> kaydiDuraklat() async {
    await _player.pause();
    _oynatiliyor = false;
  }

  // ═══════════════════════════════════════════════════════════════
  // YARDIMCI
  // ═══════════════════════════════════════════════════════════════

  Future<String> _sifreliDosyaCoz(String yol, String kullaniciId) async {
    final dosya = File(yol);
    final bytes = await dosya.readAsBytes();
    final cozulmus = _sifreleme.sesCoz(bytes, kullaniciId);

    final dir = await getApplicationDocumentsDirectory();
    final geciciYol = '${dir.path}/temp_play.m4a';
    final geciciDosya = File(geciciYol);
    await geciciDosya.writeAsBytes(cozulmus);

    return geciciYol;
  }

  Future<void> temizle() async {
    _amplitudTimer?.cancel();
    try {
      if (_kayitYapiliyor) await _recorder.stop();
    } catch (_) {}
    await _player.dispose();
    _kayitYapiliyor = false;
    _oynatiliyor = false;
  }

  void _log(String msg) {
    assert(() {
      // ignore: avoid_print
      print('[SesServisi] $msg');
      return true;
    }());
  }
}
