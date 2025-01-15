import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/authentication/authentication_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/models/user.dart';
import 'package:link/ui/utils/context.dart';

import '../../utils/route_list.dart';

const int resendSecond = 60;

class EmailCodeEnterAuthScreen extends StatefulWidget {
  const EmailCodeEnterAuthScreen({super.key});

  @override
  State<EmailCodeEnterAuthScreen> createState() =>
      _EmailCodeEnterAuthScreenState();
}

class _EmailCodeEnterAuthScreenState extends State<EmailCodeEnterAuthScreen> {
  final int _otpLength = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool _initial = true;
  String? _email;

  final ValueNotifier<int> _resendTimer = ValueNotifier(resendSecond);
  final ValueNotifier<bool> _isContinueEnabled = ValueNotifier(false);

  @override
  void didChangeDependencies() {
    if (_initial) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        User? user = ModalRoute.of(context)?.settings.arguments as User?;
        _email = user?.email;
        debugPrint("aguments user = ${user?.toJson()}");
      } else {
        _email = context.read<AuthenticationCubit>().state.user?.email;
      }
      debugPrint(
          "state.user = ${context.read<AuthenticationCubit>().state.user?.toJson()}");

      _initial = false;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _isContinueEnabled.dispose();
    _resendTimer.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    if (_resendTimer.value > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        _resendTimer.value--;
        if (_resendTimer.value > 0) _startResendTimer();
      });
    }
  }

  void _onOtpFieldChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    // Check if all fields are filled
    _isContinueEnabled.value =
        _controllers.every((controller) => controller.text.isNotEmpty);
  }

  String _getOtpCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("rebuild email_code_enter_auth_screen => :: { email = $_email }");
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: BlocListener<AuthenticationCubit, AuthenticationState>(
          bloc: context.read<AuthenticationCubit>(),
          listener: _listener,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Enter 6-digit code',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Your code was emailed to ${_maskEmail(_email ?? "")}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  _otpLength,
                  (index) => SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) => _onOtpFieldChanged(index, value),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _resendCodeValueListenableBuilder(),
              const SizedBox(height: 40),
              _buildContinueButton(context),
            ],
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, AuthenticationState state) {
    if (kDebugMode) {
      print('State changed: ${state.status}');
    }
    if (state.status == AuthenticationStatus.verificationCodeAddedSuccess) {
      /// go to Next screen
      final user = context
          .read<AuthenticationCubit>()
          .state
          .user
          ?.copyWith(email: _email);
      debugPrint("user argument = ${user?.toJson()}");
      context.pushNamed(RouteLists.createPasswordAuthScreen, arguments: user);
    }
    if (state.status == AuthenticationStatus.sendEmailCodeSuccess) {
      /// snack for verification code sent success!
      context.showSnackBar(SnackBar(
        content: Text(state.message ?? "Verification code sent!"),
      ));
    }

    /// FAILED LISTENERS
    if (state.status == AuthenticationStatus.verificationCodeAddFailed) {
      if (kDebugMode) {
        print(state.error);
      }

      /// snack for verification code sent success!
      context.showSnackBar(SnackBar(
        content: Text(state.message ?? "Invalid Code!!"),
      ));
    }
  }

  Widget _buildContinueButton(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _isContinueEnabled,
        builder: (BuildContext context, value, Widget? child) {
          return ElevatedButton(
            onPressed: value
                ? () {
                    final otpCode = _getOtpCode();
                    if (kDebugMode) {
                      print('OTP Entered: $otpCode');
                    }
                    // Add your OTP validation logic here
                    context
                        .read<AuthenticationCubit>()
                        .verifyCode(email: _email ?? "", code: otpCode);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: value ? Colors.white : Colors.amber,
              backgroundColor: value ? Colors.blue : Colors.black,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Continue'),
          );
        });
  }

  ValueListenableBuilder<int> _resendCodeValueListenableBuilder() {
    return ValueListenableBuilder(
        valueListenable: _resendTimer,
        builder: (BuildContext context, value, Widget? child) {
          return TextButton(
            onPressed: value == 0
                ? () {
                    _resendTimer.value = resendSecond;
                    _startResendTimer();

                    /// Add resend logic here
                    context
                        .read<AuthenticationCubit>()
                        .sendCode(email: _email ?? "", resend: true);
                  }
                : null,
            child: Text(
              value == 0 ? 'Resend code' : 'Resend code in $value seconds',
              style: TextStyle(color: value == 0 ? Colors.blue : Colors.grey),
            ),
          );
        });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.keyboard_arrow_left_rounded),
      ),
      backgroundColor: Colors.transparent,
      title: const Text("Sign up"),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () {
            // Navigate to Help screen
          },
          child: const Text('Help', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email; // Invalid email, return as is

    final username = parts[0];
    final domain = parts[1];

    // Mask the username: keep first and last characters visible
    final maskedUsername = username.length > 2
        ? '${username[0]}***${username[username.length - 1]}'
        : username.replaceAll(
            RegExp(r"."), '*'); // Mask all characters for short usernames

    return '$maskedUsername@$domain';
  }
}
