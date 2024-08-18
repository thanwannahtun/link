import 'package:flutter/material.dart';
import 'package:link/core/utils/platform.dart';
import 'package:link/ui/sections/date_time.dart';
import 'package:link/ui/utils/context.dart';
import 'package:link/ui/utils/route_list.dart';
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

class C extends StatefulWidget {
  const C({super.key});

  @override
  State<C> createState() => _CState();
}

class _CState extends State<C> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Platform platform = Platform.currentPlatform(context);
                SnackBar snackBar = SnackBar(
                    content: Text(
                        "${platform.name} : ${platform.width} : actural width : ${context.size?.width}"));
                Context.showSnackBar(context, snackBar);
              },
              child: const Text("Get Current Platform"),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteLists.postCreatePage);
                },
                child: const Text("go to post_create_page ->")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DateTimeExamplePicker(),
                  ));
                },
                child: const Text("go to date time picker example ->"))
          ],
        ),
      ),
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
