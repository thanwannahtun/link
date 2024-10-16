import 'package:flutter/material.dart';
import '../../../models/city.dart';



class CityAutocompleteController extends TextEditingController {
  // Validation state for whether the city is valid
  bool isValid = true;

  // Method to validate city name
  void validateCity(bool isValidCity) {
    isValid = isValidCity;
    notifyListeners(); // Update any listeners when validation changes
  }

  // Clear method (optional: you can uncomment it if you need custom behavior)
  // @override
  // void clear() {
  //   super.clear();
  //   validateCity(false); // Optionally reset validation on clear
  // }

  // Get the current value from the text field
  String get currentValue => text;

// Dispose method is inherited from TextEditingController
}

class CityAutocomplete extends StatefulWidget {
  final List<City> cities;
  final CityAutocompleteController controller;
  final Function(City) onSelected;
  final String? initialValue; // City name as String
  final String? labelText;
  final String? hintText;

  const CityAutocomplete({
    super.key,
    required this.cities,
    required this.controller,
    required this.onSelected,
    this.initialValue,
    this.labelText,
    this.hintText,
  });

  @override
  State<CityAutocomplete> createState() => _CityAutocompleteState();
}

class _CityAutocompleteState extends State<CityAutocomplete> {
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
      onSelected: (City city) {
        widget.controller.text = city.name ?? "";
        widget.controller.validateCity(true); // Valid city selected
        widget.onSelected(city); // Notify external state
      },
      fieldViewBuilder: (context, textController, focusNode, onEditingComplete) {
        if (widget.initialValue != null && textController.text.isEmpty) {
          // Ensure initial value is only set if it's not already present in the controller
          textController.text = widget.initialValue!;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: textController, // Use the textController from Autocomplete
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: widget.hintText,
                labelText: widget.labelText,
                border: const OutlineInputBorder(),
                errorText: widget.controller.isValid
                    ? null
                    : "No matching city found!", // Show error message
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
  }
}



/*
class CityAutocompleteController extends TextEditingController {
  // CityAutocompleteController();

  // Validation state for whether the city is valid
  bool isValid = true;

  // Method to validate city name
  void validateCity(bool isValidCity) {
    isValid = isValidCity;
    notifyListeners();
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
  final String? initialValue;
  // final City? initialValue;
  final String? labelText;
  final String? hintText;

  const CityAutocomplete({
    super.key,
    required this.cities,
    required this.controller,
    required this.onSelected,
    this.initialValue,
    this.labelText,
    this.hintText,
  });

  @override
  State<CityAutocomplete> createState() => _CityAutocompleteState();
}

class _CityAutocompleteState extends State<CityAutocomplete> {
  @override
  void initState() {
    super.initState();
    // If an initial value is provided, set it to the controller
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue ?? "";
      // widget.controller.text = widget.initialValue?.name ?? "Hello";
    }
  }

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
      onSelected: (City city) {
        widget.controller.text = city.name ?? "";
        // widget.controller.textController.text = city.name!;
        widget.controller.validateCity(true); // Valid city selected
        widget.onSelected(city); // Notify external state
      },
      fieldViewBuilder:
          (context, textController, focusNode, onEditingComplete) {
        // widget.controller = textController;
        widget.controller.text =
            textController.text; // Use the controller's text controller

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller:
                  textController, // Use the textController from the controller
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: widget.hintText,
                labelText: widget.labelText,
                border: const OutlineInputBorder(),
                errorText: widget.controller.isValid
                    ? null
                    : "No matching city found!", // Show error message
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
*/