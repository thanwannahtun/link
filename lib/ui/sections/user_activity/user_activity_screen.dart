import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/city/city_cubit.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

import '../../../bloc/theme/theme_cubit.dart';
import '../../../core/utils/platform.dart';
import '../../utils/context.dart';
import '../../utils/route_list.dart';

class UserActivityScreen extends StatefulWidget {
  const UserActivityScreen({super.key});

  @override
  State<UserActivityScreen> createState() => _UserActivityScreenState();
}

class _UserActivityScreenState extends State<UserActivityScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(body: _body(context), title: "Activity");
  }

  Center _body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            child: const Text("Toggle Theme"),
          ),
          ElevatedButton(
            onPressed: () {},
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

              context.showSnackBar(Context.snackBar(Text(
                  "${platform.name} : ${platform.width} : actural width : ${context.size?.width}")));
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
    );
  }
}
