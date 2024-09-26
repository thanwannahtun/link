import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/midpoint.dart';

part 'post_create_util_state.dart';

class PostCreateUtilCubit extends Cubit<PostCreateUtilState> {
  PostCreateUtilCubit()
      : super(
          const PostCreateUtilState(
            status: BlocStatus.initial,
            midpoints: [],
            xfiles: [],
          ),
        );

  addMidpoint({required Midpoint midpoint}) {
    if (state.midpoints.length >= 10) {
      emit(
        state.copyWith(
            status: BlocStatus.addFailed,
            error: "You've Got Maximum Midpoint Limit !"),
      );
    } else {
      List<Midpoint> midpoints = state.midpoints;
      midpoints.add(midpoint);
      emit(
        state.copyWith(status: BlocStatus.added, midpoints: midpoints),
      );
    }
  }

  removeMidpoint({required int index}) {
    final midpoints = state.midpoints;
    midpoints.removeAt(index);
    emit(
      state.copyWith(midpoints: midpoints),
    );
  }

  resetMidpoints() => emit(state.copyWith(midpoints: []));

  selectImages({required List<XFile> xfiles}) async {
    if (state.xfiles.length >= 11) {
      emit(state.copyWith(
          status: BlocStatus.limited,
          error: "You've Got Maximum Image Limit !"));
      emit(
        state.copyWith(
          status: BlocStatus.added,
          xfiles: [...state.xfiles],
          // error: "You've Got Maximum Image Limit !",
        ),
      );
    } else {
      emit(
        state.copyWith(
            status: BlocStatus.added, xfiles: [...state.xfiles, ...xfiles]),
      );
    }
  }
}
