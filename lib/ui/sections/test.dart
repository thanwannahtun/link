import 'package:flutter/material.dart';

class B extends StatelessWidget {
  const B({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('B'),
        leading: Container(),
        centerTitle: true,
      ),
    );
  }
}

class C extends StatelessWidget {
  const C({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('C'),
        leading: Container(),
        centerTitle: true,
      ),
    );
  }
}

class D extends StatelessWidget {
  const D({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('D'),
        leading: Container(),
        centerTitle: true,
      ),
    );
  }
}
