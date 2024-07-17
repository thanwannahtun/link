import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationStates { A, B, C, D }

class BottomSelectCubit extends Cubit<NavigationStates> {
  BottomSelectCubit() : super(NavigationStates.A);

  navigateTo({required NavigationStates state}) {
    emit(state);
  }
}
