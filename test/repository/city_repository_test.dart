import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:link/core/utils/hive_box_name.dart';
import 'package:link/data/hive/hive_util.dart';
import 'package:link/domain/api_utils/api_service.dart';
import 'package:link/models/city.dart';
import 'package:link/repositories/city_repo.dart';
import 'package:mocktail/mocktail.dart';

class _MockHiveUtil extends Mock implements HiveUtil {}

class _MockApiService extends Mock implements ApiService {}

void main() {
  late CityRepo cityRepo;
  late HiveUtil mockHiveUtil;
  late ApiService mockApiService;

  setUp(() {
    mockHiveUtil = _MockHiveUtil();
    mockApiService = _MockApiService();
    cityRepo = CityRepo(hiveUtil: mockHiveUtil, apiservice: mockApiService);
  });

  // Register fallback value for the `City` class
  setUpAll(() {
    registerFallbackValue(City(id: '0', name: 'Dummy City'));
  });

  final mockCacedCities = List<City>.generate(
      5, (index) => City(id: '$index', name: "city-$index"));

  // Mock API response to return raw JSON maps
  final mockApiResponse = List<Map<String, dynamic>>.generate(
    5,
    (index) => {
      "id": "${index + 1}",
      "name": "city-${index + 1}",
    },
  );
  final mockFetchedCities =
      mockApiResponse.map((cityMap) => City.fromJson(cityMap)).toList();

  group(CityRepo, () {
    test(
      "fetchCities - returns cached cities if available",
      () async {
        // Arrange
        when(() => mockHiveUtil.getAllValues<City>(HiveBoxName.cities))
            .thenAnswer((invocation) async => mockCacedCities);
        // Act
        final result = await cityRepo.fetchCities();
        // Assert
        expect(result, mockCacedCities);
        verifyNever(
            () => mockApiService.getRequest(any())); // API should not be called
      },
    );
    test(
      "fetchCities    - fetches cities from API if cache is empty",
      () async {
        // Mock HiveUtil to return empty list for cache
        when(() => mockHiveUtil.getAllValues<City>(any()))
            .thenAnswer((_) async => []);

        // Stubbing the API response to return [mockFetchedCities]
        when(() => mockApiService.getRequest(any())).thenAnswer((_) async {
          return Response(
              statusCode: 200,
              data: mockApiResponse,
              requestOptions: RequestOptions(path: "/cities"));
        });

        // Mock HiveUtil to handle caching operations
        when(() =>
                mockHiveUtil.clearAllValues<City>(boxName: HiveBoxName.cities))
            .thenAnswer((_) async => Future.value(mockCacedCities.length));

        when(() => mockHiveUtil.addValue<City>(any(), any(), any()))
            .thenAnswer((_) async {
          // print("adding mock city to cached...");
          return Future.value();
        });

        // Act
        final result = await cityRepo.fetchCities();

        // Assert
        expect(result,
            equals(mockFetchedCities)); // Verify fetched cities are returned

        // Verify the API was called once
        verify(() => mockApiService.getRequest("/cities")).called(1);

        // Verify that the cache was cleared before adding new cities
        verify(() =>
                mockHiveUtil.clearAllValues<City>(boxName: HiveBoxName.cities))
            .called(1);

        // Verify that the cities were cached (addValue should be called for each city)
        verify(() {
          for (int i = 0; i < mockFetchedCities.length; i++) {
            mockHiveUtil.addValue<City>(
              HiveBoxName.cities,
              any(),
              any(),
            );
          }
        }).called(mockFetchedCities.length); // Ensure the length matches
        /// Or
        /**
            verify(() {
            print("Expected number of calls: ${mockFetchedCities.length}");
            for (int i = 0; i < mockFetchedCities.length; i++) {
            mockHiveUtil.addValue<City>(
            HiveBoxName.cities,
            mockFetchedCities[i], // Match the exact value
            mockFetchedCities[i].id, // Match the id
            );
            }
            }).called(1); // Ensure the length matches
         *
         */
      },
    );

    ///
  });
}
