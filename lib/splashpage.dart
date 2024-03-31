import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      backgroundImage:Image.asset(
          "assets/wallpaperflare.com_wallpaper (7).jpg").image,
      
      title: Text(
        "Detection",
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.green,
      showLoader: true,
      loadingText: Text("Loading...",style: TextStyle(color: Colors.white),),
      navigator: home(),
      durationInSeconds: 10, logo: Image.asset("assets/plant.png"),
    );
  }
}