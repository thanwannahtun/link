import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/theme/theme_cubit.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/ui/sections/test.dart';
import 'package:link/ui/widget_extension.dart';

class UtilityThemeTestPage extends StatefulWidget {
  const UtilityThemeTestPage({super.key});

  @override
  State<UtilityThemeTestPage> createState() => _UtilityThemeTestPageState();
}

class _UtilityThemeTestPageState extends State<UtilityThemeTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomButton(
            text: "Toggle Theme",
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            }),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.green,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Dark"),
                Text("Light"),
              ],
            ).padding(padding: const EdgeInsets.all(5)),
          ),
          Row(
            children: [
              // _buildTheme(context, Colors.black, context.darkTheme).expanded(),
              _buildTheme(context, Colors.white, context.lightTheme).expanded(),
            ],
          ).expanded(),
        ],
      ),
    );
  }

  Container _buildTheme(BuildContext context, Color bg, ThemeData themeData) {
    return Container(
      color: bg,
      child: Theme(
        data: themeData,
        child: Column(
          children: [
            const Icon(Icons.access_alarms),
            Wrap(children: [
              ElevatedButton(onPressed: () {}, child: const Text("Elevated")),
              TextButton(onPressed: () {}, child: const Text("Text")),
              OutlinedButton(onPressed: () {}, child: const Text("OutlineBtn")),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: const Text("Card")
                      .padding(padding: const EdgeInsets.all(8)),
                ),
                Card.filled(
                  child: const Text("Filled")
                      .padding(padding: const EdgeInsets.all(8)),
                ),
                Card.outlined(
                  child: const Text("Outlined")
                      .padding(padding: const EdgeInsets.all(8)),
                ),
              ],
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.add),
              trailing: const Icon(Icons.home),
              title: const Text("List Tile"),
            ),
            const Divider(),
          ],
        ).padding(padding: const EdgeInsets.all(10)),
      ),
    );
  }
}
