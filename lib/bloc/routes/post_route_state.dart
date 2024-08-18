part of 'post_route_cubit.dart';

class PostRouteState extends Equatable {
  const PostRouteState(
      {required this.status, required this.routes, this.error});

  final BlocStatus status;
  final List<Post> routes;
  final String? error;

  PostRouteState copyWith(
      {BlocStatus? status, List<Post>? routes, String? error}) {
    return PostRouteState(
        status: status ?? this.status,
        routes: routes ?? this.routes,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [status, routes, error];

  @override
  String toString() {
    return 'RouteState{status=$status, routes=$routes, error=$error}';
  }
}
