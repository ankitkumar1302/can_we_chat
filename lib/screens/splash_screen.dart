import 'dart:developer';

import 'package:can_we_chat/api/apis.dart';
import 'package:can_we_chat/main.dart';
import 'package:can_we_chat/screens/auth/login_screen.dart';
import 'package:can_we_chat/screens/home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      // Exit Fullscreen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white,statusBarColor: Colors.white));

      if (APIs.auth.currentUser != null) {

        log('User: ${APIs.auth.currentUser}');
        
        //Navigate to HomeScreen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        //Navigate to HomeScreen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      //App Bar
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text('Login to Can We Chat?'),
      // ),

      body: Stack(children: [
        Positioned(
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset('images/instagram.png')),
        Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text(
              'Made in India with ❤️',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, color: Colors.black87, letterSpacing: .5),
            ))
      ]),
    );
  }
}
