import 'package:flutter/material.dart';
import 'package:link/ui/widget_extension.dart';

class B extends StatelessWidget {
  const B({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("B").center(),
    );
  }
}

class C extends StatelessWidget {
  const C({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("C").center(),
    );
  }
}

class D extends StatelessWidget {
  const D({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("D").center(),
    );
  }
}
