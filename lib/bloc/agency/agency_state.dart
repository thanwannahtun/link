part of 'agency_cubit.dart';

class AgencyState extends Equatable {
  const AgencyState({required this.status, required this.agencies, this.error});

  final BlocStatus status;
  final List<Agency> agencies;
  final String? error;

  AgencyState copyWith(
      {BlocStatus? status, List<Agency>? agencies, String? error}) {
    return AgencyState(
        status: status ?? this.status,
        agencies: agencies ?? this.agencies,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [status, agencies, error];

  @override
  String toString() {
    return 'AgencyState{status=$status, agencies=$agencies, error=$error}';
  }
}
