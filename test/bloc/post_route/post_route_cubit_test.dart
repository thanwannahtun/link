import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/domain/api_utils/api_query.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/domain/enums/category_type.dart';
import 'package:link/models/post.dart';
import 'package:link/repositories/post_route.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:mocktail/mocktail.dart';

class _MockPostRouteRepo extends Mock implements PostRouteRepo {}

class _FakeFile extends Fake implements File {
  @override
  String get path => 'assets/logos/app_logo.png';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PostRouteCubit bloc;
  late PostRouteRepo postRouteRepo;

  setUp(() {
    postRouteRepo = _MockPostRouteRepo();
    bloc = PostRouteCubit(postRouteRepo: postRouteRepo);
  });

  setUpAll(() {
    registerFallbackValue(_FakeFile());
  });

  group(PostRouteCubit, () {
    test(
      "initial state is PostRouteState with empty routes, empty routeModels and initial status",
      () async {
        expect(PostRouteCubit(postRouteRepo: postRouteRepo).state,
            const PostRouteState());
      },
    );

    group(
      "uploadNewPost",
      () {
        const post = Post(description: "description", title: "title");
        const routePost = Post(description: "description", title: "title");
        final files = <File>[_FakeFile(), _FakeFile()];

        blocTest<PostRouteCubit, PostRouteState>(
          'should emit [BlocStatus.uploading, BlocStatus.uploaded] when post is uploaded successfully',
          build: () => bloc,
          setUp: () {
            when(
              () => postRouteRepo.uploadNewPost(
                // post: any(named: "post", that: isA<Post>()),
                // files: any(named: "files", that: isA<List<File>>()),
                post: post,
                files: files,
              ),
            ).thenAnswer((_) async => post);
          },
          verify: (_) {
            verify(() => postRouteRepo.uploadNewPost(
                  post: post,
                  files: files,
                )).called(1);
          },
          act: (bloc) => bloc.uploadNewPost(post: post, files: files),
          expect: () => [
            const PostRouteState(
                status: BlocStatus.uploading, routeModels: [], routes: []),
            const PostRouteState(
                status: BlocStatus.uploaded,
                routeModels: [],
                routes: [routePost]),
          ],
        );

        blocTest<PostRouteCubit, PostRouteState>(
          'should emit [BlocStatus.uploading, BlocStatus.uploaded] when post is uploaded successfully',
          build: () => bloc,
          setUp: () {
            when(
              () => postRouteRepo.uploadNewPost(
                // post: any(named: "post", that: isA<Post>()),
                // files: any(named: "files", that: isA<List<File>>()),
                post: post,
                files: files,
              ),
            ).thenThrow(Exception("Error uploading..!"));
          },
          act: (bloc) => bloc.uploadNewPost(post: post, files: files),
          expect: () => [
            const PostRouteState(
                status: BlocStatus.uploading, routeModels: [], routes: []),
            const PostRouteState(
                status: BlocStatus.uploadFailed,
                routeModels: [],
                routes: [],
                error: "Exception: Error uploading..!"),
          ],
        );
      },
    );

    group('getRoutesByCategory', () {
      final routes = [
        const RouteModel(id: '1', description: 'Route 1'),
        const RouteModel(id: '2', description: 'Route 2'),
      ];

      test(
        "ensures _page value is incremented on successful fetch",
        () async {
          /// Arrange
          when(() => postRouteRepo.fetchRoutesByCategory(
                query: any(named: "query"),
                body: any(named: "body"),
              )).thenAnswer((_) async => routes);

          /// Act
          await bloc.getRoutesByCategory(
              query: APIQuery(
                  categoryType: CategoryType.suggestedRoutes, limit: 5));

          /// expect
          expect(bloc.getPage, 2);
        },
      );

      blocTest<PostRouteCubit, PostRouteState>(
        'should emit [BlocStatus.fetching, BlocStatus.fetched] when routes are fetched successfully',
        build: () => bloc,
        setUp: () {
          when(() => postRouteRepo.fetchRoutesByCategory(
                query: any(named: 'query'),
                body: any(named: 'body'),
              )).thenAnswer((_) async => routes);
        },
        act: (cubit) => cubit.getRoutesByCategory(
          query:
              APIQuery(categoryType: CategoryType.suggestedRoutes, limit: 10),
        ),
        expect: () => [
          const PostRouteState(status: BlocStatus.fetching),
          PostRouteState(
              status: BlocStatus.fetched,
              routeModels: routes,
              routes: const []),
        ],
      );

      blocTest<PostRouteCubit, PostRouteState>(
        'should emit [BlocStatus.fetching, BlocStatus.fetchFailed] on error',
        build: () => bloc,
        setUp: () {
          when(() => postRouteRepo.fetchRoutesByCategory(
                query: any(named: 'query'),
                body: any(named: 'body'),
              )).thenThrow(Exception('Fetch failed'));
        },
        act: (cubit) => cubit.getRoutesByCategory(
          query: APIQuery(categoryType: CategoryType.trendingRoutes, limit: 10),
        ),
        expect: () => [
          const PostRouteState(status: BlocStatus.fetching),
          const PostRouteState(
            status: BlocStatus.fetchFailed,
            error: 'Exception: Fetch failed',
          ),
        ],
      );

      group(
        "Infinite Scrolling routes fetching..",
        () {
          /// seeded states
          final routes = [
            const RouteModel(id: '1', description: 'Route 1'),
            const RouteModel(id: '2', description: 'Route 2'),
          ];

          /// newly fetched routes
          final newRoutes = [
            const RouteModel(id: '3', description: 'Route 3'),
            const RouteModel(id: '4', description: 'Route 4'),
          ];

          ///
          blocTest<PostRouteCubit, PostRouteState>(
            "should emit [BlocStatus.fetching, BlocStatus.fetched] when routes are fetched successfully "
            "then append the fetched routes to the previous state's routes",
            build: () => bloc,
            setUp: () {
              when(() => postRouteRepo.fetchRoutesByCategory(
                    query: any(named: 'query'),
                    body: any(named: 'body'),
                  )).thenAnswer((_) async => newRoutes);
            },
            act: (cubit) => cubit.getRoutesByCategory(
              query: APIQuery(
                  categoryType: CategoryType.suggestedRoutes, limit: 10),
            ),
            seed: () => PostRouteState(routeModels: routes),
            expect: () => [
              PostRouteState(status: BlocStatus.fetching, routeModels: routes),
              PostRouteState(
                status: BlocStatus.fetched,
                routeModels: [...routes, ...newRoutes],
              ),
            ],
          );
        },
      );
    });

    group('getPostWithRoutes', () {
      blocTest<PostRouteCubit, PostRouteState>(
        'should emit [BlocStatus.fetching, BlocStatus.fetched] when posts with routes are fetched successfully',
        build: () => bloc,
        setUp: () {
          final posts = [
            const Post(id: '1', title: 'Post 1'),
            const Post(id: '2', title: 'Post 2'),
          ];
          when(() => postRouteRepo.getPostWithRoutes(
                query: any(named: 'query'),
                body: any(named: 'body'),
              )).thenAnswer((_) async => posts);
        },
        act: (cubit) => cubit.getPostWithRoutes(
          query: APIQuery(categoryType: CategoryType.postWithRoutes, limit: 10),
        ),
        expect: () => [
          const PostRouteState(status: BlocStatus.fetching),
          const PostRouteState(
            status: BlocStatus.fetched,
            routes: [
              Post(id: '1', title: 'Post 1'),
              Post(id: '2', title: 'Post 2'),
            ],
          ),
        ],
      );

      blocTest<PostRouteCubit, PostRouteState>(
        'should emit [BlocStatus.fetching, BlocStatus.fetchFailed] on error',
        build: () => bloc,
        setUp: () {
          when(() => postRouteRepo.getPostWithRoutes(
                query: any(named: 'query'),
                body: any(named: 'body'),
              )).thenThrow(Exception('Fetch failed'));
        },
        act: (cubit) => cubit.getPostWithRoutes(
          query: APIQuery(categoryType: CategoryType.postWithRoutes, limit: 10),
        ),
        expect: () => [
          const PostRouteState(status: BlocStatus.fetching),
          const PostRouteState(
            status: BlocStatus.fetchFailed,
            error: 'Exception: Fetch failed',
          ),
        ],
      );
    });

    ///
  });
}
