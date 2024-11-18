import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/post_create_util/post_create_util_cubit.dart';
import 'package:link/ui/screens/app.dart';
import 'package:link/ui/screens/post/upload_new_post_page.dart';
import 'package:link/ui/sections/hot_and_trending/trending_route_card_detail.dart';
import 'package:link/ui/screens/post_detail.dart';
import 'package:link/ui/sections/hot_and_trending/hot_and_trending_screen.dart';
import 'package:link/ui/screens/splash_screen.dart';
import 'package:link/ui/sections/hot_and_trending/trending_routes_card.dart';
import 'package:link/ui/sections/profile/setting_screen.dart';
import 'package:link/ui/sections/search/search_query_routes.dart';
import 'package:link/ui/sections/upload/route_array_upload/ui/trending_routes_screen.dart';
import 'package:link/ui/utils/route_list.dart';

import '../screens/profile/public_agency_profile_screen.dart';
import '../screens/route_detail_page.dart';
import '../sections/hero_home/hero_home_screen.dart';
import '../sections/search/search_routes_screen.dart';
import '../sections/upload/new_route_upload_screen_advance.dart';
import '../sections/upload/post_create/post_create_cubit.dart';

class RouteGenerator {
  static Route<T>? onGenerateRoute<T>(RouteSettings settings) {
    debugPrint("-> ${settings.name}");
    switch (settings.name) {
      case RouteLists.splashScreen:
        return _navigateRoute(
            settings: settings,
            builder: (context) {
              return const SplashScreen();
            });
      case RouteLists.app:
        return _navigateRoute(
            settings: settings,
            builder: (context) {
              return const App();
              // return BlocProvider(
              //     create: (BuildContext context) =>
              //         PostRouteCubit()..fetchRoutes(),
              //     child: const App());
            });
      case RouteLists.hotAndTrendingScreen:
        return _navigateRoute(
          settings: settings,
          builder: (context) {
            return const HotAndTrendingScreen();
          },
        );
      case RouteLists.trendingRouteCards:
        return _navigateRoute(
          settings: settings,
          builder: (context) {
            return const TrendingRoutesCard();
          },
        );
      case RouteLists.trendingRouteCardDetail:
        return _navigateRoute(
          settings: settings,
          builder: (context) {
            return const TrendingRouteCardDetail();
          },
        );
      case RouteLists.searchQueryRoutes:
        return _navigateRoute(
          settings: settings,
          builder: (context) {
            return const SearchQueryRoutes();
          },
        );
      case RouteLists.searchRoutesScreen:
        return _navigateRoute(
          settings: settings,
          builder: (context) {
            return const SearchRoutesScreen();
          },
        );
      case RouteLists.heroHomeScreen:
        return _navigateRoute(
          settings: settings,
          builder: (context) {
            return const HeroHomeScreen();
          },
        );

      case RouteLists.publicAgencyProfile:
        return _navigateRoute(
          settings: settings,
          builder: (context) {
            return const PublicAgencyProfileScreen();
          },
        );
      case RouteLists.settingScreen:
        return _navigateRoute(
          settings: settings,
          builder: (context) {
            return const SettingScreen();
          },
        );
      case RouteLists.postDetailPage:
        return _navigateRoute(
          settings: settings,
          builder: (context) {
            return const PostDetailPage();
          },
        );
      case RouteLists.routeDetailPage:
        return _navigateRoute(
          settings: settings,
          builder: (context) {
            return const RouteDetailScreen();
          },
        );
      case RouteLists.getTrendingRoutes:
        return _navigateRoute(
          settings: settings,
          builder: (context) {
            return const TrendingRoutesScreen();
          },
        );
      case RouteLists.uploadNewPost:
        return _navigateRoute(
          settings: settings,
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<PostCreateCubit>(
                  create: (BuildContext context) => PostCreateCubit(),
                ),
              ],
              child: const NewRouteUploadScreen(),
            );
          },
        );
      case RouteLists.postCreatePage:
        return _navigateRoute(
          settings: settings,
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<PostCreateUtilCubit>(
                  create: (BuildContext context) => PostCreateUtilCubit(),
                ),
              ],
              child: const UploadNewPostPage(),
            );
          },
        );
      default:
        return _navigateRoute(
          settings: settings,
          builder: (context) => const NoRouteScreen(),
        );
    }
  }

  static Route<T>? _navigateRoute<T>(
      {required WidgetBuilder builder, RouteSettings? settings}) {
    return MaterialPageRoute(builder: builder, settings: settings);
  }
}

class NoRouteScreen extends StatelessWidget {
  const NoRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
