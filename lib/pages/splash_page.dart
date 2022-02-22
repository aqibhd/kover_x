import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kover_x/const_file.dart';
import 'package:kover_x/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: primary,
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).viewPadding.top,
                    width: MediaQuery.of(context).size.width,
                    child: SizedBox(
                      height: 66.77,
                      width: 66,
                      child: Image.asset('assets/images/logo_splash.png'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(children: [
                        const Text(
                          "Powered by",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                            height: 18,
                            width: 53,
                            child: Image.asset(
                              'assets/images/pexels_splash.png',
                              fit: BoxFit.contain,
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
