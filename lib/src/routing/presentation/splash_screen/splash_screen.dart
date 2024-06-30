import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: Image.asset('assets/images/moula.png').image,
            fit: BoxFit.cover),
      ),
      child: const Scaffold(
        backgroundColor: Colors.black,
      ),
    );
  }
}
