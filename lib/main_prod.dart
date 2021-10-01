import 'package:flutter/material.dart';
import 'package:nothing/app_config.dart';
import 'package:nothing/app_int.dart';

void main() async {
  AppConfig devAppConfig = AppConfig(
    appName: 'Nothing Prod',
    flavor: 'prod',
    isProd: true,
  );
  Widget app = await initializeApp(devAppConfig);
  runApp(app);
}
