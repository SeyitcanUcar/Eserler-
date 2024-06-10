import 'package:animate_do/animate_do.dart';
import 'package:eserlerproject/api.dart';
import 'package:eserlerproject/onBoardingScreenPage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _checkLanguage().whenComplete(() {
      _checkFirstSeen().whenComplete(() {
        Future<void>.delayed(const Duration(seconds: 4), () {
          _seenOnboarding ? context.go('/home') : context.go('/onboarding');
        });
      });
    });

    super.initState();
  }

  bool _seenOnboarding = false;

  Future<void> _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('seenOnboarding') ?? false;

    if (seen) {
      setState(() {
        _seenOnboarding = true;
      });
    } else {
      await prefs.setBool('seenOnboarding', true);
      setState(() {
        _seenOnboarding = false;
      });
    }
         setState(() {
        _seenOnboarding = false;
      });
  }

  bool languageTr = true;
  Future<void> _checkLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('languageControl') ?? true;
    if (seen) {
      setState(() {
        languageTr = true;
      });
    } else {
      setState(() {
        languageTr = false;
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final GoRouter _router = GoRouter(
      initialLocation: '/splashscreen',
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return Scaffold(
              body: child,
            );
          },
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => apiPage(),
            ),
            GoRoute(
              path: '/splashscreen',
              builder: (context, state) => SplashScreen(),
            ),
            GoRoute(
              path: '/onboarding',
              builder: (context, state) => onBoardingScreen(),
            ),
          ],
        ),
      ],
    );
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Hero(
                tag: "Dünyadan Eserler",
                child: Image.asset(
                  "assets/images/backworld.jpg", fit: BoxFit.cover,
                  // color: isDarkTheme ? Colors.white : Colors.black,
                  height: MediaQuery.of(context).size.height / 4,
                ),
              ),
            ),
            Positioned(
                right: 20,
                top: 100,
                child: Column(
                  children: [
                    FadeInRight(
                        child: Text(
                      languageTr ? "DÜNYADAN" : "WORKS OF ART",
                      style: GoogleFonts.ebGaramond(
                          fontSize: 41, color: Color.fromARGB(255, 34, 64, 82)),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    BounceInLeft(
                        child: Text(
                      languageTr ? "ESERLER" : "FROM THE WORLD",
                      style: GoogleFonts.ebGaramond(
                          fontSize: 41, color: Color.fromARGB(255, 34, 64, 82)),
                    ))
                  ],
                ))
          ],
        ));
  }
}
