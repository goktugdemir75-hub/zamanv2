import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/kapsul.dart';
import '../services/app_state.dart';
import '../services/sifreleme_servisi.dart';
import '../utils/theme.dart';
import '../utils/l10n.dart';
import '../utils/page_transitions.dart';
import '../widgets/kozmik_bg.dart';
import '../widgets/kapsul_karti.dart';
import 'kapsul_detay_ekran.dart';

class KutuphanEkran extends StatelessWidget {
  const KutuphanEkran({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            l.libTitle,
            style: const TextStyle(
              color: T.metin,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          bottom: TabBar(
            indicatorColor: T.birincil,
            indicatorWeight: 2.5,
            labelColor: T.metin,
            unselectedLabelColor: T.metin3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            dividerColor: Colors.transparent,
            onTap: (_) => HapticFeedback.selectionClick(),
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
                return ListenableBuilder(
                  listenable: state,
                  builder: (_, __) {
                    final uid = state.kullanici?.id ?? '';
                    return TabBarView(
                      children: [
                        _KapsulListesi(
                          kapsullar: state.kilitliler,
                          uid: uid,
                          bosIkon: '🔓',
                          bosBaslik: l.libNoLock,
                          bosAciklama: l.libNoLockS,
                        ),
                        _KapsulListesi(
                          kapsullar: state.aciklar,
                          uid: uid,
                          bosIkon: '📭',
                          bosBaslik: l.libNoOpen,
                          bosAciklama: l.libNoOpenS,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Kapsül listesi ──────────────────────────────────────────

class _KapsulListesi extends StatelessWidget {
  final List<Kapsul> kapsullar;
  final String uid;
  final String bosIkon, bosBaslik, bosAciklama;

  const _KapsulListesi({
    required this.kapsullar,
    required this.uid,
    required this.bosIkon,
    required this.bosBaslik,
    required this.bosAciklama,
  });

  @override
  Widget build(BuildContext context) {
    if (kapsullar.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(bosIkon, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              bosBaslik,
              style: const TextStyle(
                color: T.metin,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                bosAciklama,
                style: const TextStyle(color: T.metin2, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: kapsullar.length,
      itemBuilder: (ctx, i) {
        final k = kapsullar[i];
        return _StaggeredItem(
          index: i,
          child: KapsulKarti(
            kapsul: k,
            kullaniciId: uid,
            onTap: () {
              if (k.acilabilirMi) {
                Navigator.push(
                  ctx,
                  FadeSlideRoute(page: KapsulDetayEkran(kapsul: k)),
                );
              } else {
                _parazitDialog(ctx, k);
              }
            },
          ),
        );
      },
    );
  }

  void _parazitDialog(BuildContext ctx, Kapsul k) {
    HapticFeedback.mediumImpact();
    final sifreleme = SifrelemeServisi();
    final baslik = sifreleme.coz(k.baslikSifreli, uid);

    final toplam = k.acilisTarihi.difference(k.olusturmaTarihi).inSeconds;
    final gecen = DateTime.now().difference(k.olusturmaTarihi).inSeconds;
    final yuzde =
        toplam > 0 ? ((gecen / toplam) * 100).clamp(0, 100).toInt() : 0;

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: T.yuzeyY,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            Text(k.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                baslik,
                style: const TextStyle(
                  color: T.metin,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Parazit visualizer
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: T.sinir),
              ),
              child: CustomPaint(
                painter: _ParazitPainter(renk: k.renk),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: T.altin.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: T.altin.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Text('📡', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l.parazitSignal,
                      style: const TextStyle(
                        color: T.altin,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l.libProgress('$yuzde'),
                  style: const TextStyle(color: T.metin2, fontSize: 12),
                ),
                Text(
                  k.kalanSureMetni,
                  style: TextStyle(
                    color: T.altin.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: yuzde / 100,
                minHeight: 6,
                backgroundColor: T.sinir2,
                valueColor: AlwaysStoppedAnimation<Color>(k.renk),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l.delCancel,
              style: const TextStyle(color: T.metin3),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Staggered animation ─────────────────────────────────────

class _StaggeredItem extends StatefulWidget {
  final int index;
  final Widget child;
  const _StaggeredItem({required this.index, required this.child});
  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.child),
      );
}

// ─── Parazit (noise) painter ─────────────────────────────────

class _ParazitPainter extends CustomPainter {
  final Color renk;
  final _rng = Random();

  _ParazitPainter({required this.renk});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Random noise lines
    for (var i = 0; i < 3; i++) {
      final path = Path();
      final alpha = 0.2 + _rng.nextDouble() * 0.3;
      paint.color = renk.withValues(alpha: alpha);

      path.moveTo(0, size.height / 2);
      for (var x = 0.0; x < size.width; x += 3) {
        final y = size.height / 2 +
            (_rng.nextDouble() - 0.5) * size.height * 0.7;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }

    // Static dots
    for (var i = 0; i < 40; i++) {
      final x = _rng.nextDouble() * size.width;
      final y = _rng.nextDouble() * size.height;
      final r = 0.5 + _rng.nextDouble() * 1.5;
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()..color = renk.withValues(alpha: 0.15 + _rng.nextDouble() * 0.2),
      );
    }
  }

  @override
  bool shouldRepaint(_ParazitPainter old) => true;
}
