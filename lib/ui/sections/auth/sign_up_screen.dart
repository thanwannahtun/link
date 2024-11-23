import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/authentication/authentication_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/ui/utils/context.dart';
import 'package:link/ui/widget_extension.dart';

import '../../utils/route_list.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final ValueNotifier<bool> _isValidEmail = ValueNotifier(false);
  final ValueNotifier<bool> isAllowedNotifier = ValueNotifier(false);

  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild SignUpScreen");
    return SafeArea(
        child: Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: AppInsets.inset15, vertical: AppInsets.inset25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppInsets.inset15),
                const Text("What's your email address?"),
                const SizedBox(height: AppInsets.inset15),
                _buildFormField(context,
                    labelText: "Enter email address",
                    controller: _emailController),
                const SizedBox(height: AppInsets.inset15),
                BlocConsumer<AuthenticationCubit, AuthenticationState>(
                  builder: _authBuilder,
                  listener: _authListener,
                ),
                const SizedBox(height: AppInsets.inset15),
                _PermissionAccessCheckBox(onValueChange: (value) {
                  isAllowedNotifier.value = value;
                  // isAllowed.value = !isAllowed.value;
                })
              ],
            ),
          ).expanded(),
          _footer(context),
        ],
      ),
    ));
  }

  void _authListener(BuildContext context, AuthenticationState state) {
    if (state.status == AuthenticationStatus.sendEmailCodeSuccess) {
      context.pushNamed(RouteLists.emailCodeEnterScreen,
          arguments: {"email": _emailController.text});
      final cubit = context.read<AuthenticationCubit>();
      Future.delayed(const Duration(microseconds: 100)).then(
        (value) {
          cubit.changeState(status: AuthenticationStatus.initial);
        },
      );
      context.showSnackBar(SnackBar(
        content: Text(state.message ?? "Code sent to ${_emailController.text}"),
      ));
    }
    if (state.status == AuthenticationStatus.sendEmailCodeFailed) {
      context.showSnackBar(SnackBar(
        content: Text(state.message ?? "Internet Connection Error!"),
      ));
    }
  }

  Widget _authBuilder(BuildContext context, AuthenticationState state) {
    return ValueListenableBuilder(
        valueListenable: _isValidEmail,
        builder: (BuildContext context, validEmail, Widget? child) {
          return ValueListenableBuilder(
              valueListenable: isAllowedNotifier,
              builder: (BuildContext context, bool isAllowed, Widget? child) {
                return ElevatedButton(
                    onPressed: (validEmail && isAllowed)
                        ? () {
                            context
                                .read<AuthenticationCubit>()
                                .sendCode(email: _emailController.text);
                          }
                        : null,
                    child: const Text("Continue"));
              });
        });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.keyboard_arrow_left_rounded)),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _footer(BuildContext context) {
    return ListTile(
      title: Center(
        child: GestureDetector(
          onTap: () => context.pushNamed(RouteLists.signInWithPhone),
          child: Text.rich(
            style: const TextStyle(fontSize: 13),
            TextSpan(
                // text: 'Hello', // default text style
                children: <TextSpan>[
                  const TextSpan(
                      text: " Continue with your phone number? ",
                      style: TextStyle(fontStyle: FontStyle.italic)),
                  TextSpan(
                      text: 'Sign up',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: context.successColor)),
                ]),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(
    BuildContext context, {
    String? hintText,
    String? labelText,
    required TextEditingController controller,
  }) {
    return TextFormField(
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
      onChanged: (value) {
        _checkEmailValidity(value); // Validate the input on change
      },
      // onEditingComplete: onEditingComplete,
    );
  }

  _checkEmailValidity(String email) {
    _isValidEmail.value = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

// _checkEmailValidity(String email) {
//   email = email.trim(); // Ensure no extra spaces
//   final regex = RegExp(
//       r'^[a-zA-Z0-9.!#$%&\*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
//   _isValidEmail.value = regex.hasMatch(email);
// }
}

class _PermissionAccessCheckBox extends StatefulWidget {
  const _PermissionAccessCheckBox({super.key, required this.onValueChange});

  final void Function(bool value) onValueChange;

  @override
  State<_PermissionAccessCheckBox> createState() =>
      _PermissionAccessCheckBoxState();
}

class _PermissionAccessCheckBoxState extends State<_PermissionAccessCheckBox> {
  bool _isAllowed = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Checkbox(
        value: _isAllowed,
        onChanged: (value) {
          setState(() {
            widget.onValueChange.call(value!);
            _isAllowed = !_isAllowed;
          });
        },
      ),
      title: Text(
        "Allow necessary permissions etc..",
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
//
// class BuildAuthAppBar extends StatelessWidget {
//   const BuildAuthAppBar({super.key, required this.title, this.actions});
//
//   final String title;
//   final List<Widget>? actions;
//
//   @override
//   PreferredSizeWidget build(BuildContext context) {
//     return AppBar(
//       title: Text(
//         title,
//         style: Theme.of(context).textTheme.titleSmall,
//       ),
//       centerTitle: true,
//       leading: IconButton(
//           onPressed: () => context.pop(),
//           icon: const Icon(Icons.keyboard_arrow_left_rounded)),
//       backgroundColor: Colors.transparent,
//       actions: actions,
//     );
//   }
// }
