import 'package:eserlerproject/api.dart';
import 'package:eserlerproject/onBoardingScreenPage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onboarding/onboarding.dart';

import 'splashScreenPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
    /*return Scaffold(
      body: SplashScreen(),
    );*/
  }
}
