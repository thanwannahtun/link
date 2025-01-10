import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/repositories/post_route.dart';
import 'package:link/ui/sections/hero_home/hero_home_screen.dart';
import 'package:link/ui/sections/hero_home/widgets/suggested_routes_list.dart';
import 'package:link/ui/sections/hero_home/widgets/trending_and_hot_routes_list.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:mocktail/mocktail.dart';

class _MockPostRouteCubit extends MockCubit<PostRouteState>
    implements PostRouteCubit {}

class _MockPostRouteRepo extends Mock implements PostRouteRepo {}

void main() {
  late PostRouteCubit trendingRouteBloc;
  late PostRouteCubit suggestedRouteBloc;
  late PostRouteRepo repo;
  setUp(() {
    repo = _MockPostRouteRepo();
    trendingRouteBloc = _MockPostRouteCubit();
    suggestedRouteBloc = _MockPostRouteCubit();
  });

  Widget pumpHeroHomeScreen() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostRouteCubit>.value(value: trendingRouteBloc),
        BlocProvider<PostRouteCubit>.value(value: suggestedRouteBloc),
      ],
      child: MaterialApp(
        home: RepositoryProvider(
          create: (context) => repo,
          child: const HeroHomeScreen(),
        ),
      ),
    );
  }

  Widget pumpTrendingAndHotRouteListWidget() {
    return BlocProvider.value(
      value: trendingRouteBloc,
      child: const MaterialApp(
        home: TrendingAndHotRoutesList(),
      ),
    );
  }

  Widget pumpSuggestedRoutesListWidget() {
    return BlocProvider.value(
      value: suggestedRouteBloc,
      child: const MaterialApp(
        home: SuggestedRoutesList(),
      ),
    );
  }

  /// Mock Data
  final fetchedRoutes = List<RouteModel>.generate(
    5,
    (index) => RouteModel(
      description: "Description $index",
      pricePerTraveller: 5000,
      scheduleDate: DateTime.now(),
    ),
  );

  group('HeroHomeScreen Widget Tests', () {
    testWidgets(
      "Render HeroHomeScreen with TrendingAndHotRoutesList and SuggestedRoutesList",
      (WidgetTester tester) async {
        await tester.pumpWidget(pumpHeroHomeScreen());
        expect(find.byType(TrendingAndHotRoutesList), findsOneWidget);
        expect(find.byType(SuggestedRoutesList), findsOneWidget);
      },
    );

    testWidgets(
      "Render TrendingAndHotRoutesList with mocked data",
      (WidgetTester tester) async {
        when(() => trendingRouteBloc.state).thenReturn(PostRouteState(
            status: BlocStatus.fetched, routeModels: fetchedRoutes));

        await tester.pumpWidget(pumpTrendingAndHotRouteListWidget());

        expect(find.byKey(const Key("trending-and-hot-route-list-key")),
            findsOneWidget);
      },
    );

    testWidgets(
      "Render SuggestedRoutesList with mocked data",
      (WidgetTester tester) async {
        when(() => suggestedRouteBloc.state).thenReturn(PostRouteState(
            status: BlocStatus.fetched, routeModels: fetchedRoutes));

        await tester.pumpWidget(pumpSuggestedRoutesListWidget());
        expect(
            find.byKey(const Key("suggested-route-list-key")), findsOneWidget);
      },
    );
  });
}
