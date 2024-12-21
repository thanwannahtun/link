import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/models/user.dart';

import '../../../bloc/authentication/authentication_cubit.dart';
import '../../utils/route_list.dart';

class CreatePasswordAuthScreen extends StatefulWidget {
  const CreatePasswordAuthScreen({super.key});

  @override
  State<CreatePasswordAuthScreen> createState() =>
      _CreatePasswordAuthScreenState();
}

class _CreatePasswordAuthScreenState extends State<CreatePasswordAuthScreen> {
  final ValueNotifier<bool> _isContinueEnabled = ValueNotifier(false);
  final ValueNotifier<bool> _obscureText = ValueNotifier(true);
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _initial = true;
  String? _email;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateFields);
    _lastNameController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _obscureText.dispose();
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
    final isValid = _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        (_passwordController.text.isNotEmpty &&
            _passwordController.text.trim().length > 10);
    _isContinueEnabled.value = isValid;
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("rebuild createdPasswordScreen => :: { email = $_email }");
    }
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: _listener,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fill in your details to create your account.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                hint: 'Enter first name',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _lastNameController,
                label: 'Last Name',
                hint: 'Enter last name (optional)',
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder(
                  valueListenable: _obscureText,
                  builder: (BuildContext context, value, Widget? child) {
                    return _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Create your password',
                        obscureText: value,
                        suffixIcon: ObscurePasswordEye(
                          isClosed: value,
                          onClicked: (value) {
                            _obscureText.value = value;
                          },
                        ));
                  }),
              const SizedBox(height: 40),
              _buildContinueButton(context),
            ],
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, AuthenticationState state) {
    if (state.status == AuthenticationStatus.signUpSuccess) {
      /// Navigate to the next screen
      final user = state.user?.copyWith(email: _email);
      if (kDebugMode) {
        print("user argument = ${user?.toJson()}");
      }

      context.pushNamed(RouteLists.enterDateOfBirthAuthScreen, arguments: user);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Theme.of(context).cardColor,
          filled: true,
          suffixIcon: suffixIcon,
          labelText: label,
          hintText: hint,
          hintStyle: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: context.greyColor)),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isContinueEnabled,
      builder: (context, isEnabled, child) {
        return ElevatedButton(
          onPressed: isEnabled
              ? () {
                  final firstName = _firstNameController.text;
                  final lastName = _lastNameController.text;
                  final password = _passwordController.text;

                  context.read<AuthenticationCubit>().enterNameAndPassword(
                      firstName: firstName,
                      password: password,
                      lastName: lastName);

                  if (kDebugMode) {
                    print(
                        'firstName: $firstName, lastName: $lastName, password: $password');
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
      title: const Text("Sign Up"),
      centerTitle: true,
    );
  }
}

class ObscurePasswordEye extends StatefulWidget {
  const ObscurePasswordEye({super.key, this.onClicked, this.isClosed = true});

  final void Function(bool value)? onClicked;
  final bool isClosed;

  @override
  State<ObscurePasswordEye> createState() => _ObscurePasswordEyeState();
}

class _ObscurePasswordEyeState extends State<ObscurePasswordEye> {
  late bool isClosed;

  @override
  void initState() {
    isClosed = widget.isClosed;
    widget.onClicked?.call(isClosed);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          isClosed = !isClosed;
          widget.onClicked?.call(isClosed);
        },
        child: Icon(
          isClosed ? Icons.close : Icons.remove_red_eye_outlined,
          size: 18,
        ));
  }
}
