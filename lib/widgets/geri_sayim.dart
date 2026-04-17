import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/l10n.dart';

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
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

    final toplam =
        widget.acilis.difference(widget.olusturma).inSeconds;
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
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: T.altin.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                  color: T.altin.withValues(alpha: 0.06),
                  blurRadius: 24),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_kalan.inDays > 0) ...[
                _FlipBirim(_kalan.inDays, l.cdDays),
                const _Sep(),
              ],
              _FlipBirim(_kalan.inHours.remainder(24), l.cdHours),
              const _Sep(),
              _FlipBirim(_kalan.inMinutes.remainder(60), l.cdMin),
              const _Sep(),
              _FlipBirim(_kalan.inSeconds.remainder(60), l.cdSec),
            ],
          ),
        ),
      ],
    );
  }
}

/// Flip-clock tarzı birim — her değişimde subtle parıltı
class _FlipBirim extends StatefulWidget {
  final int deger;
  final String etiket;
  const _FlipBirim(this.deger, this.etiket);
  @override
  State<_FlipBirim> createState() => _FlipBirimState();
}

class _FlipBirimState extends State<_FlipBirim>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(_FlipBirim old) {
    super.didUpdateWidget(old);
    if (old.deger != widget.deger) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final glow = sin(_ctrl.value * pi) * 0.4;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: glow > 0.05
                    ? [
                        BoxShadow(
                          color: T.altin.withValues(alpha: glow),
                          blurRadius: 12,
                        )
                      ]
                    : null,
              ),
              child: Text(
                widget.deger.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: T.altin,
                  fontFamily: 'monospace',
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: T.altin.withValues(alpha: 0.5 + glow),
                      blurRadius: 12 + glow * 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.etiket,
              style: const TextStyle(
                fontSize: 8,
                color: T.metin3,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Sep extends StatelessWidget {
  const _Sep();
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
