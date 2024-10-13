part of 'agency_cubit.dart';

class AgencyState extends Equatable {
  const AgencyState(
      {required this.status,
      required this.agencies,
      this.error,
      this.posts = const <Post>[]});

  final BlocStatus status;
  final List<Agency> agencies;
  final String? error;
  final List<Post>? posts;

  AgencyState copyWith(
      {BlocStatus? status,
      List<Agency>? agencies,
      String? error,
      List<Post>? posts}) {
    return AgencyState(
        status: status ?? this.status,
        agencies: agencies ?? this.agencies,
        posts: posts ?? this.posts,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [status, agencies, error, posts];

  @override
  String toString() {
    return 'AgencyState{status=$status, agencies=$agencies,posts=$posts error=$error}';
  }
}
