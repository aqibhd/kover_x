import 'package:flutter/material.dart';
import 'package:kover_x/pages/home_page.dart';
import 'package:kover_x/pages/splash_page.dart';

class Koverx extends StatelessWidget {
  const Koverx({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Koverx",
      theme: ThemeData(
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: Colors.white)),
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}
