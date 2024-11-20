import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:link/domain/api_utils/api_error_handler.dart';
import 'package:link/domain/api_utils/api_query.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/post.dart';
import 'package:link/repositories/post_route.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';

import 'package:stream_transform/stream_transform.dart';

import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'post_route_state.dart';

String handleErrorMessage(Exception e) => ApiErrorHandler.handle(e).message;

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> _throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    // return droppable<E>().call(events.throttle(duration), mapper);
    return droppable<E>().call(
        events.throttle(duration).where((event) => event != null), mapper);
  };
}

class PostRouteCubit extends Cubit<PostRouteState> {
  final _postApiRepo = PostRouteRepo();

  // ignore: prefer_final_fields
  int _page = 1;

  int get getPage {
    return _page;
  }

  void updatePage({int? value}) {
    _page = value ?? 1;
  }

  PostRouteCubit()
      : super(const PostRouteState(
            status: BlocStatus.initial, routes: [], routeModels: []));

  // ignore: unused_element
  _fetchRoutes({Object? body, Map<String, dynamic>? query}) async {
    if (state.status == BlocStatus.fetching) return;
    emit(state.copyWith(status: BlocStatus.fetching));
    try {
      var queryParams = <String, dynamic>{
        "page": _page,
      }..addEntries(query?.entries ?? {});

      List<Post> posts = await _postApiRepo.fetchRoutes(
        query: queryParams,
        body: body,
      );

      /// Checking success fetchRoutes
      if (posts.isNotEmpty) {
        _page++;
      }
      Future.delayed(
        const Duration(seconds: 2),
        () => emit(state.copyWith(status: BlocStatus.fetched, routes: posts)),
      );
    } on Exception catch (e, stackTrace) {
      debugPrint("""====== <Error> >
            (error) - $e
            ====== 
            (staceTrace) - $stackTrace 
            ====== <Error/>""");
      emit(state.copyWith(
          routes: [],
          status: BlocStatus.fetchFailed,
          error: ApiErrorHandler.handle(e).message));
    }
  }

  uploadNewPost({required Post post, List<File?> files = const []}) async {
    emit(state.copyWith(status: BlocStatus.uploading));
    try {
      Post response =
          await _postApiRepo.uploadNewPost(post: post, files: files);

      List<Post> updatedPosts = List.from(state.routes);
      updatedPosts.add(response);

      emit(state.copyWith(status: BlocStatus.uploaded, routes: updatedPosts));
    } on Exception catch (e, s) {
      debugPrint("""====== <Error> >
            (error) - $e
            ====== 
            (staceTrace) - $s 
            ====== <Error/>""");

      emit(state.copyWith(
          status: BlocStatus.uploadFailed, error: handleErrorMessage(e)));
    }
  }

  Future _getRoutesByCategoryFutureTask({Object? body, APIQuery? query}) async {
    // await Future. delayed(const Duration(seconds: 5));
    // return 'Future complete';
    emit(state.copyWith(status: BlocStatus.fetching));
    try {
      APIQuery? queryParams = query?.copyWith(page: _page);

      List<RouteModel> routes = await _postApiRepo.fetchRoutesByCategory(
        query: queryParams?.toJson(),
        body: body,
      );

      /// Checking success fetchRoutes
      if (routes.isNotEmpty) {
        _page++;
      }

      final List<RouteModel> fetchedRoutes = [...state.routeModels, ...routes];

      emit(state.copyWith(
          status: BlocStatus.fetched, routeModels: fetchedRoutes));
    } on Exception catch (e, stackTrace) {
      debugPrint("""<Error> >
            (error) - $e
            ====== 
            (staceTrace) - $stackTrace 
            <Error/>""");
      emit(state.copyWith(
          routeModels: [],
          status: BlocStatus.fetchFailed,
          error: handleErrorMessage(e)));
    }
  }

  getRoutesByCategory({Object? body, APIQuery? query}) async {
    if (state.status == BlocStatus.fetching) return;
    _throttleDroppable(throttleDuration)(
      Stream.fromFuture(
              _getRoutesByCategoryFutureTask(body: body, query: query))
          .where((event) => event != null), // optional
      (event) => event,
    );
  }

  getPostWithRoutes({Object? body, APIQuery? query}) async {
    if (state.status == BlocStatus.fetching) return;
    emit(state.copyWith(status: BlocStatus.fetching));
    try {
      APIQuery? queryParams = query?.copyWith(page: _page);

      List<Post> posts = await _postApiRepo.getPostWithRoutes(
        query: queryParams?.toJson(),
        body: body,
      );

      /// Checking success fetchRoutes
      if (posts.isNotEmpty) {
        _page++;
      }
      final List<Post> fetchedPosts = [...state.routes, ...posts];

      emit(state.copyWith(status: BlocStatus.fetched, routes: fetchedPosts));
    } on Exception catch (e, stackTrace) {
      debugPrint("""<Error> >
            (error) - $e
            ====== 
            (staceTrace) - $stackTrace 
            <Error/>""");
      emit(state.copyWith(
          routes: [],
          status: BlocStatus.fetchFailed,
          error: handleErrorMessage(e)));
    }
  }

  /// Throttling
  /// Fetch routes by category with throttling applied
  // ignore: unused_element
  void _fetchRoutesByCategoryWithThrottle(
      {Object? body, APIQuery? query}) async {
    // Ensure only one fetch process is running
    if (state.status == BlocStatus.fetching) return;

    /// Throttling applied here
    _throttleDroppable(throttleDuration)(
      Stream.fromFuture(Future(() async {
        emit(state.copyWith(status: BlocStatus.fetching));
        try {
          APIQuery? queryParams = query?.copyWith(page: _page);

          List<RouteModel> routes = await _postApiRepo.fetchRoutesByCategory(
            query: queryParams?.toJson(),
            body: body,
          );

          // Update state if routes are fetched
          if (routes.isNotEmpty) {
            _page++;
          }

          emit(state.copyWith(
            status: BlocStatus.fetched,
            routeModels: routes,
          ));
        } on Exception catch (e) {
          throw Exception(e);
        }
      })),
      (event) => event,
    );
  }

/*
  Future<T> _safeApiCall<T>(
      Future<T> Function() apiCall, {
        required void Function(Exception e, StackTrace stackTrace) onError,
      }) async {
    try {
      return await apiCall();
    } catch (e, stackTrace) {
      onError(e as Exception, stackTrace);
      rethrow; // Optional: Rethrow if you want caller-side handling
    }
  }
*/
}
