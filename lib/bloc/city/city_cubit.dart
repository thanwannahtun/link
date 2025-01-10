import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:link/domain/api_utils/api_error_handler.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/app.dart';
import 'package:link/models/city.dart';
import 'package:link/repositories/city_repo.dart';

part 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  // final _cityRepo = CityRepo();
  late final CityRepo _cityRepo;

  CityCubit({required CityRepo cityRepo})
      : super(const CityState(cities: [], status: BlocStatus.initial)) {
    _cityRepo = cityRepo;
  }

  FutureOr<void> fetchCities() async {
    emit(state.copyWith(status: BlocStatus.fetching));
    try {
      List<City> cities = [];
      if (App.cities.isEmpty) {
        cities = await _cityRepo.fetchCities();
        App.cities = cities;
      } else {
        cities = App.cities;
      }

      cities.sort(
        (a, b) => (a.name ?? "").compareTo(b.name ?? ""),
      );

      emit(state.copyWith(status: BlocStatus.fetched, cities: cities));
    } on Exception catch (e) {
      emit(state.copyWith(
          status: BlocStatus.fetchFailed,
          cities: [],
          error: () => ApiErrorHandler.handle(e).message));
    }
  }
}
