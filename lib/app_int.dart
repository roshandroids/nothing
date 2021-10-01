import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nothing/app_config.dart';
import 'package:nothing/main.dart';

Future<Widget> initializeApp(AppConfig appConfig) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  return MyApp(
    appConfig: appConfig,
  );
}
