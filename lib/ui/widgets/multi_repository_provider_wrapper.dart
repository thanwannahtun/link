import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/hive/hive_util.dart';
import '../../domain/api_utils/api_service.dart';
import '../../repositories/city_repo.dart';
import '../../repositories/post_route.dart';

class MultiRepositoryProviderWrapper extends StatelessWidget {
  /// Wrapper for [multiple repository]
  ///
  /// extracting logic in a [separate] widget
  ///
  /// for clean [readable wrapper] widget

  const MultiRepositoryProviderWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final HiveUtil hiveUtil = HiveUtil();
    final ApiService apiService = ApiService();

    return MultiRepositoryProvider(providers: [
      RepositoryProvider<CityRepo>(
        create: (context) =>
            CityRepo(hiveUtil: hiveUtil, apiservice: apiService),
      ),
      RepositoryProvider<PostRouteRepo>(
        create: (context) => PostRouteRepo(apiService: apiService),
      ),
    ], child: child);
  }
}
