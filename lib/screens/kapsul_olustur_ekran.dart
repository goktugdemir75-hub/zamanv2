import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/app_state.dart';
import '../services/ses_servisi.dart';
import '../services/sifreleme_servisi.dart';
import '../models/kapsul.dart';
import '../utils/theme.dart';
import '../utils/l10n.dart';
import '../widgets/kozmik_bg.dart';
import '../widgets/kayit_dalgasi.dart';
import 'ana_kabuk.dart';

class KapsulOlusturEkran extends StatefulWidget {
  final int oncekiSure;
  final VoidCallback? onTamamlandi;

  const KapsulOlusturEkran({
    super.key,
    this.oncekiSure = 0,
    this.onTamamlandi,
  });

  @override
  State<KapsulOlusturEkran> createState() => _KapsulOlusturEkranState();
}

class _KapsulOlusturEkranState extends State<KapsulOlusturEkran> {
  final _ses = SesServisi();
  final _sifreleme = SifrelemeServisi();

  late int _adim;
  bool _kayitYapiyorMu = false;
  bool _tamamlandi = false;
  bool _oynatiliyor = false;
  bool _enAzBirKezDinlendi = false;
  late int _sure;
  Timer? _kayitTimer;
  bool _yukleniyor = false;
  String? _kayitYolu;

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

  Future<void> _kaydiBaslat() async {
    final basarili = await _ses.kayitBaslat();
    if (!basarili) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.recMicDenied), backgroundColor: T.birincil),
      );
      return;
    }

    setState(() {
      _kayitYapiyorMu = true;
      _sure = 0;
      _tamamlandi = false;
      _enAzBirKezDinlendi = false;
    });
    _kayitTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _sure++);
      if (_sure >= 120) _kaydiDurdur();
    });
  }

  Future<void> _kaydiDurdur() async {
    _kayitTimer?.cancel();
    _kayitYolu = await _ses.kayitDurdur();
    if (!mounted) return;
    setState(() {
      _kayitYapiyorMu = false;
      _tamamlandi = true;
    });
  }

  void _oynatToggle() {
    if (_oynatiliyor) {
      _ses.kaydiDuraklat();
    } else {
      _ses.kaydiOynat();
      _enAzBirKezDinlendi = true;
    }
    setState(() => _oynatiliyor = !_oynatiliyor);
  }

  void _sifirla() {
    _kayitTimer?.cancel();
    _ses.durdur();
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
    if (_adim < 3) {
      setState(() => _adim++);
    } else {
      _olustur();
    }
  }

  Future<void> _olustur() async {
    HapticFeedback.heavyImpact();
    setState(() => _yukleniyor = true);

    try {
      final state = AppStateProvider.of(context);
      final uid = state.kullanici!.id;

      // Ses dosyasını şifrele
      String? sifreliYol;
      if (_kayitYolu != null) {
        sifreliYol = await _ses.kaydiSifreleVeKaydet(uid);
      }

      final baslikSifreli =
          _sifreleme.sifrele(_baslikCtrl.text.trim(), uid);
      final aliciSifreli =
          _alici.isNotEmpty ? _sifreleme.sifrele(_alici, uid) : null;

      final kapsul = Kapsul(
        id: '',
        baslikSifreli: baslikSifreli,
        sureSaniye: _sure,
        olusturmaTarihi: DateTime.now(),
        acilisTarihi: _acilis,
        aliciSifreli: aliciSifreli,
        renkDegeri: _renk.value,
        emoji: _emoji,
        paylasimKodu: Kapsul.kodUret(),
        sahipId: uid,
        sesDosyaYolu: sifreliYol,
      );

      await state.kapsulEkle(kapsul);

      if (!mounted) return;

      // Başarı dialogu
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: T.yuzeyY,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
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
                l.sealDesc(
                    _baslikCtrl.text.trim(), l.tarihFmt(_acilis)),
                style:
                    const TextStyle(color: T.metin2, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: T.sinir,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${l.sealCode} ',
                        style: const TextStyle(fontSize: 16)),
                    Text(
                      kapsul.paylasimKodu,
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AnaKabuk()),
                    (r) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: T.birincil),
              child: Text(l.sealBtn,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.error), backgroundColor: T.birincil),
      );
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  @override
  void dispose() {
    _kayitTimer?.cancel();
    _baslikCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adimBasliklari = [
      l.wizRecord,
      l.wizDetails,
      l.wizDate,
      l.wizSummary
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => _adim > 0
              ? setState(() => _adim--)
              : Navigator.pop(context),
        ),
        title: Text(adimBasliklari[_adim]),
      ),
      body: KozmikBg(
        child: SafeArea(
          child: Column(
            children: [
              // İlerleme çubuğu
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

              // İçerik
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: [
                    _adim0(),
                    _adim1(),
                    _adim2(),
                    _adim3()
                  ][_adim],
                ),
              ),

              // Buton
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_adim == 0 &&
                        _tamamlandi &&
                        !_enAzBirKezDinlendi)
                      _dinlemeUyarisi(),
                    if (_yukleniyor)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                              color: T.birincil),
                        ),
                      )
                    else
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
                                    color: (_adim < 3
                                            ? T.birincil
                                            : T.altin)
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
                                  padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  _adim < 3 ? l.wizCont : l.wizSeal,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: T.sinir,
                                padding:
                                    const EdgeInsets.symmetric(
                                        vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                _adim < 3 ? l.wizCont : l.wizSeal,
                                style: const TextStyle(
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

  Widget _dinlemeUyarisi() => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: T.altin.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: T.altin.withValues(alpha: 0.25)),
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
      );

  // ─── Adım 0: Kayıt ──────────────────────────────────────────

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
          const SizedBox(height: 28),
          KayitDalgasi(
            aktif: _kayitYapiyorMu,
            tamamlandi: _tamamlandi,
            amplitudStream: _ses.amplitudStream,
          ),
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
            _KayitButonu(
              aktif: _kayitYapiyorMu,
              onTap: () {
                HapticFeedback.mediumImpact();
                _kayitYapiyorMu ? _kaydiDurdur() : _kaydiBaslat();
              },
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _KBtn(
                  icon:
                      _oynatiliyor ? Icons.pause : Icons.play_arrow,
                  label: _oynatiliyor
                      ? l.recStop
                      : (_enAzBirKezDinlendi
                          ? l.recListened
                          : l.recListen),
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

  // ─── Adım 1: Detaylar ────────────────────────────────────────

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
          Text(l.wizColor,
              style: const TextStyle(
                  color: T.metin2,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: T.renkler
                  .map((r) => GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _renk = r);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: r,
                            shape: BoxShape.circle,
                            border: _renk == r
                                ? Border.all(
                                    color: Colors.white, width: 3)
                                : null,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          Text(l.wizEmoji,
              style: const TextStyle(
                  color: T.metin2,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: T.emojiler
                .map((e) => GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _emoji = e);
                      },
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
                            color:
                                _emoji == e ? T.birincil : T.sinir,
                          ),
                        ),
                        child: Center(
                          child: Text(e,
                              style:
                                  const TextStyle(fontSize: 24)),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      );

  // ─── Adım 2: Tarih ───────────────────────────────────────────

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
            children: [
              {'e': l.p1m, 'g': 30},
              {'e': l.p3m, 'g': 90},
              {'e': l.p6m, 'g': 180},
              {'e': l.p1y, 'g': 365},
              {'e': l.p5y, 'g': 1825},
              {'e': l.p10y, 'g': 3650},
            ]
                .map((o) => OutlinedButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        setState(() => _acilis = DateTime.now()
                            .add(Duration(days: o['g'] as int)));
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: T.metin,
                        side: const BorderSide(color: T.sinir2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(o['e'] as String),
                    ))
                .toList(),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () async {
              final t = await showDatePicker(
                context: context,
                initialDate: _acilis,
                firstDate:
                    DateTime.now().add(const Duration(days: 1)),
                lastDate: DateTime(2050),
                builder: (ctx, child) => Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                        primary: T.birincil),
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
                  const Icon(Icons.calendar_month,
                      color: T.birincil, size: 20),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.wizCustom,
                          style: const TextStyle(
                              color: T.metin2, fontSize: 12)),
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
          Text(l.wizRecip,
              style: const TextStyle(
                  color: T.metin2,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          TextField(
            onChanged: (v) => _alici = v,
            style: const TextStyle(color: T.metin),
            decoration: InputDecoration(hintText: l.wizRecipH),
          ),
        ],
      );

  // ─── Adım 3: Özet ────────────────────────────────────────────

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
                BoxShadow(
                    color: _renk.withValues(alpha: 0.18),
                    blurRadius: 22),
              ],
            ),
            child: Column(
              children: [
                Text(_emoji, style: const TextStyle(fontSize: 60)),
                const SizedBox(height: 12),
                Text(
                  _baslikCtrl.text.isEmpty
                      ? l.appName
                      : _baslikCtrl.text,
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
                _OzetSatir(
                    '📅', l.wizOpen, l.tarihFmt(_acilis)),
                if (_alici.isNotEmpty)
                  _OzetSatir('💌', l.wizRecipL, _alici),
              ],
            ),
          ),
        ],
      );
}

