import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/app_state.dart';
import '../utils/theme.dart';
import '../utils/l10n.dart';
import '../widgets/kozmik_bg.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});
  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani>
    with TickerProviderStateMixin {
  bool _emailModu = false;
  final _emailCtrl = TextEditingController();
  final _sifreCtrl = TextEditingController();
  late AnimationController _pulseCtrl;
  late AnimationController _shimmerCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulse = Tween(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _shimmerCtrl.dispose();
    _emailCtrl.dispose();
    _sifreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    return Scaffold(
      body: KozmikBg(
        child: SafeArea(
          child: ListenableBuilder(
            listenable: state,
            builder: (_, __) => SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 48),

                  // Logo — pulsating efekt
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, __) => Transform.scale(
                      scale: _pulse.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              T.mor.withValues(alpha: 0.35),
                              T.bg,
                            ],
                          ),
                          border: Border.all(
                            color: T.mor.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: T.mor.withValues(alpha: 0.3),
                              blurRadius: 30 + _pulse.value * 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child:
                              Text('🎵', style: TextStyle(fontSize: 56)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    l.appName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: T.metin,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.tagline,
                    style:
                        const TextStyle(color: T.metin2, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Hata mesajı
                  if (state.hata != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: T.birincil.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: T.birincil.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: T.birincil, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l.loginError,
                              style: const TextStyle(
                                  color: T.birincil, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (!_emailModu) ...[
                    // Glassmorphism kart
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color:
                                  Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Column(
                            children: [
                              _GlowButton(
                                onTap: state.yukleniyor
                                    ? null
                                    : () => _googleGiris(state),
                                icon: '🔵',
                                label: l.loginGoogle,
                                renk: const Color(0xFF4285F4),
                                shimmerCtrl: _shimmerCtrl,
                              ),
                              const SizedBox(height: 12),
                              _GlowButton(
                                onTap: state.yukleniyor
                                    ? null
                                    : () => _appleGiris(state),
                                icon: '🍎',
                                label: l.loginApple,
                                renk: Colors.white,
                                shimmerCtrl: _shimmerCtrl,
                              ),
                              const SizedBox(height: 12),
                              _GlowButton(
                                onTap: state.yukleniyor
                                    ? null
                                    : () =>
                                        setState(() => _emailModu = true),
                                icon: '✉️',
                                label: l.loginEmail,
                                renk: T.mor,
                                shimmerCtrl: _shimmerCtrl,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Email giriş formu
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color:
                                  Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: _emailCtrl,
                                keyboardType:
                                    TextInputType.emailAddress,
                                style:
                                    const TextStyle(color: T.metin),
                                decoration: InputDecoration(
                                  hintText: l.loginEmailHint,
                                  prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: T.metin3),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _sifreCtrl,
                                obscureText: true,
                                style:
                                    const TextStyle(color: T.metin),
                                decoration: InputDecoration(
                                  hintText: l.loginPassHint,
                                  prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: T.metin3),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                    gradient: T.gradBirincil,
                                    boxShadow: [
                                      BoxShadow(
                                        color: T.birincil
                                            .withValues(alpha: 0.4),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: state.yukleniyor
                                        ? null
                                        : () =>
                                            _emailGiris(state),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.transparent,
                                      shadowColor:
                                          Colors.transparent,
                                      padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      l.loginButton,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () =>
                                    setState(() => _emailModu = false),
                                child: Text(
                                  l.loginBack,
                                  style: const TextStyle(
                                      color: T.metin3, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Loading
                  if (state.yukleniyor) ...[
                    const SizedBox(height: 8),
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: T.birincil,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(l.loginLoading,
                        style:
                            const TextStyle(color: T.metin3, fontSize: 12)),
                  ],

                  const SizedBox(height: 24),

                  // Güvenlik badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: T.basari.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: T.basari.withValues(alpha: 0.15)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔐', style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            l.secBadge,
                            style: TextStyle(
                              color: T.basari.withValues(alpha: 0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }

  Future<void> _googleGiris(AppState state) async {
    HapticFeedback.lightImpact();
    await state.googleIleGiris();
  }

  Future<void> _appleGiris(AppState state) async {
    HapticFeedback.lightImpact();
    await state.appleIleGiris();
  }

  Future<void> _emailGiris(AppState state) async {
    HapticFeedback.lightImpact();
    final email = _emailCtrl.text.trim();
    final sifre = _sifreCtrl.text.trim();
    if (email.isEmpty || sifre.isEmpty) return;
    await state.emailIleGiris(email, sifre);
  }
}

/// Shimmer/glow efektli buton
class _GlowButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String icon, label;
  final Color renk;
  final AnimationController shimmerCtrl;

  const _GlowButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.renk,
    required this.shimmerCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shimmerCtrl,
      builder: (_, __) {
        final shimmerPos = shimmerCtrl.value * 2 - 0.5;
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: T.yuzey.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: renk.withValues(alpha: 0.15)),
              gradient: LinearGradient(
                begin: Alignment(shimmerPos - 0.3, 0),
                end: Alignment(shimmerPos + 0.3, 0),
                colors: [
                  T.yuzey.withValues(alpha: 0.7),
                  renk.withValues(alpha: 0.08),
                  T.yuzey.withValues(alpha: 0.7),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: renk.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(icon, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: T.metin,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
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
