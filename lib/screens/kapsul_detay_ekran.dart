import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/kapsul.dart';
import '../services/app_state.dart';
import '../services/ses_servisi.dart';
import '../services/sifreleme_servisi.dart';
import '../utils/theme.dart';
import '../utils/l10n.dart';
import '../widgets/geri_sayim.dart';
import '../widgets/kozmik_bg.dart';

class KapsulDetayEkran extends StatefulWidget {
  final Kapsul kapsul;
  const KapsulDetayEkran({super.key, required this.kapsul});
  @override
  State<KapsulDetayEkran> createState() => _KapsulDetayEkranState();
}

class _KapsulDetayEkranState extends State<KapsulDetayEkran>
    with TickerProviderStateMixin {
  final SesServisi _ses = SesServisi();
  final SifrelemeServisi _sifreleme = SifrelemeServisi();

  bool _caliniyor = false;
  bool _konfettiGosterildi = false;
  late AnimationController _konfettiCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;
  Duration _pozisyon = Duration.zero;
  Duration _sure = Duration.zero;

  @override
  void initState() {
    super.initState();
    _konfettiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulse = Tween(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _ses.oynatmaPozisyonu.listen((p) {
      if (mounted) setState(() => _pozisyon = p);
    });
    _ses.oynatmaSuresi.listen((d) {
      if (mounted && d != null) setState(() => _sure = d);
    });
    _ses.oynatmaDurumu.listen((state) {
      if (mounted) {
        setState(() {
          _caliniyor = state.toString().contains('playing');
        });
      }
    });

    if (widget.kapsul.acilabilirMi && !_konfettiGosterildi) {
      _konfettiGosterildi = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _konfettiCtrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _konfettiCtrl.dispose();
    _pulseCtrl.dispose();
    _ses.durdur();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final uid = state.kullanici?.id ?? '';
    final acik = widget.kapsul.acilabilirMi;
    final baslik = _sifreleme.coz(widget.kapsul.baslikSifreli, uid);
    final aliciSifreli = widget.kapsul.aliciSifreli;
    final alici =
        aliciSifreli != null ? _sifreleme.coz(aliciSifreli, uid) : null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: T.metin2),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (acik)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: T.birincil),
              onPressed: () => _silOnay(context, state),
            ),
        ],
      ),
      body: KozmikBg(
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Emoji büyük
                    AnimatedBuilder(
                      animation: _pulse,
                      builder: (_, __) => Transform.scale(
                        scale: _pulse.value,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                widget.kapsul.renk.withValues(alpha: 0.25),
                                widget.kapsul.renk.withValues(alpha: 0.03),
                              ],
                            ),
                            border: Border.all(
                              color:
                                  widget.kapsul.renk.withValues(alpha: 0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.kapsul.renk
                                    .withValues(alpha: 0.2),
                                blurRadius: 30,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(widget.kapsul.emoji,
                                style: const TextStyle(fontSize: 48)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Başlık
                    Text(
                      baslik,
                      style: const TextStyle(
                        color: T.metin,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    if (!acik) ...[
                      // Kilitli — geri sayım
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: T.yuzey.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                              color: T.altin.withValues(alpha: 0.15)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              l.detLocked,
                              style: const TextStyle(
                                color: T.metin2,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            GeriSayim(
                              acilis: widget.kapsul.acilisTarihi,
                              olusturma: widget.kapsul.olusturmaTarihi,
                              onAcildi: () {
                                if (mounted) setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Açık — kutlama + oynatma
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: T.yuzey.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                              color: T.basari.withValues(alpha: 0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: T.basari.withValues(alpha: 0.08),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              l.detOpened,
                              style: const TextStyle(
                                color: T.basari,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l.detOpenedDesc(baslik),
                              style: const TextStyle(
                                  color: T.metin2, fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            // Waveform / progress
                            _OynatmaWidget(
                              caliniyor: _caliniyor,
                              pozisyon: _pozisyon,
                              sure: _sure,
                              renk: widget.kapsul.renk,
                            ),
                            const SizedBox(height: 20),

                            // Oynat butonu
                            GestureDetector(
                              onTap: () => _oynatToggle(uid),
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      widget.kapsul.renk,
                                      widget.kapsul.renk
                                          .withValues(alpha: 0.7),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.kapsul.renk
                                          .withValues(alpha: 0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _caliniyor
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _caliniyor ? l.detPause : l.detPlay,
                              style: const TextStyle(
                                color: T.metin2,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),

                    // Detay bilgileri
                    _DetayBilgi(
                      ikon: '📅',
                      etiket: l.detCreated,
                      deger: l.tarihFmt(widget.kapsul.olusturmaTarihi),
                    ),
                    _DetayBilgi(
                      ikon: acik ? '🔓' : '🔒',
                      etiket: l.detOpDate,
                      deger: l.tarihFmt(widget.kapsul.acilisTarihi),
                    ),
                    _DetayBilgi(
                      ikon: '🎵',
                      etiket: l.wizDur,
                      deger: sureFmt(widget.kapsul.sureSaniye),
                    ),
                    if (alici != null)
                      _DetayBilgi(
                        ikon: '💌',
                        etiket: l.detRecip,
                        deger: alici,
                      ),
                    const SizedBox(height: 12),

                    // Paylaşım kodu
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.kapsul.paylasimKodu));
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l.detCopied),
                            backgroundColor: T.yuzeyY,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: T.yuzey.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: T.sinir.withValues(alpha: 0.6)),
                        ),
                        child: Row(
                          children: [
                            const Text('🔑', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.detCode,
                                  style: const TextStyle(
                                    color: T.metin3,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.kapsul.paylasimKodu,
                                  style: TextStyle(
                                    color: T.altin,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 3,
                                    fontFamily: 'monospace',
                                    shadows: [
                                      Shadow(
                                        color:
                                            T.altin.withValues(alpha: 0.4),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Icon(
                              Icons.copy_rounded,
                              color: T.metin3.withValues(alpha: 0.5),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sil butonu (açık ise)
                    if (acik) ...[
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _silOnay(context, state),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: T.birincil,
                            side: BorderSide(
                                color: T.birincil.withValues(alpha: 0.3)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.delete_outline_rounded,
                              size: 18),
                          label: Text(l.delCapsule),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ],
                ),
              ),
            ),

            // Konfetti overlay
            if (acik)
              IgnorePointer(
                child: AnimatedBuilder(
                  animation: _konfettiCtrl,
                  builder: (_, __) {
                    if (_konfettiCtrl.value == 0) {
                      return const SizedBox.shrink();
                    }
                    return CustomPaint(
                      size: MediaQuery.of(context).size,
                      painter: _KonfettiPainter(
                        ilerleme: _konfettiCtrl.value,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _oynatToggle(String uid) async {
    HapticFeedback.lightImpact();
    if (_caliniyor) {
      await _ses.duraklat();
    } else {
      final dosya = widget.kapsul.sesDosyaYolu;
      if (dosya != null) {
        // Mark as listened
        final state = AppStateProvider.of(context);
        if (!widget.kapsul.dinlendiMi) {
          state.kapsulAcildiIsaretle(widget.kapsul.id);
        }
        await _ses.oynat(dosya, kullaniciId: uid);
      }
    }
  }

  void _silOnay(BuildContext ctx, AppState state) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: T.yuzeyY,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          l.delTitle,
          style: const TextStyle(
            color: T.metin,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        content: Text(
          l.delDesc,
          style: const TextStyle(color: T.metin2, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l.delCancel,
              style: const TextStyle(color: T.metin3),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await state.kapsulSil(widget.kapsul.id);
              if (mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: T.birincil,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l.delBtn,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Oynatma progress widget ─────────────────────────────────

class _OynatmaWidget extends StatelessWidget {
  final bool caliniyor;
  final Duration pozisyon, sure;
  final Color renk;

  const _OynatmaWidget({
    required this.caliniyor,
    required this.pozisyon,
    required this.sure,
    required this.renk,
  });

  @override
  Widget build(BuildContext context) {
    final toplam = sure.inMilliseconds;
    final gecen = pozisyon.inMilliseconds;
    final ilerleme = toplam > 0 ? (gecen / toplam).clamp(0.0, 1.0) : 0.0;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ilerleme,
            minHeight: 6,
            backgroundColor: T.sinir2,
            valueColor: AlwaysStoppedAnimation<Color>(renk),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _sureFmt(pozisyon),
              style: const TextStyle(color: T.metin3, fontSize: 11),
            ),
            Text(
              _sureFmt(sure),
              style: const TextStyle(color: T.metin3, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  String _sureFmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

// ─── Detay bilgi satırı ──────────────────────────────────────

class _DetayBilgi extends StatelessWidget {
  final String ikon, etiket, deger;
  const _DetayBilgi({
    required this.ikon,
    required this.etiket,
    required this.deger,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: T.yuzey.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: T.sinir.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Text(ikon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              etiket,
              style: const TextStyle(
                color: T.metin3,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            deger,
            style: const TextStyle(
              color: T.metin,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Konfetti boyacı ─────────────────────────────────────────

class _KonfettiPainter extends CustomPainter {
  final double ilerleme;
  final _rng = Random(42);

  _KonfettiPainter({required this.ilerleme});

  @override
  void paint(Canvas canvas, Size size) {
    const renkler = [
      T.birincil, T.basari, T.altin, T.mor, T.mavi, T.ikincil,
    ];

    for (var i = 0; i < 80; i++) {
      final x = _rng.nextDouble() * size.width;
      final startY = -20.0 - _rng.nextDouble() * 100;
      final endY = size.height + 50;
      final y = startY + (endY - startY) * ilerleme;
      final boyut = 3.0 + _rng.nextDouble() * 6;
      final renk = renkler[i % renkler.length];
      final alpha = (1.0 - ilerleme).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = renk.withValues(alpha: alpha * 0.8)
        ..style = PaintingStyle.fill;

      final wobble = sin(ilerleme * pi * 4 + i) * 15;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x + wobble, y),
            width: boyut,
            height: boyut * 1.5,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_KonfettiPainter old) => old.ilerleme != ilerleme;
}
