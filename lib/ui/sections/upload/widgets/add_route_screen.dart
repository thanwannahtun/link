import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/models/agency.dart';
import 'package:link/models/app.dart';
import 'package:link/models/city.dart';
import 'package:link/ui/sections/upload/drop_down_autocomplete.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/sections/upload/widgets/midpoint_bottom_sheet.dart';
import 'package:link/ui/widget_extension.dart';

class AddRouteScreen extends StatefulWidget {
  final RouteModel? route;

  const AddRouteScreen({super.key, this.route, required this.onClosed});

  final Function(RouteModel? value) onClosed;

  @override
  State<AddRouteScreen> createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  final _formKey = GlobalKey<FormState>();
  City? origin;
  City? destination;
  DateTime? scheduleDate;
  double? pricePerTraveller;
  List<RouteMidpoint> midpoints = [];
  String? routeImagePath; // Path to the selected image
  List<String> routeImagePaths = []; // List of selected image paths
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  late CityAutocompleteController originController;
  late CityAutocompleteController destinationController;

  late TextEditingController _routeDescriptionController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    originController = CityAutocompleteController();
    destinationController = CityAutocompleteController();
    _routeDescriptionController = TextEditingController();

    // If editing an existing route, prefill the data
    if (widget.route != null) {
      origin = widget.route!.origin;
      destination = widget.route!.destination;
      scheduleDate = widget.route?.scheduleDate;
      pricePerTraveller = widget.route!.pricePerTraveller;
      midpoints = widget.route?.midpoints ?? [];
      originController.text = origin?.name ?? "ORIGIN";
      destinationController.text = destination?.name ?? "DEST";
      routeImagePath = widget.route!.image;
      _routeDescriptionController.text = widget.route!.description ?? "";
    } else {
      scheduleDate = DateTime.now();
    }
  }

  ///
  ///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Adjust screen for keyboard
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: AppInsets.inset5,
              left: AppInsets.inset15,
              right: AppInsets.inset15,
              bottom: 3),
          child: Column(
            children: [
              _header(context),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          CityAutocomplete(
                            cities: App.cities,
                            controller: originController,
                            initialValue: origin?.name,
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            border: InputBorder.none,
                            hintText: "Enter Origin",
                            onSelected: (value) {
                              origin = value;
                              setState(() {});
                            },
                            labelText: "Origin",
                            validator: (value) =>
                                (value!.isEmpty || !originController.isValid)
                                    ? 'Enter Origin'
                                    : null,
                          ),

                          const SizedBox(height: 8),
                          CityAutocomplete(
                            cities: App.cities,
                            controller: destinationController,
                            initialValue: destination?.name,
                            onSelected: (value) {
                              destination = value;
                              setState(() {});
                            },
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            border: InputBorder.none,
                            labelText: "Destination",
                            hintText: "Enter Destination",
                            validator: (value) => (value!.isEmpty ||
                                    !destinationController.isValid)
                                ? 'Enter Destination'
                                : null,
                          ),

                          const SizedBox(height: 8),
                          _buildDatePicker(),
                          const SizedBox(height: 8),
                          _buildTextField(
                              inputFormat: true,
                              label: 'Price Per Traveller',
                              hintText: "Enter number",
                              initialValue: pricePerTraveller != null
                                  ? pricePerTraveller.toString()
                                  : '',
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                setState(() {
                                  pricePerTraveller =
                                      double.tryParse(value ?? "0.0");
                                });
                              }),
                          const SizedBox(height: 8),
                          _buildRouteDescriptionInput(context),
                          const SizedBox(height: 16),
                          _buildMidpointsSection(),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          _buildImageCarousel(), // Add image carousel here
                          const SizedBox(height: AppInsets.inset5),
                          const SizedBox(height: AppInsets.inset5),
                          _buildServiceOffer(),
                          const SizedBox(height: AppInsets.inset5),
                        ],
                      ),
                    ],
                  ),
                ),
              ).expanded(),
              const SizedBox(height: AppInsets.inset5),
              SizedBox(width: double.infinity, child: _buildSaveButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.route != null ? 'Edit Route' : 'Add New Route',
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

  TextFormField _buildRouteDescriptionInput(BuildContext context) {
    return TextFormField(
        autocorrect: true,
        maxLines: null,
        style: TextStyle(color: context.greyColor),
        controller: _routeDescriptionController,
        decoration: InputDecoration(
          fillColor: Colors.grey.withOpacity(0.1),
          filled: true,
          labelStyle: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          hintStyle: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: Colors.grey),
          border: InputBorder.none,
          hintText: "Description",
          label: const Text("Description(optional)"),
          // border: InputBorder.none,
        ));
  }

  Widget _buildServiceOffer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Service Offer (Optional)',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            children: List<Widget>.generate(
              5,
              (index) => Card(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text("service ${index + 1}")
                    .styled(fs: 10, fw: FontWeight.bold, color: Colors.grey),
              )),
            ),
          ),
        ],
      ),
    );
  }

  /// For Array of Images Files Logic
  Widget _buildImageCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Route Images (Optional)',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),

        if (routeImagePath == null)
          GestureDetector(
            onTap: _pickImageForMidpoint,
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Icon(Icons.add_a_photo)),
            ),
          )
        else
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: _pickImageForMidpoint,
                  child: Image.file(
                    File(routeImagePath!),
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      routeImagePath = null;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

        ///
        ///
      ],
    );
  }

  Future<void> _pickImageForMidpoint() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      routeImagePath = pickedFile.path;
      setState(() {});
    }
  }

  Widget _buildTextField({
    required String label,
    String? hintText,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
    bool inputFormat = false,
  }) {
    return TextFormField(
      style: const TextStyle(fontWeight: FontWeight.bold),
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
        labelText: label,
        hintText: hintText,
        labelStyle: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(fontWeight: FontWeight.bold),
        hintStyle: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: Colors.grey),
        border: InputBorder.none,
      ),
      inputFormatters: inputFormat
          ? [FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d*'))]
          : null,
      validator: (value) => value!.isEmpty ? 'Enter a price' : null,
      onSaved: onSaved,
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _selectDate,
      child: AbsorbPointer(
        child: TextFormField(
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: 'Schedule Date',
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            hintText: "Enter number",
            labelStyle: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            hintStyle: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Colors.grey),
            border: InputBorder.none,
          ),
          controller: TextEditingController(
            text: '${scheduleDate?.toLocal()}'.split(' ')[0],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: scheduleDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != scheduleDate) {
      setState(() {
        scheduleDate = picked;
      });
    }
  }

  Widget _buildMidpointsSection() {
    return Column(
      children: [
        midpoints.isNotEmpty
            ? const Text(
                'Midpoints',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            : Container(),
        ...midpoints.map((midpoint) {
          int index = midpoints.indexOf(midpoint);
          return Card(
              elevation: 3.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(midpoint.city?.name ?? ""),
                      Text(
                        DateTimeUtil.displayTime(midpoint.arrivalTime),
                      )
                    ],
                  ),
                  const Divider(thickness: 0.05),
                  midpoint.price != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Price",
                                style: TextStyle(color: context.greyColor)),
                            Text((midpoint.price ?? "").toString(),
                                style: TextStyle(color: context.greyColor)),
                          ],
                        )
                      : Container(),
                  if (midpoint.description?.isNotEmpty ?? false)
                    const Divider(thickness: 0.05),
                  Text(midpoint.description ?? "",
                      style: TextStyle(color: context.greyColor)),
                  _midpointIcons(midpoint, index),
                ],
              ).padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10)));
        }),
        const SizedBox(
          height: AppInsets.inset5,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showMidpointBottomSheet(),
            icon: const Icon(Icons.add),
            label: const Text('Add Midpoint'),
          ),
        ),
      ],
    );
  }

  Widget _midpointIcons(RouteMidpoint midpoint, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          iconSize: 15,
          color: context.successColor,
          onPressed: () =>
              _showMidpointBottomSheet(initialMidpoint: midpoint, index: index),
        ),
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          iconSize: 15,
          color: context.dangerColor,
          onPressed: () {
            setState(() {
              midpoints.removeAt(index);
            });
          },
        ),
      ],
    );
  }

  void _showMidpointBottomSheet(
      {RouteMidpoint? initialMidpoint, int? index}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      backgroundColor: context.scaffoldBackgroundColor,
      useSafeArea: true,
      builder: (context) => MidpointBottomSheet(
        onSave: (midpoint) {
          if (midpoint != null) {
            if (index != null) {
              midpoints[index] = midpoint;
            } else {
              midpoints.add(midpoint);
            }
            setState(() {});
          }
        },
        initialValue: initialMidpoint,
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          // If editing, update the route
          if (widget.route != null) {
            _updateRoute();
          } else {
            _addRoute();
          }
        }
      },
      child: Text(widget.route != null ? 'Update Route' : 'Add Route'),
    );
  }

  void _addRoute() {
    // Logic for adding a new route
    RouteModel newRoute = RouteModel(
        origin: origin,
        agency: Agency(id: "66b8d3c63e1a9b47a2c0e6a5"),
        destination: destination,
        scheduleDate: scheduleDate,
        pricePerTraveller: pricePerTraveller,
        // pricePerTraveller: int.tryParse((pricePerTraveller ?? 0.0).toString()),
        midpoints: midpoints,
        // routeImagePaths: routeImagePaths,
        // routeImagePath: routeImagePath,
        description: _routeDescriptionController.text,
        image: routeImagePath);
    widget.onClosed(newRoute);

    // Call an API or handle the new route creation here
    Navigator.pop(context); // Close the modal after saving
  }

  void _updateRoute() {
    final RouteModel? route = widget.route?.copyWith(
        origin: origin,
        agency: Agency(id: "66b8d3c63e1a9b47a2c0e6a5"),
        destination: destination,
        scheduleDate: scheduleDate,
        // pricePerTraveller: 30000,
        pricePerTraveller: pricePerTraveller,
        image: routeImagePath,
        description: _routeDescriptionController.text,
        midpoints: midpoints);
    // Logic for updating an existing route

    widget.onClosed(route);
    // Call an API or handle the route update here
    Navigator.pop(context); // Close the modal after updating
  }
}
