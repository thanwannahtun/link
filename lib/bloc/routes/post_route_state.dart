part of 'post_route_cubit.dart';

class PostRouteState extends Equatable {
  const PostRouteState({
    required this.status,
    required this.routes,
    this.error,
    required this.routeModels,
  });

  final BlocStatus status;
  final List<Post> routes;
  final List<RouteModel> routeModels;
  final String? error;

  PostRouteState copyWith(
      {BlocStatus? status,
      List<Post>? routes,
      List<RouteModel>? routeModels,
      String? error}) {
    return PostRouteState(
        status: status ?? this.status,
        routes: routes ?? this.routes,
        routeModels: routeModels ?? this.routeModels,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [status, routes, error, routeModels];

  @override
  String toString() {
    return 'RouteState{status=$status, routes=$routes, error=$error}, routeModels=$routeModels,';
  }
}
