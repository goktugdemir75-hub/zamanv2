import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/kapsul.dart';
import '../services/sifreleme_servisi.dart';
import '../utils/theme.dart';

class KapsulKarti extends StatefulWidget {
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
  State<KapsulKarti> createState() => _KapsulKartiState();
}

class _KapsulKartiState extends State<KapsulKarti>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;
  bool _basili = false;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.kapsul.acilabilirMi && !widget.kapsul.dinlendiMi) {
      _glowCtrl.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final acik = widget.kapsul.acilabilirMi;
    final sifreleme = SifrelemeServisi();
    final baslik =
        sifreleme.coz(widget.kapsul.baslikSifreli, widget.kullaniciId);
    final aliciSifreli = widget.kapsul.aliciSifreli;
    final alici = aliciSifreli != null
        ? sifreleme.coz(aliciSifreli, widget.kullaniciId)
        : null;

    return GestureDetector(
      onTapDown: (_) => setState(() => _basili = true),
      onTapUp: (_) {
        setState(() => _basili = false);
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _basili = false),
      child: AnimatedBuilder(
        animation: _glowCtrl,
        builder: (_, child) {
          final glowAlpha = acik && !widget.kapsul.dinlendiMi
              ? 0.08 + _glowCtrl.value * 0.12
              : 0.0;
          return AnimatedScale(
            scale: _basili ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 120),
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: T.yuzey.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: acik
                      ? widget.kapsul.renk.withValues(alpha: 0.25)
                      : T.sinir.withValues(alpha: 0.6),
                ),
                boxShadow: [
                  if (acik)
                    BoxShadow(
                      color: widget.kapsul.renk
                          .withValues(alpha: 0.12 + glowAlpha),
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
              child: child,
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.kapsul.renk.withValues(alpha: 0.2),
                    widget.kapsul.renk.withValues(alpha: 0.06),
                  ],
                ),
                border: Border.all(
                    color: widget.kapsul.renk.withValues(alpha: 0.2)),
              ),
              child: Center(
                child: Text(widget.kapsul.emoji,
                    style: const TextStyle(fontSize: 28)),
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
                        sureFmt(widget.kapsul.sureSaniye),
                        style: const TextStyle(
                            color: T.metin3, fontSize: 12),
                      ),
                      if (alici != null) ...[
                        const Text('  💌 ',
                            style: TextStyle(fontSize: 11)),
                        Text(
                          alici,
                          style: TextStyle(
                            color: T.ikincil,
                            fontSize: 12,
                            shadows: [
                              Shadow(
                                color:
                                    T.ikincil.withValues(alpha: 0.3),
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
                      horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: acik
                        ? T.basari.withValues(alpha: 0.1)
                        : T.sinir.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: acik
                        ? Border.all(
                            color: T.basari.withValues(alpha: 0.25))
                        : null,
                  ),
                  child: Text(
                    acik ? '🔓' : '🔒',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.kapsul.kalanSureMetni,
                  style: TextStyle(
                    color: acik
                        ? T.basari
                        : T.altin.withValues(alpha: 0.7),
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
