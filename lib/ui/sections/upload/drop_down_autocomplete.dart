import 'package:flutter/material.dart';
import '../../../models/city.dart';

class CityAutocompleteController extends TextEditingController {
  // Validation state for whether the city is valid
  bool isValid = true;

  // Method to validate city name
  void validateCity(bool isValidCity) {
    isValid = isValidCity;
  }

  // Clear method (inherited from TextEditingController)

  // Get the current value from the text field
  String get currentValue => text;

  // Dispose method (inherited from TextEditingController)
}

class CityAutocomplete extends StatefulWidget {
  final List<City> cities;
  final CityAutocompleteController controller;
  final Function(City) onSelected;

  const CityAutocomplete({
    super.key,
    required this.cities,
    required this.controller,
    required this.onSelected,
  });

  @override
  State<CityAutocomplete> createState() => _CityAutocompleteState();
}

class _CityAutocompleteState extends State<CityAutocomplete> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete<City>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<City>.empty();
        }
        return widget.cities.where((city) => city.name!
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (City option) => option.name ?? '',
      onSelected: (City selection) {
        widget.controller.text = selection.name ?? "";
        // widget.controller.textController.text = selection.name!;
        widget.controller.validateCity(true); // Valid city selected
        widget.onSelected(selection); // Notify external state
      },
      fieldViewBuilder:
          (context, textController, focusNode, onEditingComplete) {
        // widget.controller = textController;
        widget.controller.text =
            textController.text; // Use the controller's text controller

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller:
                  textController, // Use the textController from the controller
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Start typing a city",
                border: const OutlineInputBorder(),
                errorText: widget.controller.isValid
                    ? null
                    : "No matching city found", // Show error message
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
    bool isMatching = widget.cities.any(
        (city) => city.name!.toLowerCase().startsWith(userInput.toLowerCase()));
    widget.controller.validateCity(isMatching); // Update the validity state
    setState(() {});
  }
}
