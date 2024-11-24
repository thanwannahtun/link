import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';

import '../../../bloc/authentication/authentication_cubit.dart';
import '../../../core/utils/app_insets.dart';
import '../../utils/route_list.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final ValueNotifier<bool> _isContinueEnabled = ValueNotifier(false);

  late final _firstNameController;
  late final _lastNameController;
  late final _passwordController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _isContinueEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppInsets.inset20, vertical: AppInsets.inset30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Create password",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppInsets.inset15),
            _buildFormField(context,
                labelText: "First Name", controller: _firstNameController),
            const SizedBox(height: AppInsets.inset15),
            const SizedBox(height: AppInsets.inset15),
            _buildFormField(context,
                labelText: "Last Name", controller: _lastNameController),
            const SizedBox(height: AppInsets.inset15),
            const SizedBox(height: AppInsets.inset15),
            _buildFormField(context,
                labelText: "Enter password", controller: _passwordController),
            const SizedBox(height: AppInsets.inset15),
            Text(
              "Your password must have",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: context.greyColor),
            ),
            Text(
              "6-20 characters",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: context.greyFilled),
            ),
            const SizedBox(height: AppInsets.inset15),
            const SizedBox(height: AppInsets.inset15),
            _buildContinueButton(context),
          ],
        ),
      ),
    ));
  }

  Widget _buildContinueButton(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _isContinueEnabled,
        builder: (BuildContext context, value, Widget? child) {
          return ElevatedButton(
            onPressed: value
                ? () {
                    // final otpCode = _getOtpCode();
                    if (kDebugMode) {
                      print('Signing up... ');
                    }
                    // Add your OTP validation logic here
                    context.read<AuthenticationCubit>();
                    context.pushNamed(RouteLists.enterDateOfBirthScreen);
                  }
                : null,
            child: const Text('Continue'),
          );
        });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.keyboard_arrow_left_rounded)),
      backgroundColor: Colors.transparent,
      title: const Text("sign in"),
      centerTitle: true,
    );
  }

  Widget _buildFormField(BuildContext context,
      {String? hintText,
      String? labelText,
      required TextEditingController controller,
      void Function(String)? onChanged,
      String? Function(String?)? validator}) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.greyColor,
              ),
          labelText: labelText,
          border: InputBorder.none,
          fillColor: Theme.of(context).cardColor,
          filled: true),
      onChanged: onChanged,
      // onEditingComplete: onEditingComplete,
    );
  }
}
