part of 'post_create_util_cubit.dart';

class PostCreateUtilState extends Equatable {
  const PostCreateUtilState(
      {required this.status,
      required this.midpoints,
      required this.xfiles,
      this.error});

  final BlocStatus status;
  final String? error;
  final List<Midpoint> midpoints;
  final List<XFile> xfiles;

  PostCreateUtilState copyWith(
      {BlocStatus? status,
      String? error,
      List<Midpoint>? midpoints,
      List<XFile>? xfiles}) {
    return PostCreateUtilState(
        status: status ?? this.status,
        error: error ?? this.error,
        midpoints: midpoints ?? this.midpoints,
        xfiles: xfiles ?? this.xfiles);
  }

  @override
  List<Object?> get props => [status, error, midpoints, xfiles];
}
