import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:objectdetection/splashpage.dart';
List<CameraDescription> ?cameras;
 Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
 cameras= await availableCameras();
    runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detection',
      theme: ThemeData(
      ),
      home:SplashPage() ,
      debugShowCheckedModeBanner: false,
    );
  }
}

