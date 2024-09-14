import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/domain/api_utils/api_error_handler.dart';
import 'package:link/models/user.dart';
import 'package:link/repositories/authentication.dart';
import 'package:link/repositories/user.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit()
      : super(const AuthenticationState(status: AutnenticationStatus.initial));
  signUpUser({required User user}) async {
    emit(state.copyWith(
      status: AutnenticationStatus.singingUp,
      message: "Signing Up.../n Please Wait a moment!",
    ));
    try {
      User appUser = await AuthenticationRepo().signUpUser(user: user);

      await UserRepo().insertUser(appUser);

      emit(state.copyWith(
          status: AutnenticationStatus.signUpSuccess,
          message: "Successfully Signed Up!",
          user: appUser));
    } on DioException catch (e) {
      emit(state.copyWith(
          status: AutnenticationStatus.signUpFailed,
          error: ApiErrorHandler.handle(e).message,
          message: "Sign Up Failed due to Network Connection!"));
    } catch (e) {
      emit(state.copyWith(
          status: AutnenticationStatus.signUpFailed,
          error: e.toString(),
          message: "SignUp Failed!"));
    }
  }

  signInUser({required User user}) async {
    emit(state.copyWith(
        status: AutnenticationStatus.signIning, message: "Signing In..."));
    try {
      User appUser = await AuthenticationRepo().signInUser(user: user);

      await UserRepo().insertUser(appUser);

      emit(state.copyWith(
        status: AutnenticationStatus.signInSuccess,
        user: appUser,
        message: "Successfully Signed In!",
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
          status: AutnenticationStatus.signInFailed,
          error: ApiErrorHandler.handle(e).message,
          message: "Sign Ip Failed due to Network Connection!"));
    } catch (e) {
      emit(state.copyWith(
          status: AutnenticationStatus.signInFailed,
          error: e.toString(),
          message: "Sign In Failed!"));
    }
  }

  logOutUser({required User user}) async {
    emit(state.copyWith(
        status: AutnenticationStatus.singingOut, message: "Loging Out..."));
    try {
      /// notice delete all user data
      await UserRepo().deleteUser();

      emit(state.copyWith(
        status: AutnenticationStatus.signingOutSuccess,
        message: "Good Bye!",
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: AutnenticationStatus.signingOutFailed,
        error: ApiErrorHandler.handle(e).message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AutnenticationStatus.signingOutFailed,
        error: e.toString(),
      ));
    }
  }
}