// ─── Yardımcı widget'lar ──────────────────────────────────────

class _KayitButonu extends StatefulWidget {
  final bool aktif;
  final VoidCallback onTap;
  const _KayitButonu({required this.aktif, required this.onTap});
  @override
  State<_KayitButonu> createState() => _KayitButonuState();
}

class _KayitButonuState extends State<_KayitButonu>
    with SingleTickerProviderStateMixin {
  late AnimationController _neonCtrl;

  @override
  void initState() {
    super.initState();
    _neonCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _neonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _neonCtrl,
      builder: (_, __) {
        final glow = widget.aktif ? 0.25 + _neonCtrl.value * 0.35 : 0.0;
        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.aktif
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
                    colors: widget.aktif
                        ? [
                            T.birincil,
                            T.birincil.withValues(alpha: 0.7)
                          ]
                        : [
                            T.mor.withValues(alpha: 0.25),
                            T.birincil.withValues(alpha: 0.15)
                          ],
                  ),
                  border: Border.all(
                    color: widget.aktif
                        ? T.birincil
                        : T.mor.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.aktif ? T.birincil : T.mor)
                          .withValues(alpha: 0.35 + glow),
                      blurRadius:
                          (widget.aktif ? 28 : 16) + glow * 20,
                      spreadRadius: widget.aktif ? 2 : 0,
                    ),
                  ],
                ),
                child: Icon(
                  widget.aktif
                      ? Icons.stop_rounded
                      : Icons.mic_none_rounded,
                  size: 42,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
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
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                renk.withValues(alpha: 0.2),
                renk.withValues(alpha: 0.08)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: renk.withValues(alpha: 0.4)),
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
            Text('$etiket  ',
                style:
                    const TextStyle(color: T.metin3, fontSize: 13)),
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
