import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moula/firebase_options.dart';
import 'package:moula/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
