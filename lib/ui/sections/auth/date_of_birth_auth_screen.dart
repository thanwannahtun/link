import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/authentication/authentication_cubit.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/ui/utils/context.dart';
import 'package:link/ui/utils/route_list.dart';

import '../../../models/user.dart';

class DateOfBirthAuthScreen extends StatefulWidget {
  const DateOfBirthAuthScreen({super.key});

  @override
  State<DateOfBirthAuthScreen> createState() => _DateOfBirthAuthScreenState();
}

class _DateOfBirthAuthScreenState extends State<DateOfBirthAuthScreen> {
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final ValueNotifier<bool> _isContinueEnabled = ValueNotifier(false);

  bool _initial = true;
  String? _email;

  @override
  void initState() {
    super.initState();
    _dayController.addListener(_validateFields);
    _monthController.addListener(_validateFields);
    _yearController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_initial) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        User? user = ModalRoute.of(context)?.settings.arguments as User?;
        _email = user?.email;
        print("aguments user = ${user?.toJson()}");
      } else {
        _email = context.read<AuthenticationCubit>().state.user?.email;
      }
      print(
          "state.user = ${context.read<AuthenticationCubit>().state.user?.toJson()}");
      _initial = false;
    }
    super.didChangeDependencies();
  }

  void _validateFields() {
    final day = int.tryParse(_dayController.text) ?? 0;
    final month = int.tryParse(_monthController.text) ?? 0;
    final year = int.tryParse(_yearController.text) ?? 0;

    final isValid = _isValidDate(day, month, year) && _isValidAge(year);
    _isContinueEnabled.value = isValid;
  }

  bool _isValidDate(int day, int month, int year) {
    if (year < 1900 || month < 1 || month > 12 || day < 1) return false;

    final daysInMonth = <int>[
      31,
      28 + (isLeapYear(year) ? 1 : 0),
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31,
    ];
    return day <= daysInMonth[month - 1];
  }

  bool isLeapYear(int year) =>
      (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

  bool _isValidAge(int year) {
    final currentYear = DateTime.now().year;
    return (currentYear - year) >= 18;
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("rebuild date_of_birth_auth_screen => :: { email = $_email }");
    }
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state.status == AuthenticationStatus.signUpSuccess) {
          context.pushNamed(RouteLists.app);

          Future.delayed(const Duration(seconds: 1)).then(
            (value) => mounted
                ? context.showSnackBar(const SnackBar(
                    content: Text("Account successfully created!")))
                : null,
          );
        }
        if (state.status == AuthenticationStatus.signUpFailed) {
          if (kDebugMode) {
            print(state.error ?? "ERROR (SIGNUP FAILED)!");
          }
          context.showSnackBar(SnackBar(content: Text(state.message ?? "")));
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Enter Your Date of Birth',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'To continue, enter your birthdate. You must be at least 18 years old.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildTextField(
                    controller: _dayController,
                    hint: 'DD',
                    maxLength: 2,
                  ),
                  const SizedBox(width: 8),
                  _buildTextField(
                    controller: _monthController,
                    hint: 'MM',
                    maxLength: 2,
                  ),
                  const SizedBox(width: 8),
                  _buildTextField(
                    controller: _yearController,
                    hint: 'YYYY',
                    maxLength: 4,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildContinueButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required int maxLength,
  }) {
    return Expanded(
      child: TextField(
        // style: TextStyle(),
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: maxLength,
        decoration: InputDecoration(
            counterText: '',
            hintText: hint,
            border: InputBorder.none,
            fillColor: Theme.of(context).cardColor,
            filled: true,
            hintStyle: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: context.greyColor)),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isContinueEnabled,
      builder: (context, isEnabled, child) {
        return ElevatedButton(
          onPressed: isEnabled
              ? () {
                  final day = int.parse(_dayController.text);
                  final month = int.parse(_monthController.text);
                  final year = int.parse(_yearController.text);

                  final dob = DateTime(year, month, day);
                  if (dob.isBefore(DateTime.now()
                      .subtract(const Duration(days: 365 * 18)))) {
                    final user = context.read<AuthenticationCubit>().state.user;
                    context
                        .read<AuthenticationCubit>()
                        .signUpUser(user: user!.copyWith(dob: dob));
                  } else {
                    context.showSnackBar(
                      const SnackBar(
                          content: Text('You must be at least 18 years old!')),
                    );
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: isEnabled ? Colors.blue : Colors.grey[400],
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('Continue'),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.keyboard_arrow_left_rounded),
      ),
      backgroundColor: Colors.transparent,
      title: const Text('Sign Up'),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () {
            // Skip action logic
            if (kDebugMode) {
              print("Skip to Next");
            }
            final user = context.read<AuthenticationCubit>().state.user;
            context.read<AuthenticationCubit>().signUpUser(user: user!);
          },
          child: const Text('Skip', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
