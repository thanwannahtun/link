import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:link/domain/api_utils/api_error_handler.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/agency.dart';
import 'package:link/repositories/agency.dart';

part 'agency_state.dart';

class AgencyCubit extends Cubit<AgencyState> {
  AgencyCubit()
      : super(const AgencyState(status: BlocStatus.initial, agencies: []));

  fetAgencies({String? agencyId}) async {
    emit(state.copyWith(status: BlocStatus.fetching));
    try {
      List<Agency> agencies = await AgencyRepo().fetchAgencies(id: agencyId);
      // if (agencyId != null) {
      emit(state.copyWith(status: BlocStatus.fetched, agencies: agencies));
      // }
    } on Exception catch (e) {
      emit(state.copyWith(
          status: BlocStatus.fetchFailed,
          error: ApiErrorHandler.handle(e).message));
    }
  }
}
