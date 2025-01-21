import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/models/app.dart';
import 'package:link/models/city.dart';
import 'package:link/ui/sections/upload/drop_down_autocomplete.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';

class MidpointBottomSheet extends StatefulWidget {
  final RouteMidpoint? initialValue;
  final Function(RouteMidpoint? midpoint) onSave;

  const MidpointBottomSheet({
    super.key,
    this.initialValue,
    required this.onSave,
  });

  @override
  State<MidpointBottomSheet> createState() => _AddOrUpdateMidpointWidgetState();
}

class _AddOrUpdateMidpointWidgetState extends State<MidpointBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  final CityAutocompleteController _cityController =
      CityAutocompleteController();
  late TextEditingController _priceController;
  DateTime? _arrivalTime;
  City? _selectedCity;

  Color? _arrivalTimeColor;

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  _onInit() {
    _descriptionController =
        TextEditingController(text: widget.initialValue?.description ?? '');
    _priceController = TextEditingController(
      text: widget.initialValue?.price != null
          ? widget.initialValue?.price!.toStringAsFixed(2)
          : '',
    );
    _arrivalTime = widget.initialValue?.arrivalTime;
    _selectedCity = widget.initialValue?.city;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _cityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Choose Arrival Time",
    );

    if (picked != null) {
      _arrivalTime = DateTime.now()
          .add(Duration(hours: picked.hour, minutes: picked.minute));
      _arrivalTimeColor = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleText(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCityAutocomplete(context),
                      const SizedBox(height: AppInsets.inset15),
                      _buildArrivalTimePicker(context),
                      const SizedBox(height: AppInsets.inset15),
                      _buildPriceFormField(context),
                      const SizedBox(height: AppInsets.inset15),
                      _buildDescriptionFormField(context),
                      const SizedBox(height: AppInsets.inset15),
                    ],
                  ),
                ),
              ),
              _midpointButtonsRow(context),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildPriceFormField(BuildContext context) {
    return TextFormField(
      controller: _priceController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
        labelText: "Price",
        hintText: "Enter number",
        labelStyle: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(fontWeight: FontWeight.bold),
        hintStyle: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: Colors.grey),
        prefixIcon: const Icon(Icons.monetization_on),
        border: InputBorder.none,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d*'))
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter a price';
        }
        if (double.tryParse(value) == null) {
          return 'Enter a valid number';
        }
        return null;
      },
    );
  }

  ElevatedButton _buildArrivalTimePicker(BuildContext context) {
    return ElevatedButton.icon(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            minimumSize:
                const WidgetStatePropertyAll(Size(double.infinity, 40)),
            backgroundColor: WidgetStatePropertyAll(_arrivalTimeColor),
          ),
      onPressed: () => _selectTime(context),
      icon: const Icon(Icons.access_time),
      label: Text(
        _arrivalTime == null
            ? 'Add Arrival Time'
            : DateTimeUtil.displayTime(_arrivalTime),
      ),
    );
  }

  CityAutocomplete _buildCityAutocomplete(BuildContext context) {
    return CityAutocomplete(
        cities: App.cities,
        controller: _cityController,
        onSelected: (city) {
          _selectedCity = city;
        },
        initialValue: widget.initialValue?.city?.name ?? '',
        fillColor: Theme.of(context).primaryColor.withOpacity(0.5),
        filled: true,
        border: InputBorder.none,
        hintText: "Enter Midpoint",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter a city';
          }
          return null;
        });
  }

  Widget _buildTitleText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.initialValue == null ? 'Add Midpoint' : 'Update Midpoint',
          style:
              Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
        ),
        IconButton(
            tooltip: "Close",
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close))
      ],
    );
  }

  TextFormField _buildDescriptionFormField(BuildContext context) {
    return TextFormField(
      controller: _descriptionController,
      maxLines: null,
      minLines: 3,
      decoration: InputDecoration(
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
        border: InputBorder.none,
        hintText: ".. short description",
        hintStyle: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: Colors.grey),
      ),
    );
  }

  Row _midpointButtonsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (_arrivalTime == null) {
                _arrivalTimeColor = Colors.red;
                setState(() {});
                return;
              }
              final midpoint = RouteMidpoint(
                city: _selectedCity,
                description: _descriptionController.text,
                arrivalTime: _arrivalTime,
                price: double.parse(_priceController.text),
              );

              widget.onSave(midpoint);
              Navigator.pop(context);
            }
          },
          child: Text(widget.initialValue == null ? "Add" : "Update"),
        ),
      ],
    );
  }
}
