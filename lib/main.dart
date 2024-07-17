import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/bottom_select/bottom_select_cubit.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/ui/utils/route_generator.dart';
import 'package:link/ui/utils/route_list.dart';

void main() {
  runApp(const LinkApplication());
}

class LinkApplication extends StatelessWidget {
  const LinkApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomSelectCubit>(
          create: (BuildContext context) => BottomSelectCubit(),
        ),
        BlocProvider<PostRouteCubit>(
          create: (context) => PostRouteCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator().generateRoute,
        initialRoute: RouteLists.app,
        title: 'Link',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
