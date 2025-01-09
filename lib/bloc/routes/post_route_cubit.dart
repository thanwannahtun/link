import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:link/domain/api_utils/api_error_handler.dart';
import 'package:link/domain/api_utils/api_query.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/post.dart';
import 'package:link/repositories/post_route.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';

import 'package:stream_transform/stream_transform.dart';

import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'post_route_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> _throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    // return droppable<E>().call(events.throttle(duration), mapper);
    return droppable<E>().call(
        events.throttle(duration).where((event) => event != null), mapper);
  };
}

class PostRouteCubit extends Cubit<PostRouteState> {
  final PostRouteRepo _postApiRepo;

  int _page = 1;

  int get getPage {
    return _page;
  }

  /// clearing ther state's [routeModels]
  ///
  /// useful for scenario such as
  /// [refreshing] the pages
  ///
  void clearRoutes() {
    emit(state.copyWith(routeModels: []));
  }

  /// update the [_page] value
  /// if [value] is ommited , set [_page] to 1
  void updatePage({int? value}) {
    _page = value ?? 1;
  }

  PostRouteCubit({required PostRouteRepo postRouteRepo})
      : _postApiRepo = postRouteRepo,
        super(const PostRouteState());

  uploadNewPost({required Post post, List<File?> files = const []}) async {
    emit(state.copyWith(status: BlocStatus.uploading));
    try {
      Post response =
          await _postApiRepo.uploadNewPost(post: post, files: files);

      List<Post> updatedPosts = List.from(state.routes);
      updatedPosts.add(response);

      emit(state.copyWith(status: BlocStatus.uploaded, routes: updatedPosts));
    } on Exception catch (e, s) {
      _logError(e, s);
      emit(state.copyWith(
          status: BlocStatus.uploadFailed, error: handleErrorMessage(e)));
    }
  }

  Future _getRoutesByCategoryFutureTask({Object? body, APIQuery? query}) async {
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
      _logError(e, stackTrace);
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
      _logError(e, stackTrace);
      emit(state.copyWith(
          routes: [],
          status: BlocStatus.fetchFailed,
          error: handleErrorMessage(e)));
    }
  }

  _logError(Exception error, StackTrace stackTrace) {
    log("""
          <=<=<=<=<=ERROR=>=>=>=>=>
          
          $error
          
          <=<=<=<=<=ERROR=>=>=>=>=>
          <=<=<=<=<=STACKTRACE=>=>=>=>=>
                  
                  $stackTrace
                                    
          <=<=<=<=<=STACKTRACE=>=>=>=>=>
          """);
  }
}
