import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'states_state.dart';

class StatesCubit extends Cubit<StatesState> {
  StatesCubit() : super(StatesInitial());
}
