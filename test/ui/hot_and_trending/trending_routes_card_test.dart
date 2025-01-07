import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/ui/sections/hot_and_trending/trending_routes_card.dart';
import 'package:mocktail/mocktail.dart';

class _MockPostRouteCubit extends Mock implements PostRouteCubit {}

class _FakePostRouteState extends Fake implements PostRouteState {}

void main() {
  late PostRouteCubit cubit;

  setUp(
    () {
      cubit = _MockPostRouteCubit();
    },
  );

  setUpAll(() {
    registerFallbackValue(_FakePostRouteState());
  });
  tearDown(() {
    cubit.close(); // Dispose of the cubit to clean up resources
  });

  pumpTrendingRouteCardWidget() {
    return BlocProvider.value(
      value: cubit,
      child: const MaterialApp(
        home: TrendingRoutesCard(),
      ),
    );
  }

  group(TrendingRoutesCard, () {
    testWidgets(
      "Show Circular Indicator if the PostRouteState is loading...",
      (WidgetTester tester) async {
        when(() => cubit.getRoutesByCategory(query: any(named: 'query')))
            .thenAnswer((_) async {});
        when(() => cubit.state).thenReturn(const PostRouteState(
            status: BlocStatus.fetching, routes: [], routeModels: []));

        await tester.pumpWidget(pumpTrendingRouteCardWidget());

        /// Mock the state

        var circular = find.byKey(const Key("circular"));
        var postViewBuilder = find.byKey(const Key("post-view-builder"));

        /// Assert
        expect(circular, findsOneWidget);
        expect(postViewBuilder, findsNothing);
      },
    );
  });
}
