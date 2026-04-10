import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/theme.dart';
import '../utils/l10n.dart';
import 'ana_ekran.dart';
import 'kutuphan_ekran.dart';

class AnaKabuk extends StatefulWidget {
  const AnaKabuk({super.key});
  @override
  State<AnaKabuk> createState() => _AnaKabukState();
}

class _AnaKabukState extends State<AnaKabuk> {
  int _sekme = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(
          index: _sekme,
          children: const [AnaEkran(), KutuphanEkran()],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: T.bg.withValues(alpha: 0.95),
            border: Border(
              top: BorderSide(
                  color: T.sinir.withValues(alpha: 0.5), width: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            indicatorColor: T.birincil.withValues(alpha: 0.12),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            selectedIndex: _sekme,
            onDestinationSelected: (i) {
              HapticFeedback.selectionClick();
              setState(() => _sekme = i);
            },
            destinations: [
              NavigationDestination(
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_sekme == 0)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: T.birincil.withValues(alpha: 0.3),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    Icon(
                      _sekme == 0
                          ? Icons.home_rounded
                          : Icons.home_outlined,
                      color: _sekme == 0 ? T.birincil : T.metin3,
                    ),
                  ],
                ),
                label: l.navHome,
              ),
              NavigationDestination(
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_sekme == 1)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: T.birincil.withValues(alpha: 0.3),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    Icon(
                      _sekme == 1
                          ? Icons.library_music_rounded
                          : Icons.library_music_outlined,
                      color: _sekme == 1 ? T.birincil : T.metin3,
                    ),
                  ],
                ),
                label: l.navLib,
              ),
            ],
          ),
        ),
      );
}
