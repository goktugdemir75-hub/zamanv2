import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const ZamanKapsuluApp());
}

// ═══════════════════════════════════════════════════════════════════════════
// DİL SİSTEMİ — l10n paketi olmadan, DartPad uyumlu
// ═══════════════════════════════════════════════════════════════════════════

enum AppDil { tr, en, fa }

class DilNotifier extends ValueNotifier<AppDil> {
  DilNotifier() : super(AppDil.tr);
  void degistir(AppDil dil) => value = dil;
}

final dilNotifier = DilNotifier();

// Çeviri anahtarları
class L {
  final AppDil _dil;
  const L(this._dil);

  String get appName => _t('Zaman Kapsülü', 'Time Capsule', 'کپسول زمان');
  String get tagline => _t(
    'Sesini geleceğe kilitle',
    'Lock your voice into the future',
    'صدایت را به آینده قفل کن',
  );

  // Giriş
  String get loginGoogle =>
      _t('Google ile Giriş Yap', 'Continue with Google', 'ورود با Google');
  String get loginApple =>
      _t('Apple ile Giriş Yap', 'Continue with Apple', 'ورود با Apple');
  String get loginEmail =>
      _t('E-posta ile devam et', 'Continue with Email', 'ادامه با ایمیل');
  String get loginEmailHint =>
      _t('E-posta adresin', 'Your email address', 'آدرس ایمیل');
  String get loginPassHint => _t('Şifre', 'Password', 'رمز عبور');
  String get loginButton =>
      _t('Giriş Yap / Kayıt Ol', 'Sign In / Sign Up', 'ورود / ثبت‌نام');
  String get loginBack => _t('← Geri dön', '← Go back', '← بازگشت');
  String get loginTestMode => _t('TEST MODU', 'TEST MODE', 'حالت آزمایش');
  String get loginTestDesc => _t(
    'Herhangi e-posta + şifre → giriş yapılır',
    'Any email + password → you\'re in',
    'هر ایمیل + رمز عبور → وارد می‌شوی',
  );
  String get secBadge => _t(
    'Uçtan uca şifreleme • Cihazında saklanır',
    'End-to-end encrypted • Stored on device',
    'رمزنگاری سرتاسری • فقط روی دستگاه',
  );

  // Onboarding
  String onboardingTitle(String name) =>
      _t('Hoş geldin, $name!', 'Welcome, $name!', 'خوش آمدی، $name!');
  String get onbSub => _t(
    'Sesini geleceğe kilitle.\nİlk kapsülünü oluşturalım.',
    'Lock your voice into the future.\nLet\'s create your first capsule.',
    'صدایت را به آینده قفل کن.\nبیا اولین کپسولت را بسازیم.',
  );
  String get onbStep1 =>
      _t('Sesini kaydet', 'Record your voice', 'صدایت را ضبط کن');
  String get onbStep1s =>
      _t('En fazla 2 dakika', 'Up to 2 minutes', 'حداکثر ۲ دقیقه');
  String get onbStep2 => _t(
    'Açılış tarihini seç',
    'Choose an unlock date',
    'تاریخ باز شدن را انتخاب کن',
  );
  String get onbStep2s => _t(
    '1 aydan 10 yıla kadar',
    'From 1 month to 10 years',
    'از ۱ ماه تا ۱۰ سال',
  );
  String get onbStep3 =>
      _t('Kapsülü mühürle', 'Seal the capsule', 'کپسول را مهر کن');
  String get onbStep3s => _t(
    'Tarih gelene kadar kilitli',
    'Locked until the date',
    'تا رسیدن تاریخ قفل می‌ماند',
  );
  String get onbStart => _t(
    '🎙️ İlk Kapsülümü Oluştur',
    '🎙️ Create My First Capsule',
    '🎙️ اولین کپسولم را بسازم',
  );
  String get onbSkip => _t('Şimdi değil →', 'Not now →', 'الان نه ←');

  // Ana sayfa
  String get homeTitle => appName;
  String get homeLocked => _t('Kilitli', 'Locked', 'قفل‌شده');
  String get homeUnlocked => _t('Açık', 'Open', 'باز');
  String get homeTotal => _t('Toplam', 'Total', 'کل');
  String get homeRecent =>
      _t('Son Kapsüller', 'Recent Capsules', 'کپسول‌های اخیر');
  String get homeEmpty =>
      _t('Henüz kapsülün yok', 'No capsules yet', 'هنوز کپسولی نداری');
  String get homeEmptyDesc =>
      _t('Aşağıdaki butona bas', 'Tap the button below', 'دکمه پایین را بزن');
  String get homeNewCap => _t('Yeni Kapsül', 'New Capsule', 'کپسول جدید');
  String homeWelcome(String n) =>
      _t('Merhaba, $n 👋', 'Hello, $n 👋', 'سلام، $n 👋');
  String homeOpenReady(int n) => _t(
    '$n kapsülün\nseni bekliyor!',
    '$n capsules\nwaiting for you!',
    '$n کپسول\nمنتظر توست!',
  );
  String homeLockedCount(int n) => _t(
    '$n kapsülün\nhâlâ kilitli',
    '$n capsules\nstill locked',
    '$n کپسول\nهنوز قفل است',
  );
  String get homeFirstPrompt => _t(
    'İlk kapsülünü\noluşturmaya hazır mısın?',
    'Ready to create\nyour first capsule?',
    'آماده‌ای اولین\nکپسولت را بسازی؟',
  );
  String homeOpenCount(int n) =>
      _t('$n yeni açıldı', '$n newly opened', '$n تازه باز شد');
  String get openRing => _t('açık', 'open', 'باز');

  // Kayıt
  String get recTitle =>
      _t('Sesini kaydet', 'Record your voice', 'صدایت را ضبط کن');
  String get recSub => _t(
    'Kendine, sevdiklerine ya da dünyaya bir mesaj bırak',
    'Leave a message for yourself or a loved one',
    'پیامی برای خودت یا عزیزانت بگذار',
  );
  String get recSim =>
      _t('⚠️ Simülasyon modu', '⚠️ Simulation mode', '⚠️ حالت شبیه‌سازی');
  String get recListen => _t('Dinle', 'Listen', 'گوش بده');
  String get recListened => _t('✅ Dinlendi', '✅ Listened', '✅ گوش داده شد');
  String get recStop => _t('Durdur', 'Stop', 'توقف');
  String get recRetake => _t('Yeniden', 'Retake', 'دوباره ضبط');
  String get recHint => _t(
    'Devam etmeden önce bir kez dinle',
    'Listen at least once before continuing',
    'قبل از ادامه، یک بار گوش بده',
  );
  String get recContinue => _t(
    'Devam — Kapsülü Mühürle →',
    'Continue — Seal the Capsule →',
    'ادامه — مهر کردن کپسول ←',
  );

  // Uyarı popup
  String get warnAlert => _t('DİKKAT!', 'WARNING!', 'توجه!');
  String get warnTitle => _t(
    'Kaydını Kapsüle\nKilitlemeyi Unutma!',
    'Don\'t Forget to\nSeal Your Recording!',
    'فراموش نکن\nکپسولت را مهر کنی!',
  );
  String get warnBody => _t(
    '🌌 Eğer kapsülü mühürlemeyi unutursan...\nSesin sonsuz dijital evrende kaybolur. 🕳️',
    '🌌 If you forget to seal the capsule...\nYour voice will be lost in the void. 🕳️',
    '🌌 اگر کپسول را مهر نکنی...\nصدایت گم می‌شود. 🕳️',
  );
  String get warnFunny => _t(
    '(Belki biraz abartıyoruz ama devam et 😄)',
    '(Maybe a bit dramatic, but continue 😄)',
    '(شاید کمی اغراق کردیم، ولی ادامه بده 😄)',
  );
  String get warnConfirm => _t(
    '🚀 Evet, Kapsülü Mühürleyelim!',
    '🚀 Yes, Let\'s Seal It!',
    '🚀 بله، کپسول را مهر کنیم!',
  );
  String get warnCancel => _t(
    'Hayır, kaydı sil ve başa dön',
    'No, delete and start over',
    'نه، ضبط را حذف کن',
  );

  // Wizard
  String get wizRecord => _t('🎙️ Kayıt', '🎙️ Record', '🎙️ ضبط');
  String get wizDetails => _t('✏️ Detaylar', '✏️ Details', '✏️ جزئیات');
  String get wizDate => _t('📅 Tarih', '📅 Date', '📅 تاریخ');
  String get wizSummary => _t('👀 Özet', '👀 Summary', '👀 خلاصه');
  String get wizCont => _t('Devam →', 'Continue →', 'ادامه ←');
  String get wizSeal =>
      _t('🎵 Kapsülü Mühürle', '🎵 Seal Capsule', '🎵 مهر کپسول');
  String get wizName =>
      _t('Kapsülüne isim ver', 'Name your capsule', 'اسم کپسولت را بگذار');
  String get wizNameH => _t(
    'Örn: Kendime 10 yıl sonra...',
    'e.g. To myself in 10 years...',
    'مثلاً: به خودم بعد از ۱۰ سال...',
  );
  String get wizColor => _t('Renk seç', 'Choose a color', 'رنگ انتخاب کن');
  String get wizEmoji => _t('Emoji seç', 'Choose an emoji', 'ایموجی انتخاب کن');
  String get wizWhen =>
      _t('Ne zaman açılsın?', 'When should it open?', 'کی باز شود؟');
  String get wizWhenS => _t(
    'Bu tarihte bildirim alacaksın',
    'You\'ll get a notification on this date',
    'در این تاریخ اعلان دریافت می‌کنی',
  );
  String get wizCustom => _t('Özel tarih', 'Custom date', 'تاریخ دلخواه');
  String get wizRecip =>
      _t('Alıcı (opsiyonel)', 'Recipient (optional)', 'گیرنده (اختیاری)');
  String get wizRecipH =>
      _t('Sevdiğin birinin adı', 'A loved one\'s name', 'اسم عزیزت');
  String get wizReady => _t('Hazır mısın?', 'Ready?', 'آماده‌ای؟');
  String get wizDur => _t('Süre', 'Duration', 'مدت');
  String get wizOpen => _t('Açılış', 'Opens on', 'تاریخ باز شدن');
  String get wizRecipL => _t('Alıcı', 'Recipient', 'گیرنده');

  // Mühürlendi
  String get sealTitle =>
      _t('Kapsül Mühürlendi!', 'Capsule Sealed!', 'کپسول مهر شد!');
  String sealDesc(String t, String d) => _t(
    '"$t"\n$d tarihinde açılacak.',
    '"$t"\nwill open on $d.',
    '«$t»\nدر تاریخ $d باز می‌شود.',
  );
  String get sealCode => _t('🔑 Kod', '🔑 Code', '🔑 کد');
  String get sealBtn => _t('Harika! 🚀', 'Awesome! 🚀', 'عالی! 🚀');

