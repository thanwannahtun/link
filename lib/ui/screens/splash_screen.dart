import 'dart:async';

import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/ui/utils/route_list.dart';
import 'package:link/ui/widget_extension.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void delayAndNavigateHomeScreen() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 1500),
      (timer) => context.pushReplacementNamed(RouteLists.app),
    );
  }

  @override
  void initState() {
    super.initState();
    delayAndNavigateHomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("Welcome to Link ,Your best friend!").center(),
    );
  }
}
