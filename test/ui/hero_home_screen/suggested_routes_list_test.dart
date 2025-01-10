import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/ui/sections/hero_home/widgets/suggested_routes_list.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/widgets/route_card_widgets/route_card_widgets.dart';
import 'package:link/ui/widgets/route_fetched_widgets/route_fetched_widgets.dart';
import 'package:mocktail/mocktail.dart';

class _MockPostRouteCubit extends MockCubit<PostRouteState>
    implements PostRouteCubit {}

extension on WidgetTester {
  Future<void> pumpSuggestedRoutesList(PostRouteCubit bloc) {
    return pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: bloc,
        child: const SuggestedRoutesList(),
      ),
    ));
  }
}

void main() {
  late PostRouteCubit bloc;

  setUp(() {
    bloc = _MockPostRouteCubit();
  });

  /// Mock Data
  final routes = List<RouteModel>.generate(
    5,
    (index) => RouteModel(
      description: "Description $index",
      pricePerTraveller: 5000,
      scheduleDate: DateTime.now(),
    ),
  );
  final moreRoutes = List<RouteModel>.generate(
    5,
    (index) => RouteModel(
      description: "Description more $index",
      pricePerTraveller: 4000,
      scheduleDate: DateTime.now(),
    ),
  );

  group(SuggestedRoutesList, () {
    testWidgets(
      "Render $RouteFetchingWidget when status is ${BlocStatus.fetching}",
      (WidgetTester tester) async {
        when(() => bloc.state)
            .thenReturn(const PostRouteState(status: BlocStatus.fetching));
        await tester.pumpSuggestedRoutesList(bloc);
        expect(find.byType(RouteFetchingWidget), findsOneWidget);
        expect(find.byType(RouteFetchedEmptyWidget), findsNothing);
        expect(find.byType(RouteFetchedFailWidget), findsNothing);
      },
    );
    testWidgets(
      "Render $RouteFetchedEmptyWidget when status is ${BlocStatus.fetched} with empty routeModels",
      (WidgetTester tester) async {
        when(() => bloc.state).thenReturn(
            const PostRouteState(status: BlocStatus.fetched, routeModels: []));
        await tester.pumpSuggestedRoutesList(bloc);
        expect(find.byType(RouteFetchingWidget), findsNothing);
        expect(find.byType(RouteFetchedEmptyWidget), findsOneWidget);
        expect(find.byType(RouteFetchedFailWidget), findsNothing);
      },
    );
    testWidgets(
      "Render $RouteFetchedFailWidget when status is ${BlocStatus.fetchFailed}",
      (WidgetTester tester) async {
        when(() => bloc.state)
            .thenReturn(const PostRouteState(status: BlocStatus.fetchFailed));
        await tester.pumpSuggestedRoutesList(bloc);
        expect(find.byType(RouteFetchingWidget), findsNothing);
        expect(find.byType(RouteFetchedEmptyWidget), findsNothing);
        expect(find.byType(RouteFetchedFailWidget), findsOneWidget);
      },
    );

    ///
    /// ⚠️ This test is not completed !

    testWidgets(
      "Render $RouteCardWidget when status is ${BlocStatus.fetched}",
      (WidgetTester tester) async {
        whenListen(
            bloc,
            Stream.fromIterable([
              PostRouteState(status: BlocStatus.fetched, routeModels: routes),
              PostRouteState(status: BlocStatus.fetching, routeModels: routes),
              PostRouteState(
                  status: BlocStatus.fetched, routeModels: moreRoutes),
            ]),
            initialState: PostRouteState(
                status: BlocStatus.fetched, routeModels: routes));
        await tester.pumpSuggestedRoutesList(bloc);
        expect(find.byType(RouteFetchingWidget), findsNothing);
        expect(find.byType(RouteFetchedEmptyWidget), findsNothing);
        expect(find.byType(RouteFetchedFailWidget), findsNothing);
        expect(find.byType(RouteCardWidget), findsNWidgets(2));

        /// the post width is 90 % in phone screen
        /// minum two and extrax edge in tablet
        /// minium three and extrax edge in window

        expect(find.byKey(const Key('route-list-key')), findsOneWidget);
        expect(find.byKey(const Key('route-list-builder-shimmer-key')),
            findsNothing);
        expect(find.byKey(const Key('route-list-builder-reach-max-extend-key')),
            findsNothing);

        /// Simulate horizontal drag to fetch more routes
        await tester.drag(
          find.byKey(const Key('route-list-key')), // Find the list by key
          const Offset(-500.0, 0.0), // Drag left
        );
      },
    );
  });
}
