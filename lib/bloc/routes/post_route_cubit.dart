import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:link/domain/api_utils/api_error_handler.dart';
import 'package:link/domain/bloc_utils/bloc_crud_status.dart';
import 'package:link/models/post_route.dart';
import 'package:link/repositories/post_route.dart';

part 'post_route_state.dart';

class PostRouteCubit extends Cubit<PostRouteState> {
  PostRouteCubit()
      : super(const PostRouteState(status: BlocStatus.initial, routes: []));

  fetchRoutes() async {
    emit(state.copyWith(status: BlocStatus.doing));
    try {
      List<PostRoute> posts = await PostRouteRepo().fetchRoutes();
      emit(state.copyWith(status: BlocStatus.done, routes: posts));
    } on DioException catch (e) {
      print("DioException ::  $e");

      emit(state.copyWith(
          status: BlocStatus.doNot, error: ApiErrorHandler.handle(e).message));
    } catch (e, stackTrace) {
      print("Error ::  $e  :: staceTrace [[ $stackTrace ]] ");
      emit(state.copyWith(status: BlocStatus.doNot, error: e.toString()));
    }
  }
}
