part of 'authentication_cubit.dart';

enum AuthenticationStatus {
  initial,
  singingUp,
  signUpSuccess,
  signUpFailed,
  signIning,
  signInSuccess,
  signInFailed,
  singingOut,
  signingOutFailed,
  signingOutSuccess,
  sendEmailCodeSuccess,
  sendEmailCodeFailed,
  sendingEmailCode,
  verificationCodeAddedSuccess,
  verificationCodeAdding,
  verificationCodeAddFailed,
}

class AuthenticationState extends Equatable {
  const AuthenticationState(
      {required this.status, this.error, this.message, this.user});

  final AuthenticationStatus status;
  final String? error;
  final String? message;
  final User? user;

  AuthenticationState copyWith(
      {AuthenticationStatus? status,
      String? error,
      String? message,
      User? user}) {
    return AuthenticationState(
        status: status ?? this.status,
        error: error ?? error,
        user: user ?? this.user,
        message: message ?? message);
  }

  @override
  List<Object?> get props => [status, error, message, user];

  @override
  String toString() {
    return 'AuthenticationState{status=$status, error=$error, message=$message, user=$user}';
  }
}
