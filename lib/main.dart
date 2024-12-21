import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:link/bloc/city/city_cubit.dart';
import 'package:link/bloc/theme/theme_cubit.dart';
import 'package:link/bloc/token_validator/token_validator_cubit.dart';
import 'package:link/bloc/authentication/authentication_cubit.dart';
import 'package:link/bloc/bottom_select/bottom_select_cubit.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/core/styles/app_theme.dart';
import 'package:link/domain/bloc_utils/app_bloc_observer.dart';
import 'package:link/models/city.dart';
import 'package:link/ui/utils/route_generator.dart';
import 'package:link/ui/utils/route_list.dart';

import 'bloc/agency/agency_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register Adapter
  Hive.registerAdapter(CityAdapter());

  Bloc.observer = AppBlocObserver();

  runApp(MultiBlocProvider(providers: [
    BlocProvider<ThemeCubit>(
      create: (context) => ThemeCubit()..getTheme(),
    ),
  ], child: const LinkApplication()));
}

class LinkApplication extends StatefulWidget {
  const LinkApplication({super.key});

  @override
  State<LinkApplication> createState() => _LinkApplicationState();
}

class _LinkApplicationState extends State<LinkApplication>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    context.read<ThemeCubit>().setSystemTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CityCubit>(
          create: (context) => CityCubit()..fetchCities(),
        ),
        BlocProvider<TokenValidatorCubit>(
          create: (BuildContext context) =>
              TokenValidatorCubit()..checkTokenExpiration(),
        ),
        BlocProvider<AuthenticationCubit>(
          create: (BuildContext context) => AuthenticationCubit(),
        ),
        BlocProvider<BottomSelectCubit>(
          create: (BuildContext context) => BottomSelectCubit(),
        ),
        BlocProvider<PostRouteCubit>(
          create: (context) => PostRouteCubit(),
        ),
        BlocProvider<AgencyCubit>(
          create: (context) => AgencyCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.onGenerateRoute,
            initialRoute: RouteLists.splashScreen,
            title: 'Link',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state,
          );
        },
      ),
    );
  }
}
