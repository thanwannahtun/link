import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/ui/utils/route_list.dart';
import 'package:link/ui/widget_extension.dart';

class SignInWithEmailScreen extends StatefulWidget {
  const SignInWithEmailScreen({super.key});

  @override
  State<SignInWithEmailScreen> createState() => _SignInWithEmailScreenState();
}

class _SignInWithEmailScreenState extends State<SignInWithEmailScreen> {
  final ValueNotifier<bool> _isValidEmail = ValueNotifier(false);
  final ValueNotifier<bool> _isValidPassword = ValueNotifier(false);

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
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
                /// Logo Here
                const SizedBox(height: AppInsets.inset15),

                _buildFormField(
                  context,
                  labelText: "Enter email address",
                  controller: _emailController,
                  onChanged: (value) {
                    _checkEmailValidity(value); // Validate the input on change
                  },
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter your email';
                  //   }
                  //   if (!_checkEmailValidity(value)) {
                  //     return 'Please enter a valid email address';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: AppInsets.inset15),
                _buildFormField(
                  context,
                  labelText: "Enter password",
                  controller: _passwordController,
                  onChanged: (value) {
                    _checkPasswordValidity(value);
                  },
                ),
                const SizedBox(height: AppInsets.inset15),

                ValueListenableBuilder(
                    valueListenable: _isValidEmail,
                    builder:
                        (BuildContext context, isValidEmail, Widget? child) {
                      return ValueListenableBuilder(
                          valueListenable: _isValidPassword,
                          builder: (BuildContext context, isValidPassword,
                              Widget? child) {
                            return ElevatedButton(
                                onPressed: (isValidPassword && isValidEmail)
                                    ? () {
                                        // context
                                        //     .read<AuthenticationCubit>()
                                        //     .sendCode(email: _emailController.text);
                                      }
                                    : null,
                                child: const Text("Sign in"));
                          });
                    }),

                const SizedBox(height: AppInsets.inset15),
                Center(
                    child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(color: context.successColor),
                  ),
                )),
              ],
            ),
          ).expanded(),
          _footer(context),
        ],
      ),
    ));
  }

  ListTile _footer(BuildContext context) {
    return ListTile(
      title: Center(
        child: GestureDetector(
          onTap: () => context.pushNamed(RouteLists.signUp),
          child: Text.rich(
            style: const TextStyle(fontSize: 13),
            TextSpan(
                // text: 'Hello', // default text style
                children: <TextSpan>[
                  const TextSpan(
                      text: " Don't have an account? ",
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

  ButtonStyle? _listenValidEmailAndPassword(
      BuildContext context, bool isValidEmail, bool isValidPassword) {
    if (isValidEmail && isValidPassword) {
      return Theme.of(context).elevatedButtonTheme.style;
    }
    return Theme.of(context).elevatedButtonTheme.style?.copyWith(
          overlayColor: const WidgetStatePropertyAll(Colors.grey),
          shadowColor: const WidgetStatePropertyAll(Colors.grey),
          backgroundColor: const WidgetStatePropertyAll(Colors.grey),
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

  // _checkEmailValidity(String email) {
  //   return _isValidEmail.value =
  //       RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  // }

  _checkEmailValidity(String email) {
    email = email.trim(); // Ensure no extra spaces
    final regex = RegExp(
        r'^[a-zA-Z0-9.!#$%&\*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
    _isValidEmail.value = regex.hasMatch(email);
  }

  _checkPasswordValidity(String password, {int minLength = 8}) {
    bool isValid = true;

    // Check for minimum length
    if (password.length < minLength) {
      isValid = false;
    }

    // Regex to validate password complexity
    /// (?=.*[A-Z]) for Captial leter
    final regex =
        RegExp(r'^(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$');
    if (!regex.hasMatch(password)) {
      isValid = false;
    }

    // Check against common passwords
    const commonPasswords = [
      '123456',
      'password',
      '12345678',
      'qwerty',
      'abc123',
      'password1',
    ];
    if (commonPasswords.contains(password)) {
      isValid = false;
    }

    // Update the ValueNotifier
    _isValidPassword.value = isValid;
  }
}
