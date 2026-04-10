import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/theme.dart';

class KayitDalgasi extends StatefulWidget {
  final bool aktif, tamamlandi, parazitli;
  final Color renk;
  final Stream<double>? amplitudStream;

  const KayitDalgasi({
    super.key,
    required this.aktif,
    this.tamamlandi = false,
    this.parazitli = false,
    this.renk = T.birincil,
    this.amplitudStream,
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
  double _amplitud = 0.0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();

    widget.amplitudStream?.listen((amp) {
      if (mounted) setState(() => _amplitud = amp);
    });
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
                    ? Colors.white
                        .withValues(alpha: _rng.nextDouble() * 0.8)
                    : widget.renk.withValues(alpha: _rng.nextDouble());
              } else if (widget.tamamlandi) {
                h = 8 + (sin(i * 0.55) + 1) * 9;
                c = T.basari;
              } else if (widget.aktif) {
                // Gerçek amplitüd verisi varsa kullan
                final ampFactor =
                    widget.amplitudStream != null ? _amplitud : 0.5;
                h = 5 +
                    (sin(_ctrl.value * pi * 2 + _faz[i]) * 0.5 + 0.5) *
                        60 *
                        (0.3 + ampFactor * 0.7);
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
