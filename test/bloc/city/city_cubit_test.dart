import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:link/bloc/city/city_cubit.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/app.dart';
import 'package:link/models/city.dart';
import 'package:link/repositories/city_repo.dart';
import 'package:mocktail/mocktail.dart';

// Mock class for CityRepo
class _MockCityRepo extends Mock implements CityRepo {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late _MockCityRepo mockCityRepo;
  final mockCities = List<City>.generate(
      5, (index) => City(id: '$index', name: "city-$index"));

  setUp(
    () {
      mockCityRepo = _MockCityRepo();
    },
  );

  tearDown(() {
    /// Here clear the Global valut to prevent  **[global state leakage]**
    App.cities.clear();
    reset(mockCityRepo); // Resets mock interactions
  });

  group(
    "[ CityCubit ]",
    () {
      test(
        "initial state is CityState with empty cities and initial status",
        () async {
          expect(CityCubit(cityRepo: mockCityRepo).state,
              const CityState(cities: [], status: BlocStatus.initial));
        },
      );

      blocTest(
        "fetchCities emits [fetching, fetched] when successful",
        build: () {
          return CityCubit(cityRepo: mockCityRepo);
        },
        setUp: () {
          when(() => mockCityRepo.fetchCities()).thenAnswer((_) async {
            return mockCities;
          });
        },
        act: (cubit) => cubit.fetchCities(),
        verify: (cubit) {
          mockCityRepo.fetchCities();
        },
        expect: () => <CityState>[
          const CityState(cities: [], status: BlocStatus.fetching),
          CityState(cities: mockCities, status: BlocStatus.fetched),
        ],
      );

      blocTest<CityCubit, CityState>(
        "fetchCities emits [fetching, fetchFailed] when an error occurs",
        build: () {
          return CityCubit(cityRepo: mockCityRepo);
        },
        setUp: () {
          when(() => mockCityRepo.fetchCities()).thenThrow(Exception("ERROR"));
        },
        act: (cubit) => cubit.fetchCities(),
        verify: (cubit) {
          // Verify that fetchCities was called on the mocked CityRepo
          verify(() => mockCityRepo.fetchCities()).called(1);
        },
        expect: () => [
          const CityState(cities: [], status: BlocStatus.fetching),
          const CityState(
              cities: [],
              status: BlocStatus.fetchFailed,
              error: "Exception: ERROR"),
        ],
      );
    },
  );
}

/**

    import 'package:flutter_test/flutter_test.dart';
    import 'package:mocktail/mocktail.dart';
    import 'package:flutter_bloc/flutter_bloc.dart';
    import 'package:flutter/material.dart';
    import 'package:link/bloc/city_cubit.dart';
    import 'package:link/ui/city_list_screen.dart';

    class MockCityCubit extends MockCubit<CityState> implements CityCubit {}

    void main() {
    late MockCityCubit mockCityCubit;

    setUp(() {
    mockCityCubit = MockCityCubit();
    });

    Widget createWidgetUnderTest() {
    return BlocProvider<CityCubit>(
    create: (_) => mockCityCubit,
    child: const MaterialApp(
    home: CityListScreen(),
    ),
    );
    }

    testWidgets('shows loading indicator when state is fetching', (WidgetTester tester) async {
    // Arrange
    when(() => mockCityCubit.state).thenReturn(const CityState(
    status: BlocStatus.fetching,
    cities: [],
    ));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows list of cities when state is fetched', (WidgetTester tester) async {
    // Arrange
    final mockCities = [
    City(id: '1', name: 'City 1'),
    City(id: '2', name: 'City 2'),
    ];
    when(() => mockCityCubit.state).thenReturn(CityState(
    status: BlocStatus.fetched,
    cities: mockCities,
    ));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('City 1'), findsOneWidget);
    expect(find.text('City 2'), findsOneWidget);
    });

    testWidgets('shows error message when state is fetchFailed', (WidgetTester tester) async {
    // Arrange
    when(() => mockCityCubit.state).thenReturn(const CityState(
    status: BlocStatus.fetchFailed,
    cities: [],
    error: 'Failed to fetch cities',
    ));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('Failed to fetch cities'), findsOneWidget);
    });
    }


 *
 */
