import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationStates { home, explore, activity, profile }

class BottomSelectCubit extends Cubit<NavigationStates> {
  BottomSelectCubit() : super(NavigationStates.home);

  navigateTo({required NavigationStates state}) {
    emit(state);
  }
}