  // Detay
  String get detLocked => _t(
    'Bu kapsül henüz açılmadı',
    'This capsule hasn\'t opened yet',
    'این کپسول هنوز باز نشده',
  );
  String get detOpened =>
      _t('🎊 Kapsülün Açıldı!', '🎊 Your Capsule Opened!', '🎊 کپسولت باز شد!');
  String detOpenedDesc(String t) => _t(
    '"$t" artık dinlenmeye hazır.',
    '"$t" is now ready to play.',
    '«$t» آماده پخش است.',
  );
  String get detPlay => _t('🎵 Dinle', '🎵 Play', '🎵 پخش');
  String get detPause => _t('Durdur', 'Pause', 'توقف');
  String get detCreated => _t('Oluşturuldu', 'Created', 'ایجاد شده');
  String get detOpDate => _t('Açılış tarihi', 'Opens on', 'تاریخ باز شدن');
  String get detRecip => _t('Alıcı', 'Recipient', 'گیرنده');
  String get detCode => _t('Paylaşım Kodu', 'Share Code', 'کد اشتراک‌گذاری');
  String get detCopied => _t('Kod kopyalandı!', 'Code copied!', 'کد کپی شد!');
  String get detListen => _t('Dinle 🎵', 'Play 🎵', 'پخش 🎵');

  // Kütüphane
  String get libTitle => _t('Kütüphane', 'Library', 'کتابخانه');
  String get libLocked => _t('🔒  Kilitli', '🔒  Locked', '🔒  قفل‌شده');
  String get libOpen => _t('🔓  Açık', '🔓  Open', '🔓  باز');
  String get libNoLock => _t(
    'Kilitli kapsül yok!',
    'No locked capsules!',
    'کپسول قفل‌شده‌ای نیست!',
  );
  String get libNoLockS => _t(
    'Tüm kapsüller açılmış',
    'All capsules have been opened',
    'همه کپسول‌ها باز شده‌اند',
  );
  String get libNoOpen => _t(
    'Henüz açılan kapsül yok',
    'No opened capsules yet',
    'هنوز کپسول بازی نداری',
  );
  String get libNoOpenS => _t(
    'Kapsüllerin açılış tarihi geldikçe buraya gelir',
    'Capsules appear here once their date arrives',
    'وقتی تاریخ کپسول‌ها برسد اینجا ظاهر می‌شوند',
  );
  String get libPreview =>
      _t('Parazitli Ön Dinleme', 'Noisy Preview', 'پیش‌شنیداری نویزی');
  String get libListened => _t('✅ Dinlendi', '✅ Listened', '✅ گوش داده شد');
  String get libWaiting =>
      _t('🔔 Dinlemeyi bekliyor', '🔔 Waiting to be played', '🔔 منتظر پخش');
  String libProgress(String p) => _t('$p% geçti', '$p% elapsed', '$p٪ گذشته');

  // Geri sayım
  String get cdOpen =>
      _t('🎉 Kapsül Açıldı!', '🎉 Capsule Opened!', '🎉 کپسول باز شد!');
  String get cdDays => _t('GÜN', 'DAYS', 'روز');
  String get cdHours => _t('SAAT', 'HRS', 'ساعت');
  String get cdMin => _t('DAK', 'MIN', 'دقیقه');
  String get cdSec => _t('SN', 'SEC', 'ثانیه');

  // Zaman
  String timeYears(int n) => _t('$n yıl sonra', 'in $n year(s)', '$n سال دیگر');
  String timeMonths(int n) =>
      _t('$n ay sonra', 'in $n month(s)', '$n ماه دیگر');
  String timeDays(int n) => _t('$n gün sonra', 'in $n day(s)', '$n روز دیگر');
  String timeHours(int n) =>
      _t('$n saat sonra', 'in $n hour(s)', '$n ساعت دیگر');
  String timeMin(int n) => _t('$n dk sonra', 'in $n min', '$n دقیقه دیگر');
  String get timeOpen => _t('Açık!', 'Open!', 'باز!');

  // Nav & Profil
  String get navHome => _t('Ana Sayfa', 'Home', 'خانه');
  String get navLib => _t('Kütüphane', 'Library', 'کتابخانه');
  String get profSec => _t(
    'Uçtan Uca Şifreleme Aktif',
    'End-to-End Encryption Active',
    'رمزنگاری سرتاسری فعال',
  );
  String get profSecS => _t(
    'Veriler yalnızca senin cihazında okunabilir',
    'Data is readable only on your device',
    'داده‌ها فقط روی دستگاه شما خوانده می‌شوند',
  );
  // BUG FIX: Bu satır önceden _t(l.profLogout, ...) şeklindeydi → sonsuz özyineleme (stack overflow)
  String get profLogout => _t('Çıkış Yap', 'Sign Out', 'خروج');
  String get profLang => _t(
    'Dil / Language / زبان',
    'Dil / Language / زبان',
    'Dil / Language / زبان',
  );

  // Önayar tarihler
  String get p1m => _t('1 Ay', '1 Month', '۱ ماه');
  String get p3m => _t('3 Ay', '3 Months', '۳ ماه');
  String get p6m => _t('6 Ay', '6 Months', '۶ ماه');
  String get p1y => _t('1 Yıl', '1 Year', '۱ سال');
  String get p5y => _t('5 Yıl', '5 Years', '۵ سال');
  String get p10y => _t('10 Yıl', '10 Years', '۱۰ سال');

  String _t(String tr, String en, String fa) {
    switch (_dil) {
      case AppDil.tr:
        return tr;
      case AppDil.en:
        return en;
      case AppDil.fa:
        return fa;
    }
  }

  // Tarih formatı
  String tarihFmt(DateTime d) {
    switch (_dil) {
      case AppDil.fa:
        const ay = [
          '',
          'فروردین',
          'اردیبهشت',
          'خرداد',
          'تیر',
          'مرداد',
          'شهریور',
          'مهر',
          'آبان',
          'آذر',
          'دی',
          'بهمن',
          'اسفند',
        ];
        return '${d.day} ${ay[d.month]} ${d.year}';
      case AppDil.en:
        const ay = [
          '',
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return '${ay[d.month]} ${d.day}, ${d.year}';
      default:
        const ay = [
          '',
          'Oca',
          'Şub',
          'Mar',
          'Nis',
          'May',
          'Haz',
          'Tem',
          'Ağu',
          'Eyl',
          'Eki',
          'Kas',
          'Ara',
        ];
        return '${d.day} ${ay[d.month]} ${d.year}';
    }
  }

  String kalanSureMetni(Duration k) {
    if (k.isNegative || k.inSeconds <= 0) return timeOpen;
    if (k.inDays >= 365) return timeYears((k.inDays / 365).floor());
    if (k.inDays >= 30) return timeMonths((k.inDays / 30).floor());
    if (k.inDays >= 1) return timeDays(k.inDays);
    if (k.inHours >= 1) return timeHours(k.inHours);
    return timeMin(k.inMinutes);
  }
}

// Global dil erişimi
L get l => L(dilNotifier.value);

const destekliDiller = [
  {'code': AppDil.tr, 'isim': 'Türkçe', 'flag': '🇹🇷'},
  {'code': AppDil.en, 'isim': 'English', 'flag': '🇬🇧'},
  {'code': AppDil.fa, 'isim': 'فارسی', 'flag': '🇮🇷'},
];

// ═══════════════════════════════════════════════════════════════════════════
// GÜVENLİK — AES-256 simülasyonu + cihaz depolama taklidi
// ═══════════════════════════════════════════════════════════════════════════

class Sifrele {
  static const String _salt = 'ZK_SALT_2025_v1';
  static final Map<String, String> _keyCache = {};

  static String _keyTuret(String kullaniciId) {
    if (_keyCache.containsKey(kullaniciId)) return _keyCache[kullaniciId]!;
    var key = '$kullaniciId$_salt';
    for (int i = 0; i < 3; i++) {
      key = base64.encode(utf8.encode(key));
    }
    final result = key.substring(0, min(32, key.length));
    _keyCache[kullaniciId] = result;
    return result;
  }

  static String sifrele(String metin, String kullaniciId) {
    if (metin.isEmpty) return '';
    final key = _keyTuret(kullaniciId);
    final keyBytes = utf8.encode(key);
    final metinBytes = utf8.encode(metin);
    final sifreli = List<int>.generate(
      metinBytes.length,
      (i) => metinBytes[i] ^ keyBytes[i % keyBytes.length],
    );
    final iv = List<int>.generate(16, (i) => (i * 7 + 13) % 256);
    return base64Url.encode([...iv, ...sifreli]);
  }

  static String coz(String sifreliMetin, String kullaniciId) {
    if (sifreliMetin.isEmpty) return '';
    try {
      final key = _keyTuret(kullaniciId);
      final keyBytes = utf8.encode(key);
      final tumBytes = base64Url.decode(sifreliMetin);
      final sifreliBytes = tumBytes.sublist(16);
      final cozulmus = List<int>.generate(
        sifreliBytes.length,
        (i) => sifreliBytes[i] ^ keyBytes[i % keyBytes.length],
      );
      return utf8.decode(cozulmus);
    } catch (_) {
      return '[Şifre Çözülemedi]';
    }
  }

  static String inputTemizle(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'[<>"\x00-\x1F]'), '')
        .trim();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SAHTE CİHAZ DEPOSU
// ═══════════════════════════════════════════════════════════════════════════

class CihazDepo {
  static final Map<String, String> _depo = {};

  static Future<void> yaz(String anahtar, String deger) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _depo[anahtar] = deger;
  }

  static Future<String?> oku(String anahtar) async {
    await Future.delayed(const Duration(milliseconds: 5));
    return _depo[anahtar];
  }

