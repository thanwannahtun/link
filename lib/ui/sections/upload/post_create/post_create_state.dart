part of 'post_create_cubit.dart';

class PostCreateState extends Equatable {
  const PostCreateState(
      {required this.status, required this.routes, this.error});

  final BlocStatus status;
  final String? error;
  final List<RouteModel> routes;

  PostCreateState copyWith({
    BlocStatus? status,
    String? error,
    List<RouteModel>? routes,
  }) {
    return PostCreateState(
      status: status ?? this.status,
      error: error ?? this.error,
      routes: routes ?? this.routes,
    );
  }

  @override
  String toString() {
    return 'PostCreateState{status: $status, error: $error, routes: ${routes.map((r) => r.toString())}}';
  }

  @override
  List<Object?> get props => [status, error, routes];
}
