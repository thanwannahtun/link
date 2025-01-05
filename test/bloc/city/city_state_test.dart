import 'package:flutter_test/flutter_test.dart';
import 'package:link/bloc/city/city_cubit.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/city.dart';

void main() {
  group(CityState, () {
    test(
      "support value comparisons",
      () async {
        // Arrange
        const initialState = CityState(cities: [], status: BlocStatus.initial);
        final fetchedState = CityState(
            cities: [City(name: "City1", id: "1")], status: BlocStatus.fetched);
        const failedState =
            CityState(cities: [], status: BlocStatus.fetchFailed);

        // Assert
        expect(initialState, initialState);
        expect(fetchedState, fetchedState);
        expect(failedState, failedState);
      },
    );
  });
}
