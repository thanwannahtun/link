import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';

import '../../../core/utils/app_insets.dart';
import '../../utils/route_list.dart';

class CreatePasswordScreen extends StatelessWidget {
  const CreatePasswordScreen({super.key});

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
            _buildFormField(context, labelText: "Enter password"),
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
            ElevatedButton(
                onPressed: () {
                  context.pushNamed(RouteLists.enterDateOfBirthScreen);
                },
                child: const Text("Continue")),
            const SizedBox(height: AppInsets.inset15),
          ],
        ),
      ),
    ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.keyboard_arrow_left_rounded)),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildFormField(
    BuildContext context, {
    String? hintText,
    String? labelText,
  }) {
    return TextFormField(
      // validator: widget.validator,
      // controller: textController,
      // Use the textController from Autocomplete
      // focusNode: focusNode,
      // onTapOutside: (event) => focusNode.unfocus(),
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.greyColor,
              ),
          labelText: labelText,
          border: InputBorder.none,
          fillColor: Theme.of(context).cardColor,
          filled: true
          // errorText: value ? null : "No matching!"
          // errorText: widget.controller.isValid
          //     ? null
          //     : "No matching city found!", // Show error message
          ),
      /*
      style: TextStyle(
        fontWeight: widget.fontWeight,
        color: value // widget.controller.isValid
            ? Theme.of(context).textTheme.bodyMedium?.color
            : Theme.of(context).colorScheme.error,
      ),
       */

      onChanged: (value) {
        // _checkValidity(value); // Validate the input on change
      },
      // onEditingComplete: onEditingComplete,
    );
  }
}
