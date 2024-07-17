import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit() : super(CityInitial());
}