  static Future<void> sil(String anahtar) async {
    _depo.remove(anahtar);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// KULLANICI MODELİ
// ═══════════════════════════════════════════════════════════════════════════

class Kullanici {
  final String id;
  final String ad;
  final String email;
  final String? fotograf;
  final GirisTipi girisTipi;

  const Kullanici({
    required this.id,
    required this.ad,
    required this.email,
    this.fotograf,
    required this.girisTipi,
  });
}

enum GirisTipi { google, apple, email }

// ═══════════════════════════════════════════════════════════════════════════
// KAPSÜL MODELİ
// ═══════════════════════════════════════════════════════════════════════════

class Kapsul {
  final String id;
  final String _sifreliBaslik;
  final int sureSaniye;
  final DateTime olusturmaTarihi;
  final DateTime acilisTarihi;
  final String? _sifreliAlici;
  final Color renk;
  final String emoji;
  final String paylasimKodu;
  final String sahipId;
  bool acildiMi;

  Kapsul({
    required this.id,
    required String sifreliBaslik,
    required this.sureSaniye,
    required this.olusturmaTarihi,
    required this.acilisTarihi,
    String? sifreliAlici,
    required this.renk,
    required this.emoji,
    required this.paylasimKodu,
    required this.sahipId,
    this.acildiMi = false,
  }) : _sifreliBaslik = sifreliBaslik,
       _sifreliAlici = sifreliAlici;

  bool get acilabilirMi => DateTime.now().isAfter(acilisTarihi);
  Duration get kalanSure => acilisTarihi.difference(DateTime.now());

  String baslik(String kullaniciId) => Sifrele.coz(_sifreliBaslik, kullaniciId);
  String? alici(String kullaniciId) {
    final a = _sifreliAlici;
    return a != null ? Sifrele.coz(a, kullaniciId) : null;
  }

  String get kalanSureMetni => l.kalanSureMetni(kalanSure);

  static String _kodUret() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random();
    return List.generate(6, (_) => chars[rng.nextInt(chars.length)]).join();
  }

  factory Kapsul.olustur({
    required String baslik,
    required int sureSaniye,
    required DateTime acilisTarihi,
    String? aliciAdi,
    required Color renk,
    required String emoji,
    required String kullaniciId,
  }) {
    final temizBaslik = Sifrele.inputTemizle(baslik);
    final temizAlici = aliciAdi != null ? Sifrele.inputTemizle(aliciAdi) : null;
    return Kapsul(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sifreliBaslik: Sifrele.sifrele(temizBaslik, kullaniciId),
      sureSaniye: sureSaniye,
      olusturmaTarihi: DateTime.now(),
      acilisTarihi: acilisTarihi,
      sifreliAlici: temizAlici != null
          ? Sifrele.sifrele(temizAlici, kullaniciId)
          : null,
      renk: renk,
      emoji: emoji,
      paylasimKodu: _kodUret(),
      sahipId: kullaniciId,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// UYGULAMA STATE
// ═══════════════════════════════════════════════════════════════════════════

class AppState extends ChangeNotifier {
  Kullanici? _kullanici;
  bool _yukleniyor = false;
  String? _hata;

  final List<Kapsul> _kapsullar = [];

  Kullanici? get kullanici => _kullanici;
  bool get girisYapildi => _kullanici != null;
  bool get yukleniyor => _yukleniyor;
  String? get hata => _hata;
  List<Kapsul> get kapsullar => List.unmodifiable(_kapsullar);
  List<Kapsul> get kilitliler =>
      _kapsullar.where((k) => !k.acilabilirMi).toList();
  List<Kapsul> get aciklar => _kapsullar.where((k) => k.acilabilirMi).toList();

  // Otomatik giriş — test aşamasında login ekranını atla
  AppState() {
    _otomatikGiris();
  }

  void _otomatikGiris() {
    const uid = 'test_kullanici_001';
    _kullanici = Kullanici(
      id: uid,
      ad: 'Test Kullanıcı',
      email: 'test@zamankapsulu.app',
      girisTipi: GirisTipi.email,
    );
    _demokapsulleriEkle();
  }

  Future<void> cikisYap() async {
    await CihazDepo.sil('kullanici_id');
    _kullanici = null;
    _kapsullar.clear();
    notifyListeners();
  }

  void _demokapsulleriEkle() {
    final uid = _kullanici!.id;
    _kapsullar.addAll([
      Kapsul(
        id: '1',
        sifreliBaslik: Sifrele.sifrele('Kendime 1 yıl sonra', uid),
        sureSaniye: 87,
        olusturmaTarihi: DateTime.now().subtract(const Duration(days: 30)),
        acilisTarihi: DateTime.now().add(const Duration(days: 335)),
        renk: const Color(0xFFFF6B6B),
        emoji: '🌟',
        paylasimKodu: 'AX7K2M',
        sahipId: uid,
      ),
      Kapsul(
        id: '2',
        sifreliBaslik: Sifrele.sifrele('Düğün gecesi mesajı', uid),
        sureSaniye: 112,
        olusturmaTarihi: DateTime.now().subtract(const Duration(days: 5)),
        acilisTarihi: DateTime.now().add(const Duration(seconds: 12)),
        sifreliAlici: Sifrele.sifrele('Ayşe', uid),
        renk: const Color(0xFFFF7EB3),
        emoji: '❤️',
        paylasimKodu: 'RK9PLQ',
        sahipId: uid,
      ),
      Kapsul(
        id: '3',
        sifreliBaslik: Sifrele.sifrele('Mezuniyet anısı', uid),
        sureSaniye: 45,
        olusturmaTarihi: DateTime.now().subtract(const Duration(days: 200)),
        acilisTarihi: DateTime.now().subtract(const Duration(days: 10)),
        renk: const Color(0xFF4ECDC4),
        emoji: '🎓',
        paylasimKodu: 'TY3NVB',
        sahipId: uid,
        acildiMi: true,
      ),
      Kapsul(
        id: '4',
        sifreliBaslik: Sifrele.sifrele('Doğum günü sürprizi', uid),
        sureSaniye: 63,
        olusturmaTarihi: DateTime.now().subtract(const Duration(days: 2)),
        acilisTarihi: DateTime.now().add(const Duration(days: 180)),
        sifreliAlici: Sifrele.sifrele('Mehmet', uid),
        renk: const Color(0xFFFFD93D),
        emoji: '🎂',
        paylasimKodu: 'BX4KLP',
        sahipId: uid,
      ),
    ]);
  }

  void ekle(Kapsul k) {
    _kapsullar.insert(0, k);
    notifyListeners();
  }

  void acildiIsaretle(String id) {
    final k = _kapsullar.firstWhere((k) => k.id == id);
    k.acildiMi = true;
    notifyListeners();
  }

  void sil(String id) {
    _kapsullar.removeWhere((k) => k.id == id);
    notifyListeners();
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

// ═══════════════════════════════════════════════════════════════════════════
// TEMA
// ═══════════════════════════════════════════════════════════════════════════

class T {
  // Daha derin siyahlar — luxury dark
  static const bg = Color(0xFF030308);
  static const yuzey = Color(0xFF0A0A16);
  static const yuzeyY = Color(0xFF111122);
  static const sinir = Color(0xFF1A1A30);
  static const sinir2 = Color(0xFF222240);

  // Premium aksan renkleri
  static const birincil = Color(0xFFE8364F); // Koyu kırmızı-pembe
  static const ikincil = Color(0xFF38D9A9); // Zümrüt yeşil
  static const altin = Color(0xFFFFD700); // Saf altın
  static const basari = Color(0xFF51CF66); // Parlak yeşil
  static const mor = Color(0xFFBE4BDB); // Derin mor
  static const mavi = Color(0xFF5C7CFA); // Kraliyet mavisi

  // Metin — daha kontrastlı
  static const metin = Color(0xFFF8F8FF);
  static const metin2 = Color(0xFF8888B0);
  static const metin3 = Color(0xFF44446A);

  static const renkler = [
    Color(0xFFE8364F),
    Color(0xFF38D9A9),
    Color(0xFFFFD700),
    Color(0xFFBE4BDB),
    Color(0xFF51CF66),
    Color(0xFFFF922B),
    Color(0xFF5C7CFA),
    Color(0xFFFF6B9D),
  ];
  static const emojiler = [
    '🎵',
    '❤️',
    '🌟',
    '🎂',
    '🌙',
    '☀️',
    '🌊',
    '🔮',
    '🦋',
    '🌸',
    '🎈',
    '💫',
    '🎯',
    '🏆',
    '🌈',
    '✨',
  ];

  // Luxury gradient butonlar için
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

String tarihFmt(DateTime d) {
  const ay = [
    '',
    'Oca',
    'Şub',
    'Mar',
    'Nis',
    'May',
    'Haz',
    'Tem',
    'Ağu',
    'Eyl',
    'Eki',
    'Kas',
    'Ara',
  ];
  return '${d.day} ${ay[d.month]} ${d.year}';
}

// ═══════════════════════════════════════════════════════════════════════════
// APP
// ═══════════════════════════════════════════════════════════════════════════

class ZamanKapsuluApp extends StatelessWidget {
  const ZamanKapsuluApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      state: AppState(),
      child: ValueListenableBuilder<AppDil>(
        valueListenable: dilNotifier,
        builder: (_, __, ___) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            scaffoldBackgroundColor: T.bg,
            colorScheme: const ColorScheme.dark(
              primary: T.birincil,
              surface: T.yuzey,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleTextStyle: TextStyle(
                color: T.metin,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              iconTheme: IconThemeData(color: T.metin2),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: T.yuzeyY,
              hintStyle: const TextStyle(color: T.metin3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: T.sinir),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: T.sinir),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: T.birincil, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          home: Builder(
            builder: (ctx) {
              final state = AppStateProvider.of(ctx);
              return ListenableBuilder(
                listenable: state,
                builder: (_, __) {
                  // Otomatik giriş yapıldığı için direkt ana ekrana git
                  return const AnaKabuk();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
// ═══════════════════════════════════════════════════════════════════════════
// KOZMİK ARKAPLAN
// ═══════════════════════════════════════════════════════════════════════════

class _Yildiz {
  final double x, y, boyut, parlaklik, faz;
  _Yildiz(Random r)
    : x = r.nextDouble(),
      y = r.nextDouble(),
      boyut = r.nextDouble() * 2.0 + 0.3,
      parlaklik = r.nextDouble() * 0.55 + 0.25,
      faz = r.nextDouble() * pi * 2;
}

class _YildizPainter extends CustomPainter {
  final List<_Yildiz> y;
  final double t;
  _YildizPainter(this.y, this.t);
  @override
  void paint(Canvas canvas, Size size) {
    for (final s in y) {
      final p = s.parlaklik * (sin(t * pi * 2 + s.faz) * 0.3 + 0.7);
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.boyut,
        Paint()..color = Colors.white.withValues(alpha: p),
      );
    }
  }

  @override
  bool shouldRepaint(_YildizPainter o) => o.t != t;
}

class KozmikBg extends StatefulWidget {
  final Widget child;
  const KozmikBg({super.key, required this.child});
  @override
  State<KozmikBg> createState() => _KozmikBgState();
}

class _KozmikBgState extends State<KozmikBg>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<_Yildiz> _yildizlar;
  @override
  void initState() {
    super.initState();
    final r = Random();
    _yildizlar = List.generate(30, (_) => _Yildiz(r)); // 60→30 performans için
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(); // daha yavaş
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      // Derin uzay gradyanı
      Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.4),
            radius: 1.6,
            colors: [Color(0xFF0D0520), Color(0xFF060312), Color(0xFF010108)],
          ),
        ),
      ),
      // Yıldızlar
      AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
          painter: _YildizPainter(_yildizlar, _ctrl.value),
          size: Size.infinite,
        ),
      ),
      // Premium nebula parıltıları
      Positioned(
        top: -120,
        left: -100,
        child: _Hale(renk: const Color(0xFF6B1FA8), boyut: 350, opacity: 0.06),
      ),
      Positioned(
        bottom: -100,
        right: -80,
        child: _Hale(renk: T.birincil, boyut: 280, opacity: 0.04),
      ),
      Positioned(
        top: 180,
        right: -60,
        child: _Hale(renk: T.altin, boyut: 200, opacity: 0.03),
      ),
      Positioned(
        bottom: 200,
        left: -40,
        child: _Hale(renk: T.mavi, boyut: 160, opacity: 0.03),
      ),
      widget.child,
    ],
  );
}

class _Hale extends StatelessWidget {
  final Color renk;
  final double boyut, opacity;
  const _Hale({required this.renk, required this.boyut, this.opacity = 0.06});
  @override
  Widget build(BuildContext context) => Container(
    width: boyut,
    height: boyut,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: renk.withValues(alpha: opacity),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// ANA KABUK — BottomNav
// ═══════════════════════════════════════════════════════════════════════════

class AnaKabuk extends StatefulWidget {
  const AnaKabuk({super.key});
  @override
  State<AnaKabuk> createState() => _AnaKabukState();
}

class _AnaKabukState extends State<AnaKabuk> {
  int _sekme = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(
      index: _sekme,
      children: const [AnaEkran(), KutuphanEkran()],
    ),
    bottomNavigationBar: Container(
      decoration: BoxDecoration(
        color: T.bg.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: T.sinir.withValues(alpha: 0.5), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        indicatorColor: T.birincil.withValues(alpha: 0.12),
        selectedIndex: _sekme,
        onDestinationSelected: (i) => setState(() => _sekme = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined, color: T.metin3),
            selectedIcon: const Icon(Icons.home_rounded, color: T.birincil),
            label: l.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.library_music_outlined, color: T.metin3),
            selectedIcon: const Icon(
              Icons.library_music_rounded,
              color: T.birincil,
            ),
            label: l.navLib,
          ),
        ],
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// KAYIT DALGASI
// ═══════════════════════════════════════════════════════════════════════════

class KayitDalgasi extends StatefulWidget {
  final bool aktif, tamamlandi, parazitli;
  final Color renk;
  const KayitDalgasi({
    super.key,
    required this.aktif,
    this.tamamlandi = false,
    this.parazitli = false,
    this.renk = T.birincil,
  });
  @override
  State<KayitDalgasi> createState() => _KayitDalgasiState();
}

class _KayitDalgasiState extends State<KayitDalgasi>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final List<double> _faz = List.generate(
    28,
    (_) => Random().nextDouble() * pi * 2,
  );
  final Random _rng = Random();
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 80,
    child: AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(28, (i) {
          double h;
          Color c;
          if (widget.parazitli) {
            h = 4 + _rng.nextDouble() * 64;
            c = _rng.nextBool()
                ? Colors.white.withValues(alpha: _rng.nextDouble() * 0.8)
                : widget.renk.withValues(alpha: _rng.nextDouble());
          } else if (widget.tamamlandi) {
            h = 8 + (sin(i * 0.55) + 1) * 9; // 8..26 arası, negatif olmaz
            c = T.basari;
          } else if (widget.aktif) {
            h = 5 + (sin(_ctrl.value * pi * 2 + _faz[i]) * 0.5 + 0.5) * 60;
            c = widget.renk;
          } else {
            h = 3;
            c = T.metin3;
          }
          return Container(
            width: 3,
            height: h.clamp(2.0, 80.0),
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// GERİ SAYIM
// ═══════════════════════════════════════════════════════════════════════════

class GeriSayim extends StatefulWidget {
  final DateTime acilis, olusturma;
  final VoidCallback? onAcildi;
  const GeriSayim({
    super.key,
    required this.acilis,
    required this.olusturma,
    this.onAcildi,
  });
  @override
  State<GeriSayim> createState() => _GeriSayimState();
}

class _GeriSayimState extends State<GeriSayim> {
  Timer? _t;
  Duration _kalan = Duration.zero;
  @override
  void initState() {
    super.initState();
    _guncelle();
    _t = Timer.periodic(const Duration(seconds: 1), (_) => _guncelle());
  }

  void _guncelle() {
    if (!mounted) return;
    final k = widget.acilis.difference(DateTime.now());
    setState(() => _kalan = k.isNegative ? Duration.zero : k);
    if (k.isNegative || k.inSeconds == 0) {
      _t?.cancel();
      widget.onAcildi?.call();
    }
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_kalan == Duration.zero) {
      return Column(
        children: [
          const Text('🔓', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: T.basari.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: T.basari.withValues(alpha: 0.35)),
            ),
            child: Text(
              l.cdOpen,
              style: const TextStyle(
                color: T.basari,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ],
      );
    }
    final toplam = widget.acilis.difference(widget.olusturma).inSeconds;
    final gecen = toplam - _kalan.inSeconds;
    final ilerleme = toplam > 0 ? (gecen / toplam).clamp(0.0, 1.0) : 0.0;
    return Column(
      children: [
        const Text('🔒', style: TextStyle(fontSize: 36)),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ilerleme,
            minHeight: 7,
            backgroundColor: T.sinir2,
            valueColor: const AlwaysStoppedAnimation<Color>(T.altin),
          ),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: T.altin.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(color: T.altin.withValues(alpha: 0.06), blurRadius: 24),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_kalan.inDays > 0) ...[
                _Birim(_kalan.inDays, l.cdDays),
                _Sep(),
              ],
              _Birim(_kalan.inHours.remainder(24), l.cdHours),
              _Sep(),
              _Birim(_kalan.inMinutes.remainder(60), l.cdMin),
              _Sep(),
              _Birim(_kalan.inSeconds.remainder(60), l.cdSec),
            ],
          ),
        ),
      ],
    );
  }
}

class _Birim extends StatelessWidget {
  final int d;
  final String e;
  const _Birim(this.d, this.e);
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        d.toString().padLeft(2, '0'),
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: T.altin,
          fontFamily: 'monospace',
          letterSpacing: 2,
          shadows: [
            Shadow(color: T.altin.withValues(alpha: 0.5), blurRadius: 12),
          ],
        ),
      ),
      const SizedBox(height: 2),
      Text(
        e,
        style: const TextStyle(
          fontSize: 8,
          color: T.metin3,
          letterSpacing: 2,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class _Sep extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: Text(
      ':',
      style: TextStyle(
        fontSize: 24,
        color: T.altin,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// KAPSÜL KARTI
// ═══════════════════════════════════════════════════════════════════════════

class KapsulKarti extends StatelessWidget {
  final Kapsul kapsul;
  final String kullaniciId;
  final VoidCallback onTap;
  const KapsulKarti({
    super.key,
    required this.kapsul,
    required this.kullaniciId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final acik = kapsul.acilabilirMi;
    final baslik = kapsul.baslik(kullaniciId);
    final alici = kapsul.alici(kullaniciId);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: T.yuzey.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: acik
                ? kapsul.renk.withValues(alpha: 0.25)
                : T.sinir.withValues(alpha: 0.6),
          ),
          boxShadow: [
            if (acik)
              BoxShadow(
                color: kapsul.renk.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji kutusu — gradient arkaplan
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kapsul.renk.withValues(alpha: 0.2),
                    kapsul.renk.withValues(alpha: 0.06),
                  ],
                ),
                border: Border.all(color: kapsul.renk.withValues(alpha: 0.2)),
              ),
              child: Center(
                child: Text(kapsul.emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    baslik,
                    style: const TextStyle(
                      color: T.metin,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text('🎵 ', style: TextStyle(fontSize: 11)),
                      Text(
                        sureFmt(kapsul.sureSaniye),
                        style: const TextStyle(color: T.metin3, fontSize: 12),
                      ),
                      if (alici != null) ...[
                        const Text('  💌 ', style: TextStyle(fontSize: 11)),
                        Text(
                          alici,
                          style: TextStyle(
                            color: T.ikincil,
                            fontSize: 12,
                            shadows: [
                              Shadow(
                                color: T.ikincil.withValues(alpha: 0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: acik
                        ? T.basari.withValues(alpha: 0.1)
                        : T.sinir.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: acik
                        ? Border.all(color: T.basari.withValues(alpha: 0.25))
                        : null,
                  ),
                  child: Text(
                    acik ? '🔓' : '🔒',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  kapsul.kalanSureMetni,
                  style: TextStyle(
                    color: acik ? T.basari : T.altin.withValues(alpha: 0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ONBOARDING
// ═══════════════════════════════════════════════════════════════════════════

class OnboardingEkran extends StatefulWidget {
  const OnboardingEkran({super.key});
  @override
  State<OnboardingEkran> createState() => _OnboardingEkranState();
}

class _OnboardingEkranState extends State<OnboardingEkran>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade, _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween(
      begin: 40.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final ad = state.kullanici!.ad.split(' ').first;

    return Scaffold(
      body: KozmikBg(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, child) => Opacity(
              opacity: _fade.value,
              child: Transform.translate(
                offset: Offset(0, _slide.value),
                child: child,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                children: [
                  const Spacer(),

                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [T.mor.withValues(alpha: 0.35), T.bg],
                      ),
                      border: Border.all(
                        color: T.mor.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: const Center(
                      child: Text('🎵', style: TextStyle(fontSize: 52)),
                    ),
                  ),
                  const SizedBox(height: 28),

                  Text(
                    l.onboardingTitle(ad),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: T.metin,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.onbSub,
                    style: const TextStyle(
                      color: T.metin2,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),

                  _OnboardAdim('🎙️', '1', l.onbStep1, l.onbStep1s),
                  const SizedBox(height: 14),
                  _OnboardAdim('📅', '2', l.onbStep2, l.onbStep2s),
                  const SizedBox(height: 14),
                  _OnboardAdim('🔒', '3', l.onbStep3, l.onbStep3s),

                  const Spacer(),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: T.gradBirincil,
                      boxShadow: [
                        BoxShadow(
                          color: T.birincil.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const IlkKapsulEkran(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        l.onbStart,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const AnaKabuk()),
                    ),
                    child: Text(
                      l.onbSkip,
                      style: const TextStyle(color: T.metin3, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardAdim extends StatelessWidget {
  final String emoji, numara, baslik, alt;
  const _OnboardAdim(this.emoji, this.numara, this.baslik, this.alt);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: T.yuzey,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: T.sinir, width: 0.5),
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: T.mor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: T.mor.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                baslik,
                style: const TextStyle(
                  color: T.metin,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(alt, style: const TextStyle(color: T.metin2, fontSize: 12)),
            ],
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: T.sinir,
          ),
          child: Center(
            child: Text(
              numara,
              style: const TextStyle(
                color: T.metin2,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// İLK KAPSÜL EKRANI
// ═══════════════════════════════════════════════════════════════════════════

class IlkKapsulEkran extends StatefulWidget {
  const IlkKapsulEkran({super.key});
  @override
  State<IlkKapsulEkran> createState() => _IlkKapsulEkranState();
}

class _IlkKapsulEkranState extends State<IlkKapsulEkran> {
  bool _kayitYapiyorMu = false;
  bool _tamamlandi = false;
  bool _dinlendi = false;
  bool _oynatiliyor = false;
  int _sure = 0;
  Timer? _kayitTimer;
  bool _wizardAcik = false;

  @override
  void dispose() {
    _kayitTimer?.cancel();
    super.dispose();
  }

  void _kaydiBaslat() {
    setState(() {
      _kayitYapiyorMu = true;
      _sure = 0;
      _tamamlandi = false;
      _dinlendi = false;
    });
    _kayitTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _sure++);
      if (_sure >= 120) _kaydiDurdur();
    });
  }

  void _kaydiDurdur() {
    _kayitTimer?.cancel();
    setState(() {
      _kayitYapiyorMu = false;
      _tamamlandi = true;
    });
  }

  void _oynatToggle() {
    setState(() {
      _oynatiliyor = !_oynatiliyor;
      if (_oynatiliyor) _dinlendi = true;
    });
  }

  void _wizardaGec() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => KayitUyariPopup(
        onDevam: () {
          Navigator.pop(context);
          setState(() => _wizardAcik = true);
        },
        onSil: () {
          Navigator.pop(context);
          setState(() {
            _kayitYapiyorMu = false;
            _tamamlandi = false;
            _dinlendi = false;
            _oynatiliyor = false;
            _sure = 0;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_wizardAcik) {
      return KapsulOlusturEkran(
        oncekiSure: _sure,
        onTamamlandi: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AnaKabuk()),
          (r) => false,
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('🎙️ ${l.recTitle}'),
      ),
      body: KozmikBg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  l.recTitle,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: T.metin,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.recSub,
                  style: const TextStyle(color: T.metin2, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l.recSim,
                  style: const TextStyle(color: T.metin3, fontSize: 11),
                ),

                const Spacer(),

                KayitDalgasi(aktif: _kayitYapiyorMu, tamamlandi: _tamamlandi),
                const SizedBox(height: 12),
                Text(
                  sureFmt(_sure),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: T.metin,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 32),

                if (!_tamamlandi)
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      _kayitYapiyorMu ? _kaydiDurdur() : _kaydiBaslat();
                    },
                    child: Container(
                      width: 114,
                      height: 114,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            _kayitYapiyorMu
                                ? T.birincil.withValues(alpha: 0.3)
                                : T.mor.withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: _kayitYapiyorMu
                                  ? [
                                      T.birincil,
                                      T.birincil.withValues(alpha: 0.7),
                                    ]
                                  : [
                                      T.mor.withValues(alpha: 0.25),
                                      T.birincil.withValues(alpha: 0.15),
                                    ],
                            ),
                            border: Border.all(
                              color: _kayitYapiyorMu
                                  ? T.birincil
                                  : T.mor.withValues(alpha: 0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (_kayitYapiyorMu ? T.birincil : T.mor)
                                    .withValues(alpha: 0.35),
                                blurRadius: _kayitYapiyorMu ? 28 : 16,
                              ),
                            ],
                          ),
                          child: Icon(
                            _kayitYapiyorMu
                                ? Icons.stop_rounded
                                : Icons.mic_none_rounded,
                            size: 46,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _KBtn(
                        icon: _oynatiliyor ? Icons.pause : Icons.play_arrow,
                        label: _oynatiliyor
                            ? l.recStop
                            : (_dinlendi ? l.recListened : l.recListen),
                        renk: _dinlendi ? T.basari : T.ikincil,
                        onTap: _oynatToggle,
                      ),
                      const SizedBox(width: 14),
                      _KBtn(
                        icon: Icons.refresh_rounded,
                        label: l.recRetake,
                        renk: T.metin2,
                        onTap: () => setState(() {
                          _kayitYapiyorMu = false;
                          _tamamlandi = false;
                          _dinlendi = false;
                          _oynatiliyor = false;
                          _sure = 0;
                        }),
                      ),
                    ],
                  ),

                const Spacer(),

                if (_tamamlandi && !_dinlendi)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: T.altin.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: T.altin.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('👂', style: TextStyle(fontSize: 15)),
                        const SizedBox(width: 8),
                        Text(
                          l.recHint,
                          style: const TextStyle(
                            color: T.altin,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                (_tamamlandi && _dinlendi)
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: T.gradBirincil,
                          boxShadow: [
                            BoxShadow(
                              color: T.birincil.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _wizardaGec,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            l.recContinue,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: T.sinir,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            l.recContinue,
                            style: TextStyle(
                              color: T.metin3,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ANA EKRAN
// ═══════════════════════════════════════════════════════════════════════════

class AnaEkran extends StatelessWidget {
  const AnaEkran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              '✦',
              style: TextStyle(
                fontSize: 18,
                color: T.altin,
                shadows: [
                  Shadow(color: T.altin.withValues(alpha: 0.5), blurRadius: 8),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l.appName,
              style: const TextStyle(
                color: T.metin,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (ctx) {
              final state = AppStateProvider.of(ctx);
              return IconButton(
                icon: const Icon(Icons.person_outline_rounded, color: T.metin2),
                onPressed: () => _profilMenu(ctx, state),
              );
            },
          ),
        ],
      ),
      body: KozmikBg(
        child: SafeArea(
          child: Builder(
            builder: (ctx) {
              final state = AppStateProvider.of(ctx);
              final liste = state.kapsullar;
              final uid = state.kullanici!.id;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _HeroKart(state: state)),
                  SliverToBoxAdapter(child: _IstatistikSerit(state: state)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(
                        l.homeRecent,
                        style: const TextStyle(
                          color: T.metin2,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  if (liste.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🎵', style: TextStyle(fontSize: 64)),
                            const SizedBox(height: 16),
                            Text(
                              l.homeEmpty,
                              style: const TextStyle(
                                color: T.metin,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l.homeEmptyDesc,
                              style: const TextStyle(color: T.metin2),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) => KapsulKarti(
                            kapsul: liste[i],
                            kullaniciId: uid,
                            onTap: () => Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) =>
                                    KapsulDetayEkran(kapsul: liste[i]),
                              ),
                            ),
                          ),
                          childCount: liste.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: T.gradBirincil,
          boxShadow: [
            BoxShadow(
              color: T.birincil.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KapsulOlusturEkran()),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text(
            l.homeNewCap,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  void _profilMenu(BuildContext ctx, AppState state) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: T.yuzeyY,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: T.sinir2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: T.mor.withValues(alpha: 0.15),
                    border: Border.all(color: T.mor.withValues(alpha: 0.3)),
                  ),
                  child: const Center(
                    child: Text('👤', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.kullanici!.ad,
                      style: const TextStyle(
                        color: T.metin,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      state.kullanici!.email,
                      style: const TextStyle(color: T.metin2, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: T.sinir),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: T.basari.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: T.basari.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Text('🔐', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.profSec,
                          style: const TextStyle(
                            color: T.basari,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          l.profSecS,
                          style: const TextStyle(color: T.metin2, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Dil seçici
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: T.yuzey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: T.sinir),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.profLang,
                    style: const TextStyle(
                      color: T.metin2,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _ProfilDilSecici(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Versiyon bilgisi
            Text(
              'Zaman Kapsülü v0.1.0 — DartPad Prototype',
              style: TextStyle(
                color: T.metin3.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Profil dil seçici ────────────────────────────────────────────────────

class _ProfilDilSecici extends StatelessWidget {
  const _ProfilDilSecici();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppDil>(
      valueListenable: dilNotifier,
      builder: (_, secili, __) => Row(
        children: [
          for (final d in destekliDiller)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  dilNotifier.degistir(d['code'] as AppDil);
                  Navigator.pop(context); // sheet'i kapat, UI yenilensin
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: secili == d['code']
                        ? T.birincil.withValues(alpha: 0.15)
                        : T.sinir,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: secili == d['code'] ? T.birincil : T.sinir2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        d['flag'] as String,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (d['code'] as AppDil).name.toUpperCase(),
                        style: TextStyle(
                          color: secili == d['code'] ? T.birincil : T.metin2,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Hero kart ────────────────────────────────────────────────────────────

class _HeroKart extends StatelessWidget {
  final AppState state;
  const _HeroKart({required this.state});

  @override
  Widget build(BuildContext context) {
    final acik = state.aciklar;
    final kilitli = state.kilitliler;
    final ad = state.kullanici!.ad.split(' ').first;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A0838).withValues(alpha: 0.95),
              const Color(0xFF080E28).withValues(alpha: 0.95),
            ],
          ),
          border: Border.all(color: T.altin.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: T.mor.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: T.altin.withValues(alpha: 0.05),
              blurRadius: 60,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.homeWelcome(ad),
                    style: const TextStyle(color: T.metin2, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    acik.isNotEmpty
                        ? l.homeOpenReady(acik.length)
                        : kilitli.isNotEmpty
                        ? l.homeLockedCount(kilitli.length)
                        : l.homeFirstPrompt,
                    style: const TextStyle(
                      color: T.metin,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (acik.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: T.basari.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: T.basari.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        '🎉 ${l.homeOpenCount(acik.length)}',
                        style: const TextStyle(
                          color: T.basari,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _MiniRing(
              kilitli: kilitli.length,
              acik: acik.length,
              toplam: state.kapsullar.length,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniRing extends StatelessWidget {
  final int kilitli, acik, toplam;
  const _MiniRing({
    required this.kilitli,
    required this.acik,
    required this.toplam,
  });

  @override
  Widget build(BuildContext context) {
    final oran = toplam > 0 ? acik / toplam : 0.0;
    return SizedBox(
      width: 94,
      height: 94,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow arka plan
          Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: T.basari.withValues(alpha: oran * 0.2),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 88,
            height: 88,
            child: CircularProgressIndicator(
              value: oran,
              strokeWidth: 6,
              backgroundColor: T.sinir2.withValues(alpha: 0.5),
              valueColor: const AlwaysStoppedAnimation<Color>(T.basari),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$acik/$toplam',
                style: const TextStyle(
                  color: T.metin,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
              Text(
                l.openRing,
                style: TextStyle(
                  color: T.metin2.withValues(alpha: 0.7),
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── İstatistik şeridi ────────────────────────────────────────────────────

class _IstatistikSerit extends StatelessWidget {
  final AppState state;
  const _IstatistikSerit({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _StatKart(
            '🔒',
            '${state.kilitliler.length}',
            l.homeLocked,
            T.birincil,
          ),
          const SizedBox(width: 8),
          _StatKart('🔓', '${state.aciklar.length}', l.homeUnlocked, T.basari),
          const SizedBox(width: 8),
          _StatKart('📦', '${state.kapsullar.length}', l.homeTotal, T.ikincil),
        ],
      ),
    );
  }
}

class _StatKart extends StatelessWidget {
  final String ikon, sayi, etiket;
  final Color renk;
  const _StatKart(this.ikon, this.sayi, this.etiket, this.renk);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: T.yuzey.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: renk.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(color: renk.withValues(alpha: 0.06), blurRadius: 16),
        ],
      ),
      child: Column(
        children: [
          Text(ikon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            sayi,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: renk,
              shadows: [
                Shadow(color: renk.withValues(alpha: 0.4), blurRadius: 12),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            etiket,
            style: const TextStyle(
              color: T.metin3,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// KÜTÜPHANE EKRANI
// ═══════════════════════════════════════════════════════════════════════════

class KutuphanEkran extends StatefulWidget {
  const KutuphanEkran({super.key});
  @override
  State<KutuphanEkran> createState() => _KutuphanEkranState();
}

class _KutuphanEkranState extends State<KutuphanEkran>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('🎵', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              l.libTitle,
              style: const TextStyle(
                color: T.metin,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: T.birincil,
          indicatorWeight: 2,
          labelColor: T.birincil,
          unselectedLabelColor: T.metin3,
          tabs: [
            Tab(text: l.libLocked),
            Tab(text: l.libOpen),
          ],
        ),
      ),
      body: KozmikBg(
        child: SafeArea(
          child: Builder(
            builder: (ctx) {
              final state = AppStateProvider.of(ctx);
              final uid = state.kullanici!.id;
              return TabBarView(
                controller: _tab,
                children: [
                  _KilitliListe(kapsullar: state.kilitliler, uid: uid),
                  _AcikListe(kapsullar: state.aciklar, uid: uid),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _KilitliListe extends StatelessWidget {
  final List<Kapsul> kapsullar;
  final String uid;
  const _KilitliListe({required this.kapsullar, required this.uid});

  @override
  Widget build(BuildContext context) {
    if (kapsullar.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              l.libNoLock,
              style: const TextStyle(
                color: T.metin,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(l.libNoLockS, style: const TextStyle(color: T.metin2)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: kapsullar.length,
      itemBuilder: (ctx, i) {
        final k = kapsullar[i];
        final toplam = k.acilisTarihi.difference(k.olusturmaTarihi).inSeconds;
        final gecen = toplam - k.kalanSure.inSeconds;
        final yuzde = toplam > 0 ? (gecen / toplam).clamp(0.0, 1.0) : 0.0;
        return GestureDetector(
          onTap: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => KapsulDetayEkran(kapsul: k)),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: T.yuzey,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: T.sinir, width: 0.5),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: k.renk.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: k.renk.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            k.emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              k.baslik(uid),
                              style: const TextStyle(
                                color: T.metin,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              k.kalanSure.inDays > 0
                                  ? '${k.kalanSure.inDays} ${l.cdDays.toLowerCase()} ${k.kalanSure.inHours.remainder(24)} ${l.cdHours.toLowerCase()}'
                                  : '${k.kalanSure.inHours} ${l.cdHours.toLowerCase()} ${k.kalanSure.inMinutes.remainder(60)} ${l.cdMin.toLowerCase()}',
                              style: const TextStyle(
                                color: T.altin,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (k.alici(uid) != null)
                              Text(
                                '💌 ${k.alici(uid)}',
                                style: const TextStyle(
                                  color: T.ikincil,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: T.sinir,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('🔒', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: yuzde,
                          minHeight: 5,
                          backgroundColor: T.sinir2,
                          valueColor: AlwaysStoppedAnimation<Color>(k.renk),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l.tarihFmt(k.olusturmaTarihi),
                            style: const TextStyle(
                              color: T.metin3,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            l.libProgress((yuzde * 100).toStringAsFixed(0)),
                            style: const TextStyle(
                              color: T.metin3,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            l.tarihFmt(k.acilisTarihi),
                            style: const TextStyle(
                              color: T.metin3,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => showDialog(
                    context: ctx,
                    builder: (_) => _ParazitDialog(kapsul: k, uid: uid),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: k.renk.withValues(alpha: 0.07),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hearing,
                          size: 15,
                          color: k.renk.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l.libPreview,
                          style: TextStyle(
                            color: k.renk.withValues(alpha: 0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ParazitDialog extends StatefulWidget {
  final Kapsul kapsul;
  final String uid;
  const _ParazitDialog({required this.kapsul, required this.uid});
  @override
  State<_ParazitDialog> createState() => _ParazitDialogState();
}

class _ParazitDialogState extends State<_ParazitDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _titreCtrl;
  bool _oynatiliyor = false;
  final _chars =
      'ABCDEFGHİJKLMNOPRSTUVYZabcdefghijklmnoprstuvyz0123456789@#*!?';
  String _sifreliMetin = '';
  Timer? _sifreTimer;
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _titreCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    )..stop();
  }

  @override
  void dispose() {
    _titreCtrl.dispose();
    _sifreTimer?.cancel();
    super.dispose();
  }

  void _toggle() {
    setState(() => _oynatiliyor = !_oynatiliyor);
    if (_oynatiliyor) {
      _titreCtrl.repeat(reverse: true);
      final baslik = widget.kapsul.baslik(widget.uid);
      _sifreTimer = Timer.periodic(const Duration(milliseconds: 80), (_) {
        if (!mounted) return;
        setState(() {
          _sifreliMetin = List.generate(
            baslik.length,
            (i) => _rng.nextDouble() < 0.6
                ? _chars[_rng.nextInt(_chars.length)]
                : baslik[i],
          ).join();
        });
      });
    } else {
      _titreCtrl.stop();
      _sifreTimer?.cancel();
      setState(() => _sifreliMetin = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _titreCtrl,
        builder: (_, child) => Transform.translate(
          offset: _oynatiliyor
              ? Offset(
                  (_rng.nextDouble() - 0.5) * 4,
                  (_rng.nextDouble() - 0.5) * 3,
                )
              : Offset.zero,
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: T.yuzeyY,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.kapsul.renk.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    widget.kapsul.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _oynatiliyor && _sifreliMetin.isNotEmpty
                          ? _sifreliMetin
                          : widget.kapsul.baslik(widget.uid),
                      style: TextStyle(
                        color: _oynatiliyor ? widget.kapsul.renk : T.metin,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        fontFamily: _oynatiliyor ? 'monospace' : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              KayitDalgasi(
                aktif: false,
                tamamlandi: false,
                parazitli: _oynatiliyor,
                renk: widget.kapsul.renk,
              ),
              const SizedBox(height: 10),
              if (_oynatiliyor)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.25),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Text('📡', style: TextStyle(fontSize: 13)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Sinyal zayıf — tam ses için açılış tarihini bekle.',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: T.yuzey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: T.sinir),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('⏳ ', style: TextStyle(fontSize: 14)),
                    Text(
                      widget.kapsul.kalanSureMetni,
                      style: const TextStyle(
                        color: T.altin,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _toggle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _oynatiliyor
                            ? Colors.red.withValues(alpha: 0.75)
                            : widget.kapsul.renk,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        _oynatiliyor ? Icons.stop_rounded : Icons.hearing,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        _oynatiliyor ? l.recStop : '📡 ${l.libPreview}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: T.sinir,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.close, color: T.metin2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AcikListe extends StatelessWidget {
  final List<Kapsul> kapsullar;
  final String uid;
  const _AcikListe({required this.kapsullar, required this.uid});

  @override
  Widget build(BuildContext context) {
    if (kapsullar.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔒', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              l.libNoOpen,
              style: const TextStyle(
                color: T.metin,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l.libNoOpenS,
              style: const TextStyle(color: T.metin2),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: kapsullar.length,
      itemBuilder: (ctx, i) {
        final k = kapsullar[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => KapsulDetayEkran(kapsul: k)),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: T.yuzey,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: T.basari.withValues(alpha: 0.25)),
              boxShadow: [
                BoxShadow(
                  color: k.renk.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: k.renk.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(k.emoji, style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        k.baslik(uid),
                        style: const TextStyle(
                          color: T.metin,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        k.acildiMi ? l.libListened : l.libWaiting,
                        style: TextStyle(
                          color: k.acildiMi ? T.basari : T.altin,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        l.tarihFmt(k.acilisTarihi),
                        style: const TextStyle(color: T.metin3, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: T.basari.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: T.basari.withValues(alpha: 0.3)),
                  ),
                  child: const Text('🔓', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// KAYIT SONRASI POPUP
// ═══════════════════════════════════════════════════════════════════════════

class KayitUyariPopup extends StatefulWidget {
  final VoidCallback onDevam, onSil;
  const KayitUyariPopup({
    super.key,
    required this.onDevam,
    required this.onSil,
  });
  @override
  State<KayitUyariPopup> createState() => _KayitUyariPopupState();
}

class _KayitUyariPopupState extends State<KayitUyariPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale, _fade;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: T.yuzeyY,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: T.mor.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: T.mor.withValues(alpha: 0.2),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PulsatingIcon(),
                  const SizedBox(height: 14),
                  Text(
                    '⚠️  ${l.warnAlert}',
                    style: const TextStyle(
                      color: T.altin,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.warnTitle,
                    style: const TextStyle(
                      color: T.metin,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: T.yuzey,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: T.sinir),
                    ),
                    child: Text(
                      l.warnBody,
                      style: const TextStyle(
                        color: T.metin2,
                        fontSize: 13,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.warnFunny,
                    style: const TextStyle(color: T.metin3, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: T.gradBirincil,
                      boxShadow: [
                        BoxShadow(
                          color: T.birincil.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: widget.onDevam,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l.warnConfirm,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: widget.onSil,
                    child: Text(
                      l.warnCancel,
                      style: const TextStyle(color: T.metin3, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PulsatingIcon extends StatefulWidget {
  @override
  State<_PulsatingIcon> createState() => _PulsatingIconState();
}

class _PulsatingIconState extends State<_PulsatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _anim = Tween(
      begin: 0.88,
      end: 1.12,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _anim,
    builder: (_, __) => Transform.scale(
      scale: _anim.value,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: T.mor.withValues(alpha: 0.14),
          border: Border.all(color: T.mor.withValues(alpha: 0.4), width: 2),
        ),
        child: const Center(child: Text('🌌', style: TextStyle(fontSize: 30))),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// KAPSÜL OLUŞTUR
// ═══════════════════════════════════════════════════════════════════════════

class KapsulOlusturEkran extends StatefulWidget {
  final int oncekiSure;
  final VoidCallback? onTamamlandi;

  const KapsulOlusturEkran({super.key, this.oncekiSure = 0, this.onTamamlandi});
  @override
  State<KapsulOlusturEkran> createState() => _KapsulOlusturEkranState();
}

class _KapsulOlusturEkranState extends State<KapsulOlusturEkran> {
  late int _adim;
  bool _kayitYapiyorMu = false;
  bool _tamamlandi = false;
  bool _oynatiliyor = false;
  bool _enAzBirKezDinlendi = false;
  late int _sure;
  Timer? _kayitTimer;

  final _baslikCtrl = TextEditingController();
  Color _renk = T.birincil;
  String _emoji = '🎵';
  DateTime _acilis = DateTime.now().add(const Duration(days: 365));
  String _alici = '';

  @override
  void initState() {
    super.initState();
    if (widget.oncekiSure > 0) {
      _sure = widget.oncekiSure;
      _tamamlandi = true;
      _enAzBirKezDinlendi = true;
      _adim = 1;
    } else {
      _sure = 0;
      _adim = 0;
    }
  }

  void _kaydiBaslat() {
    setState(() {
      _kayitYapiyorMu = true;
      _sure = 0;
      _tamamlandi = false;
      _enAzBirKezDinlendi = false;
    });
    _kayitTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _sure++);
      if (_sure >= 120) _kaydiDurdur();
    });
  }

  void _kaydiDurdur() {
    _kayitTimer?.cancel();
    setState(() {
      _kayitYapiyorMu = false;
      _tamamlandi = true;
    });
  }

  void _oynatToggle() {
    setState(() {
      _oynatiliyor = !_oynatiliyor;
      if (_oynatiliyor) _enAzBirKezDinlendi = true;
    });
  }

  void _sifirla() {
    _kayitTimer?.cancel();
    setState(() {
      _kayitYapiyorMu = false;
      _tamamlandi = false;
      _oynatiliyor = false;
      _enAzBirKezDinlendi = false;
      _sure = 0;
      _baslikCtrl.clear();
      _renk = T.birincil;
      _emoji = '🎵';
      _acilis = DateTime.now().add(const Duration(days: 365));
      _alici = '';
      _adim = 0;
    });
  }

  bool get _gecerli {
    if (_adim == 0) return _tamamlandi && _enAzBirKezDinlendi;
    if (_adim == 1) return _baslikCtrl.text.trim().length >= 2;
    return true;
  }

  void _devamEt() {
    if (_adim == 0) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => KayitUyariPopup(
          onDevam: () {
            Navigator.pop(context);
            setState(() => _adim = 1);
          },
          onSil: () {
            Navigator.pop(context);
            _sifirla();
          },
        ),
      );
    } else if (_adim < 3) {
      setState(() => _adim++);
    } else {
      _olustur();
    }
  }

  void _olustur() {
    HapticFeedback.heavyImpact();
    final state = AppStateProvider.of(context);
    final uid = state.kullanici!.id;
    final k = Kapsul.olustur(
      baslik: _baslikCtrl.text.trim(),
      sureSaniye: _sure,
      acilisTarihi: _acilis,
      aliciAdi: _alici.isNotEmpty ? _alici : null,
      renk: _renk,
      emoji: _emoji,
      kullaniciId: uid,
    );
    state.ekle(k);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: T.yuzeyY,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            Text(
              l.sealTitle,
              style: const TextStyle(
                color: T.metin,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.sealDesc(k.baslik(uid), l.tarihFmt(k.acilisTarihi)),
              style: const TextStyle(color: T.metin2, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: T.sinir,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${l.sealCode} ', style: const TextStyle(fontSize: 16)),
                  Text(
                    k.paylasimKodu,
                    style: const TextStyle(
                      color: T.altin,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      letterSpacing: 5,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.onTamamlandi != null) {
                widget.onTamamlandi!();
              } else {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: T.birincil),
            child: Text(l.sealBtn, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _kayitTimer?.cancel();
    _baslikCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adimBasliklari = [l.wizRecord, l.wizDetails, l.wizDate, l.wizSummary];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () =>
              _adim > 0 ? setState(() => _adim--) : Navigator.pop(context),
        ),
        title: Text(adimBasliklari[_adim]),
      ),
      body: KozmikBg(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(
                    4,
                    (i) => Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: i < _adim
                              ? T.birincil
                              : i == _adim
                              ? T.birincil.withValues(alpha: 0.45)
                              : T.sinir,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: [_adim0(), _adim1(), _adim2(), _adim3()][_adim],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_adim == 0 && _tamamlandi && !_enAzBirKezDinlendi)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: T.altin.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: T.altin.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('👂', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Text(
                                l.recHint,
                                style: const TextStyle(
                                  color: T.altin,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Gradient devam butonu
                    _gecerli
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: _adim < 3
                                  ? T.gradBirincil
                                  : T.gradAltin,
                              boxShadow: [
                                BoxShadow(
                                  color: (_adim < 3 ? T.birincil : T.altin)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _devamEt,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                _adim < 3 ? l.wizCont : l.wizSeal,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: T.sinir,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              _adim < 3 ? l.wizCont : l.wizSeal,
                              style: TextStyle(
                                color: T.metin3,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _adim0() => Column(
    children: [
      const SizedBox(height: 20),
      Text(
        l.recTitle,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: T.metin,
        ),
      ),
      const SizedBox(height: 6),
      Text(l.recSim, style: const TextStyle(color: T.metin2, fontSize: 12)),
      const SizedBox(height: 28),
      KayitDalgasi(aktif: _kayitYapiyorMu, tamamlandi: _tamamlandi),
      const SizedBox(height: 10),
      Text(
        sureFmt(_sure),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: T.metin,
          fontFamily: 'monospace',
        ),
      ),
      const SizedBox(height: 28),
      if (!_tamamlandi)
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            _kayitYapiyorMu ? _kaydiDurdur() : _kaydiBaslat();
          },
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _kayitYapiyorMu
                      ? T.birincil.withValues(alpha: 0.3)
                      : T.mor.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _kayitYapiyorMu
                        ? [T.birincil, T.birincil.withValues(alpha: 0.7)]
                        : [
                            T.mor.withValues(alpha: 0.25),
                            T.birincil.withValues(alpha: 0.15),
                          ],
                  ),
                  border: Border.all(
                    color: _kayitYapiyorMu
                        ? T.birincil
                        : T.mor.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (_kayitYapiyorMu ? T.birincil : T.mor).withValues(
                        alpha: 0.35,
                      ),
                      blurRadius: _kayitYapiyorMu ? 28 : 16,
                      spreadRadius: _kayitYapiyorMu ? 2 : 0,
                    ),
                  ],
                ),
                child: Icon(
                  _kayitYapiyorMu ? Icons.stop_rounded : Icons.mic_none_rounded,
                  size: 42,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      else
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _KBtn(
              icon: _oynatiliyor ? Icons.pause : Icons.play_arrow,
              label: _oynatiliyor
                  ? l.recStop
                  : (_enAzBirKezDinlendi ? l.recListened : l.recListen),
              renk: _enAzBirKezDinlendi ? T.basari : T.ikincil,
              onTap: _oynatToggle,
            ),
            const SizedBox(width: 14),
            _KBtn(
              icon: Icons.delete_outline,
              label: l.recRetake,
              renk: T.birincil,
              onTap: _sifirla,
            ),
          ],
        ),
    ],
  );

  Widget _adim1() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20),
      Text(
        l.wizName,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: T.metin,
        ),
      ),
      const SizedBox(height: 20),
      TextField(
        controller: _baslikCtrl,
        autofocus: true,
        maxLength: 60,
        style: const TextStyle(color: T.metin),
        decoration: InputDecoration(hintText: l.wizNameH),
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: 20),
      Text(
        l.wizColor,
        style: const TextStyle(
          color: T.metin2,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: T.renkler
              .map(
                (r) => GestureDetector(
                  onTap: () => setState(() => _renk = r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: r,
                      shape: BoxShape.circle,
                      border: _renk == r
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      const SizedBox(height: 20),
      Text(
        l.wizEmoji,
        style: const TextStyle(
          color: T.metin2,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: T.emojiler
            .map(
              (e) => GestureDetector(
                onTap: () => setState(() => _emoji = e),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _emoji == e
                        ? T.birincil.withValues(alpha: 0.18)
                        : T.yuzey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _emoji == e ? T.birincil : T.sinir,
                    ),
                  ),
                  child: Center(
                    child: Text(e, style: const TextStyle(fontSize: 24)),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ],
  );

  Widget _adim2() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20),
      Text(
        l.wizWhen,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: T.metin,
        ),
      ),
      const SizedBox(height: 20),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children:
            [
                  {'e': l.p1m, 'g': 30},
                  {'e': l.p3m, 'g': 90},
                  {'e': l.p6m, 'g': 180},
                  {'e': l.p1y, 'g': 365},
                  {'e': l.p5y, 'g': 1825},
                  {'e': l.p10y, 'g': 3650},
                ]
                .map(
                  (o) => OutlinedButton(
                    onPressed: () => setState(
                      () => _acilis = DateTime.now().add(
                        Duration(days: o['g'] as int),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: T.metin,
                      side: const BorderSide(color: T.sinir2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(o['e'] as String),
                  ),
                )
                .toList(),
      ),
      const SizedBox(height: 14),
      GestureDetector(
        onTap: () async {
          final t = await showDatePicker(
            context: context,
            initialDate: _acilis,
            firstDate: DateTime.now().add(const Duration(days: 1)),
            lastDate: DateTime(2050),
            builder: (ctx, child) => Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(primary: T.birincil),
              ),
              child: child!,
            ),
          );
          if (t != null) setState(() => _acilis = t);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: T.yuzeyY,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: T.sinir),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_month, color: T.birincil, size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.wizCustom,
                    style: const TextStyle(color: T.metin2, fontSize: 12),
                  ),
                  Text(
                    l.tarihFmt(_acilis),
                    style: const TextStyle(
                      color: T.metin,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: T.metin3),
            ],
          ),
        ),
      ),
      const SizedBox(height: 24),
      Text(
        l.wizRecip,
        style: const TextStyle(
          color: T.metin2,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
      TextField(
        onChanged: (v) => _alici = v,
        style: const TextStyle(color: T.metin),
        decoration: InputDecoration(hintText: l.wizRecipH),
      ),
    ],
  );

  Widget _adim3() => Column(
    children: [
      const SizedBox(height: 20),
      Text(
        l.wizReady,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: T.metin,
        ),
      ),
      const SizedBox(height: 28),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: T.yuzey,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _renk, width: 2),
          boxShadow: [
            BoxShadow(color: _renk.withValues(alpha: 0.18), blurRadius: 22),
          ],
        ),
        child: Column(
          children: [
            Text(_emoji, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            Text(
              _baslikCtrl.text.isEmpty ? l.appName : _baslikCtrl.text,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: T.metin,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Divider(color: T.sinir),
            const SizedBox(height: 8),
            _OzetSatir('🎵', l.wizDur, sureFmt(_sure)),
            _OzetSatir('📅', l.wizOpen, l.tarihFmt(_acilis)),
            if (_alici.isNotEmpty) _OzetSatir('💌', l.wizRecipL, _alici),
          ],
        ),
      ),
    ],
  );
}

class _KBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color renk;
  final VoidCallback onTap;
  const _KBtn({
    required this.icon,
    required this.label,
    required this.renk,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      HapticFeedback.lightImpact();
      onTap();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [renk.withValues(alpha: 0.2), renk.withValues(alpha: 0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: renk.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: renk.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: renk, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: renk,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}

class _OzetSatir extends StatelessWidget {
  final String ikon, etiket, deger;
  const _OzetSatir(this.ikon, this.etiket, this.deger);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text('$ikon ', style: const TextStyle(fontSize: 16)),
        Text(
          '$etiket  ',
          style: const TextStyle(color: T.metin3, fontSize: 13),
        ),
        Expanded(
          child: Text(
            deger,
            style: const TextStyle(
              color: T.metin,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// KAPSÜL DETAY
// ═══════════════════════════════════════════════════════════════════════════

class KapsulDetayEkran extends StatefulWidget {
  final Kapsul kapsul;
  const KapsulDetayEkran({super.key, required this.kapsul});
  @override
  State<KapsulDetayEkran> createState() => _KapsulDetayEkranState();
}

class _KapsulDetayEkranState extends State<KapsulDetayEkran>
    with SingleTickerProviderStateMixin {
  late AnimationController _parlakCtrl;
  bool _acildi = false;
  bool _oynatiliyor = false;

  AppDil get _dil => dilNotifier.value;

  @override
  void initState() {
    super.initState();
    _acildi = widget.kapsul.acilabilirMi;
    _parlakCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _parlakCtrl.dispose();
    super.dispose();
  }

  void _oynatToggle() {
    final state = AppStateProvider.of(context);
    final uid = state.kullanici!.id;
    if (!_acildi) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.detLocked), backgroundColor: T.birincil),
      );
      return;
    }
    if (!widget.kapsul.acildiMi) {
      state.acildiIsaretle(widget.kapsul.id);
      _kutlamaGoster(uid);
    }
    setState(() => _oynatiliyor = !_oynatiliyor);
  }

  void _kutlamaGoster(String uid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _KutlamaDialog(
        kapsul: widget.kapsul,
        uid: uid,
        onKapat: () => Navigator.pop(context),
      ),
    );
  }

  void _silOnay(BuildContext ctx) {
    HapticFeedback.mediumImpact();
    final silLabel = _dil == AppDil.en
        ? 'Delete'
        : _dil == AppDil.fa
        ? 'حذف'
        : 'Sil';
    final iptalLabel = _dil == AppDil.en
        ? 'Cancel'
        : _dil == AppDil.fa
        ? 'انصراف'
        : 'İptal';
    final baslik = _dil == AppDil.en
        ? 'Delete this capsule?'
        : _dil == AppDil.fa
        ? 'این کپسول حذف شود؟'
        : 'Bu kapsülü silmek istediğine emin misin?';
    final aciklama = _dil == AppDil.en
        ? 'This action cannot be undone.'
        : _dil == AppDil.fa
        ? 'این عمل قابل بازگشت نیست.'
        : 'Bu işlem geri alınamaz.';

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: T.yuzeyY,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('⚠️ ', style: TextStyle(fontSize: 20)),
            Expanded(
              child: Text(
                baslik,
                style: const TextStyle(
                  color: T.metin,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          aciklama,
          style: const TextStyle(color: T.metin2, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(iptalLabel, style: const TextStyle(color: T.metin2)),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              final state = AppStateProvider.of(context);
              state.sil(widget.kapsul.id);
              Navigator.pop(ctx); // dialog kapat
              Navigator.pop(context); // detay ekranından çık
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              silLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = AppStateProvider.of(context).kullanici!.id;
    final renk = widget.kapsul.renk;
    final baslik = widget.kapsul.baslik(uid);
    final alici = widget.kapsul.alici(uid);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: KozmikBg(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 12),
                AnimatedBuilder(
                  animation: _parlakCtrl,
                  builder: (_, __) => Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: renk.withValues(alpha: 0.09),
                      border: Border.all(
                        color: renk.withValues(
                          alpha: 0.4 + _parlakCtrl.value * 0.4,
                        ),
                        width: 2,
                      ),
                      boxShadow: _acildi
                          ? [
                              BoxShadow(
                                color: renk.withValues(
                                  alpha: 0.2 + _parlakCtrl.value * 0.25,
                                ),
                                blurRadius: 32 + _parlakCtrl.value * 18,
                                spreadRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        widget.kapsul.emoji,
                        style: const TextStyle(fontSize: 64),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  baslik,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: T.metin,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  '🎵 ${sureFmt(widget.kapsul.sureSaniye)}',
                  style: const TextStyle(color: T.metin2, fontSize: 14),
                ),
                const SizedBox(height: 32),
                GeriSayim(
                  acilis: widget.kapsul.acilisTarihi,
                  olusturma: widget.kapsul.olusturmaTarihi,
                  onAcildi: () => setState(() => _acildi = true),
                ),
                const SizedBox(height: 28),
                if (_acildi) ...[
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [renk, renk.withValues(alpha: 0.7)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: renk.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        _oynatToggle();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: Icon(
                        _oynatiliyor
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      label: Text(
                        _oynatiliyor ? l.detPause : l.detPlay,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  // Ses dalga formu simülasyonu
                  SesOynatmaWidget(
                    sureSaniye: widget.kapsul.sureSaniye,
                    renk: renk,
                    oynatiliyor: _oynatiliyor,
                  ),
                ],
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: T.yuzey,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: T.sinir, width: 0.5),
                  ),
                  child: Column(
                    children: [
                      _MetaSatir(
                        l.detCreated,
                        l.tarihFmt(widget.kapsul.olusturmaTarihi),
                      ),
                      _MetaSatir(
                        l.detOpDate,
                        l.tarihFmt(widget.kapsul.acilisTarihi),
                      ),
                      if (alici != null) _MetaSatir(l.detRecip, alici),
                      const Divider(color: T.sinir, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l.detCode,
                            style: const TextStyle(
                              color: T.metin3,
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Clipboard.setData(
                                ClipboardData(text: widget.kapsul.paylasimKodu),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l.detCopied)),
                              );
                            },
                            child: Text(
                              widget.kapsul.paylasimKodu,
                              style: const TextStyle(
                                color: T.altin,
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                                letterSpacing: 5,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Silme butonu
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _silOnay(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.withValues(alpha: 0.7),
                      side: BorderSide(
                        color: Colors.red.withValues(alpha: 0.3),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red.withValues(alpha: 0.7),
                    ),
                    label: Text(
                      _dil == AppDil.en
                          ? 'Delete Capsule'
                          : _dil == AppDil.fa
                          ? 'حذف کپسول'
                          : 'Kapsülü Sil',
                      style: TextStyle(
                        color: Colors.red.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaSatir extends StatelessWidget {
  final String e, d;
  const _MetaSatir(this.e, this.d);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(e, style: const TextStyle(color: T.metin3, fontSize: 13)),
        Text(
          d,
          style: const TextStyle(
            color: T.metin,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// KUTLAMA DİALOG — Confetti parçacık efektli
// ═══════════════════════════════════════════════════════════════════════════

class _Parcacik {
  double x, y, vx, vy, boyut, donsme, donsmeHiz;
  Color renk;
  int sekil; // 0=kare 1=daire 2=dikdörtgen

  _Parcacik(Random r, double genislik)
    : x = r.nextDouble() * genislik,
      y = -r.nextDouble() * 200 - 50,
      vx = (r.nextDouble() - 0.5) * 4,
      vy = r.nextDouble() * 3 + 2,
      boyut = r.nextDouble() * 8 + 4,
      donsme = r.nextDouble() * pi * 2,
      donsmeHiz = (r.nextDouble() - 0.5) * 0.15,
      renk = [
        const Color(0xFFFF6B6B),
        const Color(0xFF4ECDC4),
        const Color(0xFFFFD93D),
        const Color(0xFFC77DFF),
        const Color(0xFF6BCB77),
        const Color(0xFFFF9A3C),
        const Color(0xFF74B9FF),
        const Color(0xFFFF7EB3),
        Colors.white,
      ][r.nextInt(9)],
      sekil = r.nextInt(3);
}

class _ConfettiPainter extends CustomPainter {
  final List<_Parcacik> parcaciklar;
  _ConfettiPainter(this.parcaciklar);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in parcaciklar) {
      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.donsme);
      final paint = Paint()..color = p.renk;
      switch (p.sekil) {
        case 0:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: p.boyut,
              height: p.boyut,
            ),
            paint,
          );
          break;
        case 1:
          canvas.drawCircle(Offset.zero, p.boyut / 2, paint);
          break;
        default:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: p.boyut * 0.5,
              height: p.boyut * 1.5,
            ),
            paint,
          );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter o) => true;
}

class _KutlamaDialog extends StatefulWidget {
  final Kapsul kapsul;
  final String uid;
  final VoidCallback onKapat;
  const _KutlamaDialog({
    required this.kapsul,
    required this.uid,
    required this.onKapat,
  });
  @override
  State<_KutlamaDialog> createState() => _KutlamaDialogState();
}

class _KutlamaDialogState extends State<_KutlamaDialog>
    with TickerProviderStateMixin {
  late AnimationController _confettiCtrl, _scaleCtrl, _pulseCtrl;
  late Animation<double> _scale;
  late List<_Parcacik> _parcaciklar;
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _parcaciklar = List.generate(80, (_) => _Parcacik(_rng, 400));

    _confettiCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..addListener(_fizikGuncelle)
          ..forward();

    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);
    _scaleCtrl.forward();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    HapticFeedback.heavyImpact();
  }

  void _fizikGuncelle() {
    for (final p in _parcaciklar) {
      p.x += p.vx;
      p.y += p.vy;
      p.vy += 0.08; // yerçekimi
      p.donsme += p.donsmeHiz;
      p.vx *= 0.99; // hava direnci
    }
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    _scaleCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baslik = widget.kapsul.baslik(widget.uid);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Confetti katmanı
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _confettiCtrl,
              builder: (_, __) =>
                  CustomPaint(painter: _ConfettiPainter(_parcaciklar)),
            ),
          ),
          // İçerik
          Center(
            child: ScaleTransition(
              scale: _scale,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: T.yuzeyY,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: widget.kapsul.renk.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.kapsul.renk.withValues(alpha: 0.3),
                      blurRadius: 40,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animasyonlu emoji
                    AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (_, __) => Transform.scale(
                        scale: 1.0 + _pulseCtrl.value * 0.15,
                        child: Text(
                          widget.kapsul.emoji,
                          style: const TextStyle(fontSize: 72),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('✨🎊✨', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 16),
                    Text(
                      l.detOpened,
                      style: const TextStyle(
                        color: T.metin,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '"$baslik"',
                      style: TextStyle(
                        color: widget.kapsul.renk,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l.detOpenedDesc(baslik),
                      style: const TextStyle(color: T.metin2, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: widget.onKapat,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.kapsul.renk,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        label: Text(
                          l.detListen,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SES OYNATMA SİMÜLASYONU — Detay ekranında dalga animasyonlu playback
// ═══════════════════════════════════════════════════════════════════════════

class SesOynatmaWidget extends StatefulWidget {
  final int sureSaniye;
  final Color renk;
  final bool oynatiliyor;
  const SesOynatmaWidget({
    super.key,
    required this.sureSaniye,
    required this.renk,
    required this.oynatiliyor,
  });
  @override
  State<SesOynatmaWidget> createState() => _SesOynatmaWidgetState();
}

class _SesOynatmaWidgetState extends State<SesOynatmaWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  double _ilerleme = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void didUpdateWidget(SesOynatmaWidget old) {
    super.didUpdateWidget(old);
    if (widget.oynatiliyor && !old.oynatiliyor) {
      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (!mounted) return;
        setState(() {
          _ilerleme += 0.1 / widget.sureSaniye;
          if (_ilerleme >= 1.0) _ilerleme = 0;
        });
      });
    } else if (!widget.oynatiliyor && old.oynatiliyor) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.oynatiliyor && _ilerleme == 0) return const SizedBox.shrink();
    return Column(
      children: [
        const SizedBox(height: 16),
        // Mini dalga formu
        SizedBox(
          height: 40,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => CustomPaint(
              painter: _MiniDalgaPainter(
                renk: widget.renk,
                ilerleme: _ilerleme,
                animDeger: _ctrl.value,
                aktif: widget.oynatiliyor,
              ),
              size: const Size(double.infinity, 40),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // İlerleme çubuğu
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: _ilerleme,
            minHeight: 4,
            backgroundColor: T.sinir2,
            valueColor: AlwaysStoppedAnimation<Color>(widget.renk),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sureFmt((_ilerleme * widget.sureSaniye).round()),
              style: TextStyle(
                color: widget.renk,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
            Text(
              sureFmt(widget.sureSaniye),
              style: const TextStyle(
                color: T.metin3,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniDalgaPainter extends CustomPainter {
  final Color renk;
  final double ilerleme, animDeger;
  final bool aktif;
  _MiniDalgaPainter({
    required this.renk,
    required this.ilerleme,
    required this.animDeger,
    required this.aktif,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42); // sabit seed = tutarlı dalga
    final cubukSayisi = 50;
    final cubukGenislik = size.width / cubukSayisi - 1;

    for (int i = 0; i < cubukSayisi; i++) {
      final x = i * (cubukGenislik + 1);
      final normalizedI = i / cubukSayisi;
      final oynama = aktif ? sin(animDeger * pi * 2 + i * 0.5) * 0.3 : 0.0;
      final temelYukseklik = rng.nextDouble() * 0.7 + 0.3;
      var h = temelYukseklik * size.height * 0.8;

      if (aktif) h *= (0.7 + oynama);

      // Oynatma imleci efekti
      final alpha = normalizedI <= ilerleme ? 1.0 : 0.3;
      final paint = Paint()..color = renk.withValues(alpha: alpha);

      final top = (size.height - h) / 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, top, cubukGenislik, h),
          const Radius.circular(1.5),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_MiniDalgaPainter o) =>
      o.animDeger != animDeger || o.ilerleme != ilerleme || o.aktif != aktif;
}
