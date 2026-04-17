import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/app_state.dart';
import 'utils/theme.dart';
import 'screens/giris_ekrani.dart';
import 'screens/ana_kabuk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sistem UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: T.bg,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Firebase başlat
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ZamanKapsuluApp());
}

class ZamanKapsuluApp extends StatefulWidget {
  const ZamanKapsuluApp({super.key});
  @override
  State<ZamanKapsuluApp> createState() => _ZamanKapsuluAppState();
}

class _ZamanKapsuluAppState extends State<ZamanKapsuluApp> {
  final AppState _state = AppState();

  @override
  void initState() {
    super.initState();
    _state.baslat();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      state: _state,
      child: ListenableBuilder(
        listenable: _state,
        builder: (_, __) => MaterialApp(
          title: 'Zaman Kapsülü',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: T.bg,
            colorScheme: const ColorScheme.dark(
              surface: T.bg,
              primary: T.birincil,
              secondary: T.ikincil,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: false,
            ),
            navigationBarTheme: const NavigationBarThemeData(
              height: 65,
              elevation: 0,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              labelTextStyle: WidgetStatePropertyAll(
                TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: T.yuzey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: T.sinir),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: T.sinir),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: T.birincil, width: 1.5),
              ),
              hintStyle: const TextStyle(color: T.metin3, fontSize: 14),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            snackBarTheme: SnackBarThemeData(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: T.yuzeyY,
            ),
          ),
          home: _state.yukleniyor
              ? const _SplashEkran()
              : _state.girisYapildi
                  ? const AnaKabuk()
                  : const GirisEkrani(),
        ),
      ),
    );
  }
}

class _SplashEkran extends StatelessWidget {
  const _SplashEkran();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: T.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    T.mor.withValues(alpha: 0.3),
                    T.bg,
                  ],
                ),
                border: Border.all(
                  color: T.mor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Text('🎵', style: TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: T.birincil,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
