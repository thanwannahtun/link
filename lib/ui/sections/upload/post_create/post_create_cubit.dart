import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';

import '../route_array_upload/route_model/route_model.dart';

part 'post_create_state.dart';

class PostCreateCubit extends Cubit<PostCreateState> {
  PostCreateCubit()
      : super(
          const PostCreateState(
            status: BlocStatus.initial,
            routes: [],
          ),
        );

  addRoute({required RouteModel route}) {
    if (state.routes.length >= 5) {
      emit(
        state.copyWith(
            status: BlocStatus.addFailed,
            error: "You've Got Maximum Route Limit !"),
      );
    } else {
      List<RouteModel> routes =
          List.from(state.routes); // Assuming state holds the list
      routes.add(route);
      emit(
        state.copyWith(status: BlocStatus.added, routes: routes),
      );
    }
  }

  updateOrDeleteRoute({required int index, RouteModel? routeToUpdate}) {
    List<RouteModel> routes = List.from(state.routes);
    if (routeToUpdate != null) {
      routes[index] = routeToUpdate;
      // final updRoutes = List<Routemodel>.from(routes);
      emit(state.copyWith(routes: routes));
    } else {
      routes.removeAt(index);
      emit(state.copyWith(routes: routes));
    }
  }
}
