import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/theme.dart';

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
    _yildizlar = List.generate(30, (_) => _Yildiz(r));
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.4),
                radius: 1.6,
                colors: [
                  Color(0xFF0D0520),
                  Color(0xFF060312),
                  Color(0xFF010108),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => CustomPaint(
              painter: _YildizPainter(_yildizlar, _ctrl.value),
              size: Size.infinite,
            ),
          ),
          Positioned(
            top: -120,
            left: -100,
            child: _Hale(
                renk: const Color(0xFF6B1FA8), boyut: 350, opacity: 0.06),
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
  const _Hale(
      {required this.renk, required this.boyut, this.opacity = 0.06});
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
