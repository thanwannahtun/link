import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:link/domain/api_utils/api_query.dart';
import 'package:link/domain/api_utils/api_service.dart';
import 'package:link/domain/enums/category_type.dart';
import 'package:link/models/post.dart';
import 'package:link/repositories/post_route.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'dart:io';
import 'package:mocktail/mocktail.dart';

class _MockApiService extends Mock implements ApiService {}

class _FakeFile extends Fake implements File {
  @override
  String get path => 'assets/logos/app_logo.png';
}

void main() {
  late PostRouteRepo postRouteRepo;
  late ApiService mockApiService;

  setUp(() {
    mockApiService = _MockApiService();
    postRouteRepo = PostRouteRepo(apiService: mockApiService);
  });

  final mockedFiles = [_FakeFile(), _FakeFile()];
  final post = Post(title: 'New Post');

  final routeModelResponse = [
    {
      '_id': '1',
      'title': 'New Post',
    }
  ];

  final routes = routeModelResponse.map((e) => RouteModel.fromJson(e)).toList();

  group('uploadNewPost', () {
    setUpAll(() {
      registerFallbackValue(_FakeFile());
    });

    test('should upload a new post and return a Post object on success',
        () async {
      // Arrange

      when(() => mockApiService.postRequest(any(), any(that: isA<FormData>())))
          .thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 201,
          data: {
            'data': [
              {
                '_id': '1',
                'title': 'New Post',
              }
            ]
          },
        ),
      );

      // Act
      final result =
          await postRouteRepo.uploadNewPost(post: post, files: mockedFiles);

      // Assert
      expect(result, isA<Post>());

      // Verify mocks were called
      verify(() => mockApiService.postRequest(
            '/routes/uploads/',
            any(that: isA<FormData>()),
          )).called(1);
    });

    test('should throw an exception when the API response is not 201',
        () async {
      when(() => mockApiService.postRequest(
          '/routes/uploads/', any(that: isA<FormData>()))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: {},
        ),
      );
      // Act & Assert
      expect(
          () async =>
              postRouteRepo.uploadNewPost(post: post, files: mockedFiles),
          throwsException);
    });
  });

  group('fetchRoutesByCategory', () {
    test(
        'should fetch routes and return a list of RouteModel objects on success',
        () async {
      // Arrange
      when(
        () => mockApiService.getRequest(
          '/routes',
          body: any(named: "body"),
          queryParameters: any(named: "queryParameters"),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'data': routeModelResponse,
          },
        ),
      );

      // Act
      final result = await postRouteRepo.fetchRoutesByCategory(
          query: APIQuery(categoryType: CategoryType.suggestedRoutes, limit: 5)
              .toJson());

      // Assert
      // expect(result, isA<List<RouteModel>>());
      expect(result, routes);
    });

    ///
    test('should throw an exception when the API response is not 200',
        () async {
      // Arrange
      when(() => mockApiService.getRequest(
            '/routes',
            body: any(named: "body"),
            queryParameters: any(named: "queryParameters"),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: {},
        ),
      );

      // Act & Assert
      expect(
        () async => await postRouteRepo.fetchRoutesByCategory(),
        throwsException,
      );
    });
  });

  ///
  group('getPostWithRoutes', () {
    final json = [
      {'description': 'description 1', 'title': 'Post 1'},
      {'description': 'description 2', 'title': 'Post 2'},
    ];

    final posts = json.map((e) => Post.fromJson(e)).toList();

    test('should fetch routes and return a list of Post objects on success',
        () async {
      // Arrange

      when(() => mockApiService.getRequest(
            '/routes',
            body: any(named: "body"),
            queryParameters: any(named: "queryParameters"),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'data': json,
          },
        ),
      );

      // Act
      final result = await postRouteRepo.getPostWithRoutes(
          query: APIQuery(categoryType: CategoryType.postWithRoutes, limit: 10)
              .toJson());

      // Assert
      // expect(result, isA<List<Post>>());
      expect(result, posts);
    });

    test('should throw an exception when the API response is not 200',
        () async {
      // Arrange
      when(() => mockApiService.getRequest(
            '/routes',
            body: any(named: "body"),
            queryParameters: any(named: "queryParameters"),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: {},
        ),
      );

      // Act & Assert
      expect(
        () async => await postRouteRepo.getPostWithRoutes(),
        throwsException,
      );
    });
  });
}
