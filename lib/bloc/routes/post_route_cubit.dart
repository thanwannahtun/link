import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:link/domain/api_utils/api_error_handler.dart';
import 'package:link/domain/bloc_utils/bloc_crud_status.dart';
import 'package:link/models/post.dart';
import 'package:link/repositories/post_route.dart';

part 'post_route_state.dart';

class PostRouteCubit extends Cubit<PostRouteState> {
  final _postApiRepo = PostRouteRepo();
  PostRouteCubit()
      : super(const PostRouteState(status: BlocStatus.initial, routes: []));

  fetchRoutes() async {
    emit(state.copyWith(status: BlocStatus.doing));
    try {
      List<Post> posts = await _postApiRepo.fetchRoutes();
      emit(state.copyWith(status: BlocStatus.done, routes: posts));
    } on DioException catch (e) {
      debugPrint("DioException ::  $e");

      emit(state.copyWith(
          status: BlocStatus.doNot, error: ApiErrorHandler.handle(e).message));
    } catch (e, stackTrace) {
      debugPrint("Error ::  $e  :: staceTrace [[ $stackTrace ]] ");
      emit(state.copyWith(status: BlocStatus.doNot, error: e.toString()));
    }
  }

  uploadNewPost({required Post post, List<File?> files = const []}) async {
    emit(state.copyWith(status: BlocStatus.doing));
    try {
      Post response =
          await _postApiRepo.uploadNewPost(post: post, files: files);
      emit(state.copyWith(
          status: BlocStatus.done, routes: [...state.routes, response]));
    } on Exception catch (e, s) {
      debugPrint("[[[  Exception :: $e ^ stackTrace :: $s :::: ]]]");

      emit(state.copyWith(
          status: BlocStatus.doNot, error: ApiErrorHandler.handle(e).message));
    }
  }
}
