import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:link/domain/api_utils/api_error_handler.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/post.dart';
import 'package:link/repositories/post_route.dart';

part 'post_route_state.dart';

class PostRouteCubit extends Cubit<PostRouteState> {
  final _postApiRepo = PostRouteRepo();

  // ignore: prefer_final_fields
  int _page = 1;

  void updatePage({int? value}) {
    _page = value ?? 1;
  }

  PostRouteCubit()
      : super(const PostRouteState(status: BlocStatus.initial, routes: []));

  fetchRoutes({Object? body, Map<String, dynamic>? query}) async {
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
      debugPrint(
          "===================================================================\nError ::  $e  :: staceTrace [[ $stackTrace ]] \n===================================================================");
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
      debugPrint("[[[  Exception :: $e ^ stackTrace :: $s :::: ]]]");

      emit(state.copyWith(
          status: BlocStatus.uploadFailed,
          error: ApiErrorHandler.handle(e).message));
    }
  }
}
