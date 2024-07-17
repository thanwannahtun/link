import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:link/domain/api_utils/api_error_handler.dart';
import 'package:link/domain/bloc_utils/bloc_crud_status.dart';
import 'package:link/models/agency.dart';
import 'package:link/repositories/agency.dart';

part 'agency_state.dart';

class AgencyCubit extends Cubit<AgencyState> {
  AgencyCubit()
      : super(const AgencyState(status: BlocStatus.initial, agencies: []));

  fetAgencies({int? agencyId}) async {
    emit(state.copyWith(status: BlocStatus.doing));
    try {
      List<Agency> agencies = await AgencyRepo().fetchAgencies(id: agencyId);
      // if (agencyId != null) {
      emit(state.copyWith(status: BlocStatus.done, agencies: agencies));
      // }
    } on DioException catch (e) {
      emit(state.copyWith(
          status: BlocStatus.doNot, error: ApiErrorHandler.handle(e).message));
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.doNot, error: e.toString()));
    }
  }
}
