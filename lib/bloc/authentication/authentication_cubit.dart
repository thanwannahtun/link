import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/domain/api_utils/api_error_handler.dart';
import 'package:link/domain/bloc_utils/bloc_crud_status.dart';
import 'package:link/models/user.dart';
import 'package:link/repositories/authentication.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit()
      : super(const AuthenticationState(status: BlocStatus.initial));
  signUpUser({required User user}) async {
    emit(state.copyWith(
      status: BlocStatus.doing,
      message: "Signing Up.../n Please Wait a moment!",
    ));
    try {
      User appUser = await AuthenticationRepo().signUpUser(user: user);
      emit(state.copyWith(
          status: BlocStatus.done,
          message: "Successfully Signed Up!",
          user: appUser));
    } on DioException catch (e) {
      emit(state.copyWith(
          status: BlocStatus.doNot,
          error: ApiErrorHandler.handle(e).message,
          message: "Sign Up Failed due to Network Connection!"));
    } catch (e) {
      emit(state.copyWith(
          status: BlocStatus.doNot,
          error: e.toString(),
          message: "SignUp Failed!"));
    }
  }

  signInUser({required User user}) async {
    emit(state.copyWith(status: BlocStatus.doing, message: "Signing In..."));
    try {
      User appUser = await AuthenticationRepo().signInUser(user: user);
      emit(state.copyWith(
        status: BlocStatus.done,
        user: appUser,
        message: "Successfully Signed Ip!",
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
          status: BlocStatus.doNot,
          error: ApiErrorHandler.handle(e).message,
          message: "Sign Ip Failed due to Network Connection!"));
    } catch (e) {
      emit(state.copyWith(
          status: BlocStatus.doNot,
          error: e.toString(),
          message: "Sign In Failed!"));
    }
  }
}
