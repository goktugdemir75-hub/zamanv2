enum AppDil { tr, en, fa }

class DilNotifier {
  static final DilNotifier _instance = DilNotifier._();
  factory DilNotifier() => _instance;
  DilNotifier._();

  AppDil _dil = AppDil.tr;
  final List<void Function(AppDil)> _listeners = [];

  AppDil get value => _dil;

  void degistir(AppDil dil) {
    _dil = dil;
    for (final fn in _listeners) {
      fn(dil);
    }
  }

  void addListener(void Function(AppDil) fn) => _listeners.add(fn);
  void removeListener(void Function(AppDil) fn) => _listeners.remove(fn);
}

final dilNotifier = DilNotifier();

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
  String get loginLoading => _t('Giriş yapılıyor...', 'Signing in...', 'ورود...');
  String get loginError => _t(
    'Giriş başarısız. Tekrar dene.',
    'Sign in failed. Try again.',
    'ورود ناموفق. دوباره تلاش کن.',
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
  String get recMicPermission => _t(
    'Mikrofon izni gerekli',
    'Microphone permission required',
    'دسترسی میکروفون لازم است',
  );
  String get recMicDenied => _t(
    'Mikrofon izni reddedildi. Ayarlardan izin verin.',
    'Microphone permission denied. Enable it in settings.',
    'دسترسی میکروفون رد شد. از تنظیمات فعال کنید.',
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
  String get wizEmoji =>
      _t('Emoji seç', 'Choose an emoji', 'ایموجی انتخاب کن');
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
  String get profLogout => _t('Çıkış Yap', 'Sign Out', 'خروج');
  String get profLang => _t(
    'Dil / Language / زبان',
    'Dil / Language / زبان',
    'Dil / Language / زبان',
  );

  // Silme
  String get delTitle => _t(
    'Bu kapsülü silmek istediğine emin misin?',
    'Delete this capsule?',
    'این کپسول حذف شود؟',
  );
  String get delDesc => _t(
    'Bu işlem geri alınamaz.',
    'This action cannot be undone.',
    'این عمل قابل بازگشت نیست.',
  );
  String get delBtn => _t('Sil', 'Delete', 'حذف');
  String get delCancel => _t('İptal', 'Cancel', 'انصراف');
  String get delCapsule => _t('Kapsülü Sil', 'Delete Capsule', 'حذف کپسول');

  // Parazit
  String get parazitSignal => _t(
    'Sinyal zayıf — tam ses için açılış tarihini bekle.',
    'Weak signal — wait for the unlock date for full audio.',
    'سیگنال ضعیف — برای صدای کامل منتظر تاریخ باز شدن باش.',
  );

  // Önayar tarihler
  String get p1m => _t('1 Ay', '1 Month', '۱ ماه');
  String get p3m => _t('3 Ay', '3 Months', '۳ ماه');
  String get p6m => _t('6 Ay', '6 Months', '۶ ماه');
  String get p1y => _t('1 Yıl', '1 Year', '۱ سال');
  String get p5y => _t('5 Yıl', '5 Years', '۵ سال');
  String get p10y => _t('10 Yıl', '10 Years', '۱۰ سال');

  // Genel
  String get loading => _t('Yükleniyor...', 'Loading...', 'بارگذاری...');
  String get error => _t('Bir hata oluştu', 'An error occurred', 'خطایی رخ داد');
  String get retry => _t('Tekrar Dene', 'Retry', 'تلاش مجدد');

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

  String tarihFmt(DateTime d) {
    switch (_dil) {
      case AppDil.fa:
        const ay = [
          '', 'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور',
          'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند',
        ];
        return '${d.day} ${ay[d.month]} ${d.year}';
      case AppDil.en:
        const ay = [
          '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
        ];
        return '${ay[d.month]} ${d.day}, ${d.year}';
      default:
        const ay = [
          '', 'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
          'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
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

L get l => L(dilNotifier.value);

const destekliDiller = [
  {'code': AppDil.tr, 'isim': 'Türkçe', 'flag': '🇹🇷'},
  {'code': AppDil.en, 'isim': 'English', 'flag': '🇬🇧'},
  {'code': AppDil.fa, 'isim': 'فارسی', 'flag': '🇮🇷'},
];
