import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/app_state.dart';
import '../utils/theme.dart';
import '../utils/l10n.dart';
import '../utils/page_transitions.dart';
import '../widgets/kozmik_bg.dart';
import '../widgets/kapsul_karti.dart';
import 'kapsul_olustur_ekran.dart';
import 'kapsul_detay_ekran.dart';

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
                  Shadow(
                      color: T.altin.withValues(alpha: 0.5),
                      blurRadius: 8),
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
                icon: const Icon(Icons.person_outline_rounded,
                    color: T.metin2),
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
              return ListenableBuilder(
                listenable: state,
                builder: (_, __) {
                  final liste = state.kapsullar;
                  final uid = state.kullanici?.id ?? '';
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                          child: _HeroKart(state: state)),
                      SliverToBoxAdapter(
                          child: _IstatistikSerit(state: state)),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                                const Text('🎵',
                                    style: TextStyle(fontSize: 64)),
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
                                  style: const TextStyle(
                                      color: T.metin2),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding:
                              const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (ctx, i) {
                                return _StaggeredItem(
                                  index: i,
                                  child: KapsulKarti(
                                    kapsul: liste[i],
                                    kullaniciId: uid,
                                    onTap: () => Navigator.push(
                                      ctx,
                                      FadeSlideRoute(
                                        page: KapsulDetayEkran(
                                            kapsul: liste[i]),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: liste.length,
                            ),
                          ),
                        ),
                    ],
                  );
                },
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
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              FadeSlideRoute(page: const KapsulOlusturEkran()),
            );
          },
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
      builder: (_) => _ProfilSheet(state: state),
    );
  }
}

// ─── Staggered animation wrapper ───────────────────────────────

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

// ─── Profil bottom sheet ─────────────────────────────────────

class _ProfilSheet extends StatelessWidget {
  final AppState state;
  const _ProfilSheet({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              // Gradient border avatar
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: T.gradMor,
                ),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: T.yuzeyY,
                    image: state.kullanici?.fotograf != null
                        ? DecorationImage(
                            image: NetworkImage(
                                state.kullanici!.fotograf!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: state.kullanici?.fotograf == null
                      ? const Center(
                          child: Text('👤',
                              style: TextStyle(fontSize: 24)))
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.kullanici?.ad ?? '',
                    style: const TextStyle(
                      color: T.metin,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    state.kullanici?.email ?? '',
                    style:
                        const TextStyle(color: T.metin2, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: T.sinir),
          const SizedBox(height: 8),
          // Güvenlik badge
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: T.basari.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: T.basari.withValues(alpha: 0.2)),
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
                        style: const TextStyle(
                            color: T.metin2, fontSize: 11),
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
                _DilSecici(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Çıkış butonu
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
                state.cikisYap();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: T.birincil,
                side: BorderSide(
                    color: T.birincil.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: Text(l.profLogout),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${l.appName} v1.0.0',
            style: TextStyle(
              color: T.metin3.withValues(alpha: 0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _DilSecici extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final secili = dilNotifier.value;
    return Row(
      children: [
        for (final d in destekliDiller)
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                dilNotifier.degistir(d['code'] as AppDil);
                Navigator.pop(context);
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
                    color: secili == d['code']
                        ? T.birincil
                        : T.sinir2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(d['flag'] as String,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 4),
                    Text(
                      (d['code'] as AppDil).name.toUpperCase(),
                      style: TextStyle(
                        color: secili == d['code']
                            ? T.birincil
                            : T.metin2,
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
    );
  }
}

// ─── Hero kart ────────────────────────────────────────────────

class _HeroKart extends StatelessWidget {
  final AppState state;
  const _HeroKart({required this.state});

  @override
  Widget build(BuildContext context) {
    final acik = state.aciklar;
    final kilitli = state.kilitliler;
    final ad = (state.kullanici?.ad ?? '').split(' ').first;

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
          border:
              Border.all(color: T.altin.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: T.mor.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, 10),
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
                    style: const TextStyle(
                        color: T.metin2, fontSize: 13),
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
                          horizontal: 10, vertical: 5),
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
          SizedBox(
            width: 88,
            height: 88,
            child: CircularProgressIndicator(
              value: oran,
              strokeWidth: 6,
              backgroundColor: T.sinir2.withValues(alpha: 0.5),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(T.basari),
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

// ─── İstatistik şeridi ────────────────────────────────────────

class _IstatistikSerit extends StatelessWidget {
  final AppState state;
  const _IstatistikSerit({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _AnimatedStatKart('🔒', state.kilitliler.length,
              l.homeLocked, T.birincil),
          const SizedBox(width: 8),
          _AnimatedStatKart('🔓', state.aciklar.length,
              l.homeUnlocked, T.basari),
          const SizedBox(width: 8),
          _AnimatedStatKart('📦', state.kapsullar.length,
              l.homeTotal, T.ikincil),
        ],
      ),
    );
  }
}

class _AnimatedStatKart extends StatelessWidget {
  final String ikon;
  final int sayi;
  final String etiket;
  final Color renk;
  const _AnimatedStatKart(this.ikon, this.sayi, this.etiket, this.renk);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: BoxDecoration(
            color: T.yuzey.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: renk.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                  color: renk.withValues(alpha: 0.06), blurRadius: 16),
            ],
          ),
          child: Column(
            children: [
              Text(ikon, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 6),
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: sayi),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (_, value, __) => Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: renk,
                    shadows: [
                      Shadow(
                          color: renk.withValues(alpha: 0.4),
                          blurRadius: 12),
                    ],
                  ),
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
