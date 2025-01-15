import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/domain/api_utils/api_error_handler.dart';
import 'package:link/models/user.dart';
import 'package:link/repositories/authentication.dart';
import 'package:link/repositories/user.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit()
      : super(const AuthenticationState(status: AuthenticationStatus.initial));

  // final _userRepo = UserRepo();
  final _authRepo = AuthenticationRepo();

  signUpUser({required User user}) async {
    emit(state.copyWith(
      status: AuthenticationStatus.singingUp,
      message: "Signing Up.../n Please Wait a moment!",
    ));
    try {
      User appUser = await AuthenticationRepo().signUpUser(user: user);

      await UserRepo().insertUser(appUser);

      emit(state.copyWith(
          status: AuthenticationStatus.signUpSuccess,
          message: "Successfully Signed Up!",
          user: appUser));
    } on DioException catch (e) {
      emit(state.copyWith(
          status: AuthenticationStatus.signUpFailed,
          error: ApiErrorHandler.handle(e).message,
          message: "Sign Up Failed due to Network Connection!"));
    } catch (e) {
      emit(state.copyWith(
          status: AuthenticationStatus.signUpFailed,
          error: e.toString(),
          message: "SignUp Failed!"));
    }
  }

  signInUser({required User user}) async {
    emit(state.copyWith(
        status: AuthenticationStatus.signIning, message: "Signing In..."));
    try {
      User appUser = await AuthenticationRepo().signInUser(user: user);

      await UserRepo().insertUser(appUser);

      emit(state.copyWith(
        status: AuthenticationStatus.signInSuccess,
        user: appUser,
        message: "Successfully Signed In!",
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
          status: AuthenticationStatus.signInFailed,
          error: ApiErrorHandler.handle(e).message,
          message: "Sign Ip Failed due to Network Connection!"));
    } catch (e) {
      emit(state.copyWith(
          status: AuthenticationStatus.signInFailed,
          error: e.toString(),
          message: "Sign In Failed!"));
    }
  }

  logOutUser({required User user}) async {
    emit(state.copyWith(
        status: AuthenticationStatus.singingOut, message: "Loging Out..."));
    try {
      /// notice delete all user data
      await UserRepo().deleteUser();

      emit(state.copyWith(
        status: AuthenticationStatus.signingOutSuccess,
        message: "Good Bye!",
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: AuthenticationStatus.signingOutFailed,
        error: ApiErrorHandler.handle(e).message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthenticationStatus.signingOutFailed,
        error: e.toString(),
      ));
    }
  }

  changeState(
      {AuthenticationStatus? status,
      String? error,
      String? message,
      User? user}) {
    emit(state.copyWith(
        status: status, error: error, user: user, message: message));
  }

  sendCode({required String email, bool resend = false}) async {
    try {
      Response response =
          await _authRepo.sendCode(email: email, resend: resend);
      if (response.statusCode == 200) {
        emit(state.copyWith(
            status: AuthenticationStatus.sendEmailCodeSuccess,
            message: "Verification code sent!",
            user: state.user?.copyWith(email: email)));
        return;
      } else {
        emit(state.copyWith(
            status: AuthenticationStatus.sendEmailCodeFailed,
            error: "Something went wrong!",
            message: response.data["message"] ?? ""));
      }
    } on Exception catch (e, s) {
      debugPrint("""====== <Error> >
            (error) - $e
            ====== 
            (staceTrace) - $s 
            ====== <Error/>""");

      emit(state.copyWith(
          status: AuthenticationStatus.sendEmailCodeFailed,
          error: handleErrorMessage(e)));
    }
  }

  verifyCode({required String email, required String code}) async {
    try {
      Response response = await _authRepo.verifyCode(email: email, code: code);
      if (response.statusCode == 200) {
        emit(state.copyWith(
            status: AuthenticationStatus.verificationCodeAddedSuccess,
            message: "Success",
            user: state.user?.copyWith(email: email)));
        return;
      } else {
        emit(state.copyWith(
            status: AuthenticationStatus.verificationCodeAddFailed,
            error: "Something went wrong!",
            message: response.data["message"] ?? "Invalid Code!"));
      }
    } on Exception catch (e, s) {
      debugPrint("""====== <Error> >
            (error) - $e
            ====== 
            (staceTrace) - $s 
            ====== <Error/>""");

      emit(state.copyWith(
          status: AuthenticationStatus.verificationCodeAddFailed,
          error: handleErrorMessage(e),
          message: "Invalid Code!"));
    }
  }

  enterNameAndPassword(
      {required String firstName,
      String? lastName,
      required String password}) async {
    emit(state.copyWith(
        status: AuthenticationStatus.signUpSuccess,
        user: state.user?.copyWith(
            firstName: firstName, lastName: lastName, password: password)));
  }
}
