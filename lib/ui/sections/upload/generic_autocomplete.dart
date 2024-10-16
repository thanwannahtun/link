/*
import 'package:flutter/material.dart';

// Generic TextEditingController for Autocomplete
class GenericAutocompleteController<T> extends TextEditingController {
  // Validation state for whether the value is valid
  bool isValid = true;

  // Method to validate input
  void validateInput(bool isValidInput) {
    isValid = isValidInput;
  }

  // Get the current value from the text field
  String get currentValue => text;
}

class GenericAutocomplete<T> extends StatefulWidget {
  final List<T> options; // The list of options to search from
  final GenericAutocompleteController<T> controller;
  final Function(T) onSelected; // Callback when an option is selected
  final String? Function(T)
      displayStringForOption; // How to display each option
  final bool Function(T, String) optionFilter; // Filter logic for options
  final String? initialValue; // Optional initial value for the field

  const GenericAutocomplete({
    super.key,
    required this.options,
    required this.controller,
    required this.onSelected,
    required this.displayStringForOption,
    required this.optionFilter,
    this.initialValue,
  });

  @override
  State<GenericAutocomplete<T>> createState() => _GenericAutocompleteState<T>();
}

class _GenericAutocompleteState<T> extends State<GenericAutocomplete<T>> {
  @override
  void initState() {
    super.initState();

    // If an initial value is provided, set it to the controller
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return Iterable<T>.empty();
        }
        return widget.options.where((option) => widget.optionFilter(
            option, textEditingValue.text)); // Apply filter logic
      },
      displayStringForOption: (T option) =>
          widget.displayStringForOption(option) ?? '',
      onSelected: (T selection) {
        widget.controller.text = widget.displayStringForOption(selection) ?? "";
        widget.controller.validateInput(true); // Valid input selected
        widget.onSelected(selection); // Notify external state
      },
      fieldViewBuilder:
          (context, textController, focusNode, onEditingComplete) {
        // Sync the widget's controller with the text field controller
        widget.controller.text = textController.text;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller:
                  textController, // Use the text controller for the field
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Start typing...",
                border: const OutlineInputBorder(),
                errorText: widget.controller.isValid
                    ? null
                    : "No matching option found", // Show error message if invalid
              ),
              style: TextStyle(
                color: widget.controller.isValid
                    ? Colors.black
                    : Colors.red, // Change color based on validity
              ),
              onChanged: (value) {
                _checkValidity(value); // Validate the input on change
              },
              onEditingComplete: onEditingComplete,
            ),
          ],
        );
      },
    );
  }

  void _checkValidity(String userInput) {
    bool isMatching = widget.options.any((option) =>
        widget
            .displayStringForOption(option)
            ?.toLowerCase()
            .startsWith(userInput.toLowerCase()) ??
        false);
    widget.controller.validateInput(isMatching); // Update the validity state
    setState(() {});
  }
}

*/