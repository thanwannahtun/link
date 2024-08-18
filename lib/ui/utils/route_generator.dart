import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/post_create_util/post_create_util_cubit.dart';
import 'package:link/ui/screens/app.dart';
import 'package:link/ui/screens/post/upload_new_post_page.dart';
import 'package:link/ui/screens/post_agency_profile.dart';
import 'package:link/ui/screens/post_detail.dart';
import 'package:link/ui/screens/route_list_screen.dart';
import 'package:link/ui/utils/route_list.dart';

class RouteGenerator {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteLists.app:
        return navigateRoute(
            settings: settings,
            builder: (context) {
              return const App();
            });
      case RouteLists.routePostList:
        return navigateRoute(
          settings: settings,
          builder: (context) {
            return const RouteListScreen();
          },
        );
      case RouteLists.agencyProfile:
        return navigateRoute(
          settings: settings,
          builder: (context) {
            return const AgencyProfile();
          },
        );
      case RouteLists.postDetailPage:
        return navigateRoute(
          settings: settings,
          builder: (context) {
            return const PostDetailPage();
          },
        );
      case RouteLists.postCreatePage:
        return navigateRoute(
          settings: settings,
          builder: (context) {
            return
                 MultiBlocProvider(providers: [
                  BlocProvider<PostCreateUtilCubit>(
                    create: (BuildContext context) => PostCreateUtilCubit(),
                  ),
                ], child:
                const UploadNewPostPage(),
             );
          },
        );
      default:
        return navigateRoute(
          settings: settings,
          builder: (context) => const NoRouteScreen(),
        );
    }
  }

  MaterialPageRoute<T> navigateRoute<T>(
      {required RouteSettings settings,
      required Widget Function(BuildContext context) builder}) {
    return MaterialPageRoute<T>(builder: builder, settings: settings);
  }
}

class NoRouteScreen extends StatelessWidget {
  const NoRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
