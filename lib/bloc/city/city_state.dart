part of 'city_cubit.dart';

class CityState extends Equatable {
  const CityState({required this.cities, required this.status, this.error});

  final List<City> cities;
  final BlocStatus status;
  final String? error;
  CityState copyWith(
      {List<City>? cities, BlocStatus? status, ValueGetter<String?>? error}) {
    return CityState(
        cities: cities ?? this.cities,
        status: status ?? this.status,
        error: error != null ? error() : this.error);
  }

  @override
  List<Object?> get props => [cities, status, error];
}
