import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/city/city_cubit.dart';
import 'package:link/bloc/theme/theme_cubit.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/platform.dart';
import 'package:link/models/app.dart';
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
            CustomButton(
                text: "Custom Button",
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                }),
            ElevatedButton(
              onPressed: () {
                print(App.cities.map((c) => c.toJson()));
              },
              child: const Text("Get Cities from Hive"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<CityCubit>().fetchCities();
              },
              child: const Text("Fetch Cities"),
            ),
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
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => const DateTimeExamplePicker(),
            //       ));
            //     },
            //     child: const Text("go to date time picker example ->"))
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

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: context.primaryColor,
          foregroundColor: context.titleColor,
          textStyle: context.titleLargeStyle),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
