// ignore_for_file: unused_element

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/models/app.dart';
import 'package:link/ui/sections/upload/drop_down_autocomplete.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

import '../../../core/utils/app_insets.dart';
import '../../../models/city.dart';

/*
class AddRouteScreen extends StatefulWidget {
  final RouteModel? route;

  AddRouteScreen({this.route});

  @override
  _AddRouteScreenState createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  final _formKey = GlobalKey<FormState>();
  late String origin;
  late String destination;
  late DateTime scheduleDate;
  late double pricePerTraveller;
  List<Midpoint> midpoints = [];
  List<String> routeImagePaths = []; // List of selected image paths
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  @override
  void initState() {
    super.initState();
    if (widget.route != null) {
      origin = widget.route!.origin;
      destination = widget.route!.destination;
      scheduleDate = widget.route!.scheduleDate;
      pricePerTraveller = widget.route!.pricePerTraveller;
      midpoints = widget.route!.midpoints;
      routeImagePaths = widget.route!.routeImagePath != null
          ? [widget.route!.routeImagePath!] // If a route has a previously uploaded image
          : [];
    } else {
      origin = '';
      destination = '';
      scheduleDate = DateTime.now();
      pricePerTraveller = 0.0;
      midpoints = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.route != null ? 'Edit Route' : 'Add New Route',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: 'Origin',
                    initialValue: origin,
                    onSaved: (value) => origin = value!,
                  ),
                  SizedBox(height: 8),
                  _buildTextField(
                    label: 'Destination',
                    initialValue: destination,
                    onSaved: (value) => destination = value!,
                  ),
                  SizedBox(height: 8),
                  _buildDatePicker(),
                  SizedBox(height: 8),
                  _buildTextField(
                    label: 'Price Per Traveller',
                    initialValue: pricePerTraveller != 0.0
                        ? pricePerTraveller.toString()
                        : '',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => pricePerTraveller = double.parse(value!),
                  ),
                  SizedBox(height: 16),
                  _buildMidpointsSection(),
                  SizedBox(height: 16),
                  _buildImageCarousel(), // Add image carousel here
                  SizedBox(height: 16),
                  _buildSaveButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Route Images (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: routeImagePaths.length + 1, // Include the "Add" button
            itemBuilder: (context, index) {
              if (index == routeImagePaths.length) {
                // Add new image button
                return GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Icon(Icons.add_a_photo)),
                  ),
                );
              }
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(routeImagePaths[index]),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          routeImagePaths.removeAt(index);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        routeImagePaths.add(pickedFile.path); // Add the selected image to the list
      });
    }
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? '$label is required' : null,
      onSaved: onSaved,
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _selectDate,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Schedule Date',
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(
            text: '${scheduleDate.toLocal()}'.split(' ')[0],
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
    if (picked != null && picked != scheduleDate)
      setState(() {
        scheduleDate = picked;
      });
  }

  Widget _buildMidpointsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Midpoints',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...midpoints.map((midpoint) {
          int index = midpoints.indexOf(midpoint);
          return Card(
            child: ListTile(
              title: Text(midpoint.description),
              subtitle: Text('Arrival Time: ${midpoint.arrivalTime}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    midpoints.removeAt(index);
                  });
                },
              ),
            ),
          );
        }).toList(),
        TextButton.icon(
          onPressed: _addMidpoint,
          icon: Icon(Icons.add),
          label: Text('Add Midpoint'),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveRoute,
      child: Center(
        child: Text(
          widget.route != null ? 'Save Changes' : 'Add Route',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _saveRoute() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final route = RouteModel(
        origin: origin,
        destination: destination,
        scheduleDate: scheduleDate,
        pricePerTraveller: pricePerTraveller,
        midpoints: midpoints,
        routeImagePath: routeImagePaths.isNotEmpty ? routeImagePaths.first : null, // Save first image if available
      );
      Navigator.pop(context, route);
    }
  }

  void _addMidpoint() async {
    final newMidpoint = await showDialog<Midpoint>(
      context: context,
      builder: (context) => AddMidpointDialog(),
    );
    if (newMidpoint != null) {
      setState(() {
        midpoints.add(newMidpoint);
      });
    }
  }
}

 */
class NewRouteUploadScreen extends StatefulWidget {
  const NewRouteUploadScreen({super.key});

  @override
  State<NewRouteUploadScreen> createState() => _NewRouteUploadScreenState();
}

class _NewRouteUploadScreenState extends State<NewRouteUploadScreen> {
  List<RouteModel> routes = [];
  List<String> images = [];




  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild");

    return CustomScaffoldBody(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(child: _buildFormFields()),
              _buildSubmitButton(),
            ],
          ),
        ),
        title: const Text('Create New Post'),
        backButton: BackButton(
          onPressed: () => context.pop(),
        ));
  }

  Widget _buildFormFields() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageCarousel(),
          const SizedBox(height: 8),
          _titleField(),
          const SizedBox(height: 16),
          _descriptionField(context),
          const SizedBox(height: 16),
          // _buildTitleInput(),
          // const SizedBox(height: 16),
          // _buildDescriptionInput(),
          // const SizedBox(height: 16),
          _buildRoutesSummarySimple(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// START

  TextField _titleField() {
    return TextField(
      // focusNode: _titleFocusNode,
        autocorrect: true,
        maxLines: null,
        minLines: 1,
        // onTapOutside: (event) => _unfoucsNode(_titleFocusNode),
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: AppInsets.font20),
        controller: TextEditingController(),
        decoration: const InputDecoration(
          hintText: "Title",
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: AppInsets.font20),
          border: InputBorder.none,
        ));
  }

  TextField _descriptionField(BuildContext context) {
    return TextField(
      // focusNode: _descriptionFocusNode,
        autocorrect: true,
        maxLines: null,
        minLines: 2,
        // onTapOutside: (event) => _unfoucsNode(_descriptionFocusNode),
        // maxLength: 7000,
        controller: TextEditingController(),
        decoration: const InputDecoration(
          hintText: "Dercription",
          border: InputBorder.none,
        ));
  }

  /// END
  ElevatedButton _addMoreRoute() {
    return ElevatedButton.icon(
      onPressed: _addNewRoute,
      icon: const Icon(Icons.add),
      label: const Text('Add Route'),
    );
  }

  Widget _buildTitleInput() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return TextFormField(
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Opacity(
        //   opacity: 0.7,
        //   child: Text('Images',
        //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        // ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length + 1, // Include the "Add" button
            itemBuilder: (context, index) {
              if (index == images.length) {
                // Add new image button
                return GestureDetector(
                  onTap: _pickImageMultiple,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Icon(Icons.add_a_photo)),
                  ),
                );
              }
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(images[index]),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          images.removeAt(index);
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
              );
            },
          ),
        ),
        /*
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildImageCard(),
              _buildImageCard(),
              _buildImageCard(),
            ],
          ),
        ),
      */
      ],
    );
  }

  Future<void> _pickImageMultiple() async {
    final pickedFiles =
    await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        for (var file in pickedFiles) {
          images.add(file.path);
        }
        // images.add(pickedFile.path); // Add the selected image to the list
      });
    }
  }

  Widget _buildImageCard() {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: Icon(Icons.image, size: 40)),
    );
  }

  /// For Simple ListTile Routes List Design
  Widget _buildRoutesSummarySimple() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Routes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // routes.isEmpty
        // ? const Opacity(opacity: 0.7, child: Text('Start Adding Routes'))
        // :
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: routes.length,
          itemBuilder: (context, index) {
            final route = routes[index];
            return RouteSummaryWidget(
              route: route,
              onEditRoute: () => _editRoute(route, index),
            );
          },
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _addNewRoute,
          icon: const Icon(Icons.add),
          label: const Text('Add Route'),
        ),
      ],
    );
  }

  void _addNewRoute() async {
    final newRoute = await showModalBottomSheet<RouteModel>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddRouteScreen(),
    );

    if (newRoute != null) {
      setState(() {
        routes.add(newRoute);
      });
    }
  }

  void _editRoute(RouteModel route, int index) async {
    final updatedRoute = await showModalBottomSheet<RouteModel>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddRouteScreen(route: route),
    );

    if (updatedRoute != null) {
      setState(() {
        routes[index] = updatedRoute;
      });
    }
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        // Submit to the server
      },
      child: const Center(
        child: Text(
          'Upload Route',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class RouteSummaryWidget extends StatefulWidget {
  final RouteModel route;
  final void Function()? onEditRoute;

  const RouteSummaryWidget({super.key, required this.route, this.onEditRoute});

  @override
  State<RouteSummaryWidget> createState() => _RouteSummaryWidgetState();
}

class _RouteSummaryWidgetState extends State<RouteSummaryWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Origin & Schedule Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded),
                    Text(
                      widget.route.origin.name ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.date_range),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.route.scheduleDate?.toLocal()}'.split(' ')[0],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Midpoints Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._buildMidpointSummaries(widget.route.midpoints),
                if (widget.route.midpoints.length > 2)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Destination & Price Per Traveller
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded),
                    Text(
                      widget.route.destination.name ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  ],
                ).expanded(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '\$${widget.route.pricePerTraveller?.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ).expanded(),
              ],
            ),
            const SizedBox(height: 8),

            /// Edit Button and Accommodation
            Row(
              children: [
                Wrap(
                  children: List<Widget>.generate(
                    8,
                        (index) => Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          child: Opacity(
                              opacity: 0.7,
                              child: Text("AC $index")
                                  .styled(fs: 10, fw: FontWeight.bold)),
                        )),
                  ),
                ).expanded(),
                IconButton(
                  icon: const Icon(Icons.edit_square),
                  onPressed: widget.onEditRoute,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build midpoints summaries with expand/collapse functionality
  List<Widget> _buildMidpointSummaries(List<Midpoint> midpoints) {
    int displayedMidpoints = isExpanded ? midpoints.length : 2;
    return midpoints.take(displayedMidpoints).map((midpoint) {
      return Opacity(
          opacity: 0.7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    midpoint.city?.name ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Colors.black87,
                    ),
                  ),
                  if ((midpoint.description ?? "").isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        midpoint.description ?? "",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    midpoint.arrivalTime ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Colors.black87,
                    ),
                  ),
                  if (((midpoint.price ?? 0).toString()).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        (midpoint.price ?? 0.0).toString(),
                        // style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                ],
              ),
            ],
          ));
    }).toList();
  }
}

/// Main End
///

/*
class AddRouteScreen extends StatefulWidget {
  final RouteModel? route;

  const AddRouteScreen({super.key, this.route});

  @override
  State<AddRouteScreen> createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  final _formKey = GlobalKey<FormState>();
  City? origin;
  City? destination;
  DateTime? scheduleDate;
  double? pricePerTraveller;
  List<Midpoint> midpoints = [];
  String? routeImagePath;
  List<String> routeImagePaths = [];
  final ImagePicker _picker = ImagePicker();

  late CityAutocompleteController originController;
  late CityAutocompleteController destinationController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    originController = CityAutocompleteController();
    destinationController = CityAutocompleteController();

    // If editing an existing route, prefill the data
    if (widget.route != null) {
      origin = widget.route!.origin;
      destination = widget.route!.destination;
      scheduleDate = widget.route?.scheduleDate;
      pricePerTraveller = widget.route!.pricePerTraveller ?? 0.0;
      midpoints = widget.route!.midpoints ?? [];
      routeImagePaths = widget.route!.routeImagePaths ?? [];

      // Set initial values in controllers
      originController.text = origin?.name ?? "ORIGIN";
      destinationController.text = destination?.name ?? "DEST";
    } else {
      scheduleDate = DateTime.now();
      pricePerTraveller = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).bottomSheetTheme.modalBarrierColor,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      widget.route != null ? 'Edit Route' : 'Add New Route',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CityAutocomplete(
                      cities: App.cities,
                      controller: originController,
                      initialValue: origin?.name,
                      onSelected: (value) {
                        origin = value;
                        setState(() {});
                      },
                      labelText: "Origin",
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
                      labelText: "Destination",
                    ),
                    const SizedBox(height: 8),
                    // _buildDatePicker(),
                    const SizedBox(height: 8),
                    // _buildTextField(
                    //   label: 'Price Per Traveller',
                    //   initialValue: pricePerTraveller != 0.0
                    //       ? pricePerTraveller.toString()
                    //       : '',
                    //   keyboardType: TextInputType.number,
                    //   onSaved: (value) => pricePerTraveller = double.parse(value!),
                    // ),
                    const SizedBox(height: 16),
                    // _buildMidpointsSection(),
                    const SizedBox(height: 16),
                    // _buildImageCarousel(), // Image picker and carousel
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ).expanded(),
            const SizedBox(height: 16),
            _buildSaveButton(),
          ],
        ),
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
      origin: origin!,
      destination: destination!,
      scheduleDate: scheduleDate,
      pricePerTraveller: pricePerTraveller!,
      midpoints: midpoints,
      routeImagePaths: routeImagePaths,
    );

    // Call an API or handle the new route creation here
    Navigator.pop(context, newRoute); // Close the modal after saving
  }

  void _updateRoute() {
    // Logic for updating an existing route
    widget.route!.origin = origin!;
    widget.route!.destination = destination!;
    widget.route!.scheduleDate = scheduleDate;
    widget.route!.pricePerTraveller = pricePerTraveller!;
    widget.route!.midpoints = midpoints;
    widget.route!.routeImagePaths = routeImagePaths;

    // Call an API or handle the route update here
    Navigator.pop(context, widget.route); // Close the modal after updating
  }

// Other widgets and methods remain the same...
}

*/


class AddRouteScreen extends StatefulWidget {
  final RouteModel? route;

  const AddRouteScreen({super.key, this.route});

  @override
  State<AddRouteScreen> createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  final _formKey = GlobalKey<FormState>();
  City? origin;
  City? destination;
  DateTime? scheduleDate;
  double? pricePerTraveller;
  List<Midpoint> midpoints = [];
  String? routeImagePath; // Path to the selected image
  List<String> routeImagePaths = []; // List of selected image paths
  final ImagePicker _picker = ImagePicker(); // Image picker instance


  late CityAutocompleteController originController;
  late CityAutocompleteController destinationController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    originController = CityAutocompleteController();
    destinationController = CityAutocompleteController();

    // If editing an existing route, prefill the data
    if (widget.route != null) {
      origin = widget.route!.origin;
      destination = widget.route!.destination;
      scheduleDate = widget.route?.scheduleDate;
      pricePerTraveller = widget.route!.pricePerTraveller ?? 0.0;
      midpoints = widget.route!.midpoints ?? [];
      routeImagePaths = widget.route!.routeImagePaths ?? [];

      // Set initial values in controllers
      originController.text = origin?.name ?? "ORIGIN";
      destinationController.text = destination?.name ?? "DEST";
    } else {
      scheduleDate = DateTime.now();
      pricePerTraveller = 0.0;
    }
  }
  ///
  ///


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).bottomSheetTheme.modalBarrierColor,
      // To make the modal full-screen
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.route != null ? 'Edit Route' : 'Add New Route',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        CityAutocomplete(
                          cities: App.cities,
                          controller: CityAutocompleteController(),
                          initialValue: origin?.name,
                          onSelected: (value) {
                            origin = value;
                            setState(() {});
                          },
                          labelText: "Origin",
                        ),
                        // _buildTextField(
                        //   label: 'Origin',
                        //   initialValue: origin,
                        //   onSaved: (value) => origin = value!,
                        // ),
                        const SizedBox(height: 8),
                        CityAutocomplete(
                          cities: App.cities,
                          controller: CityAutocompleteController(),
                          initialValue: destination?.name,
                          onSelected: (value) {
                            destination = value;
                            setState(() {});
                          },
                          labelText: "Destination",
                        ),
                        // _buildTextField(
                        //   label: 'Destination',
                        //   initialValue: destination,
                        //   onSaved: (value) => destination = value!,
                        // ),
                        const SizedBox(height: 8),
                        _buildDatePicker(),
                        const SizedBox(height: 8),
                        _buildTextField(
                          label: 'Price Per Traveller',
                          initialValue: pricePerTraveller != 0.0
                              ? pricePerTraveller.toString()
                              : '',
                          keyboardType: TextInputType.number,
                          onSaved: (value) =>
                          pricePerTraveller = double.parse(value!),
                        ),
                        const SizedBox(height: 16),
                        _buildMidpointsSection(),
                        const SizedBox(height: 16),
                        // _buildImagePicker(), // Add image picker here
                        const SizedBox(height: 16),
                        _buildImageCarousel(), // Add image carousel here
                        const SizedBox(height: AppInsets.inset5),
                      ],
                    ),
                  ],
                ),
              ),
            ).expanded(),
            const SizedBox(height: AppInsets.inset5),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  /// For Array of Images Files Logic
  Widget _buildImageCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Route Images (Optional)',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: routeImagePaths.length + 1, // Include the "Add" button
            itemBuilder: (context, index) {
              if (index == routeImagePaths.length) {
                // Add new image button
                return GestureDetector(
                  onTap: _pickImageMultiple,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Icon(Icons.add_a_photo)),
                  ),
                );
              }
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(routeImagePaths[index]),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          routeImagePaths.removeAt(index);
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
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _pickImageMultiple() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        routeImagePaths
            .add(pickedFile.path); // Add the selected image to the list
      });
    }
  }

  /// For ONe Image Picking Logic
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Route Image (Optional)',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: routeImagePath != null
              ? Image.file(
            File(routeImagePath!),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          )
              : Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Icon(Icons.add_a_photo)),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        routeImagePath = pickedFile.path;
      });
    }
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? '$label is required' : null,
      onSaved: onSaved,
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _selectDate,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Schedule Date',
            border: OutlineInputBorder(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Midpoints',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...midpoints.map((midpoint) {
          int index = midpoints.indexOf(midpoint);
          return Card(
            /* child: ListTile(
              dense: true,
              isThreeLine: midpoint.description != null,
              title: Text(midpoint.city?.name ?? ""),
              subtitle: Text(midpoint.arrivalTime ?? ""),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    midpoints.removeAt(index);
                  });
                },
              ),
            ),
         */
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(midpoint.city?.name ?? ""),
                          const SizedBox(width: 10),
                          Text(midpoint.arrivalTime ?? ""),
                        ],
                      ),
                      midpoint.price != null
                          ? Text((midpoint.price ?? "").toString())
                          : Container(),
                      Text(midpoint.description ?? ""),
                    ],
                  )
                      .padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10))
                      .expanded(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          midpoints.removeAt(index);
                        });
                      },
                    ),
                  ),
                ],
              ));
        }),
        TextButton.icon(
          onPressed: _addMidpoint,
          icon: const Icon(Icons.add),
          label: const Text('Add Midpoint'),
        ),
      ],
    );
  }

  void _addMidpoint() async {
    final newMidpoint = await showDialog<Midpoint>(
      context: context,
      builder: (context) => const AddMidpointDialog(),
    );
    if (newMidpoint != null) {
      setState(() {
        midpoints.add(newMidpoint);
      });
    }
  }

  // Widget _buildSaveButton() {
  //   return ElevatedButton(
  //     onPressed: _saveRoute,
  //     child: Center(
  //       child: Text(
  //         widget.route != null ? 'Save Changes' : 'Add Route',
  //         style: const TextStyle(fontSize: 16),
  //       ),
  //     ),
  //   );
  // }

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
      origin: origin!,
      destination: destination!,
      scheduleDate: scheduleDate,
      pricePerTraveller: pricePerTraveller!,
      midpoints: midpoints,
      routeImagePaths: routeImagePaths,
    );

    // Call an API or handle the new route creation here
    Navigator.pop(context, newRoute); // Close the modal after saving
  }

  void _updateRoute() {
    // Logic for updating an existing route
    widget.route!.origin = origin!;
    widget.route!.destination = destination!;
    widget.route!.scheduleDate = scheduleDate;
    widget.route!.pricePerTraveller = pricePerTraveller!;
    widget.route!.midpoints = midpoints;
    widget.route!.routeImagePaths = routeImagePaths;

    // Call an API or handle the route update here
    Navigator.pop(context, widget.route); // Close the modal after updating
  }

  void _saveRoute() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final route = RouteModel(
        origin: origin!,
        destination: destination!,
        scheduleDate: scheduleDate,
        pricePerTraveller: pricePerTraveller,
        midpoints: midpoints,
        // routeImagePath: routeImagePath, // Save image path
        routeImagePath:
        routeImagePaths.isNotEmpty ? routeImagePaths.first : null,
        // Save first image if available
        routeImagePaths: routeImagePaths.isNotEmpty
            ? routeImagePaths
            : null, // Save first image if available
      );
      print("save Route :: $route");
      Navigator.pop(context, route);
    }
  }
}


/// Dialog
///
class AddMidpointDialog extends StatefulWidget {
  const AddMidpointDialog({super.key});

  @override
  State<AddMidpointDialog> createState() => _AddMidpointDialogState();
}

class _AddMidpointDialogState extends State<AddMidpointDialog> {
  final _formKey = GlobalKey<FormState>();
  final CityAutocompleteController _midpointCityController =
  CityAutocompleteController();
  late String description;
  late String arrivalTime;
  City? midpointCity;
  int? price;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Midpoint'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CityAutocomplete(
                cities: App.cities,
                controller: _midpointCityController,
                onSelected: (city) {
                  midpointCity = city;
                  setState(() {});
                },
              ),
              if (midpointCity == null)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Midpoint Name is required",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                decoration:
                const InputDecoration(labelText: 'Arrival Time (Average)'),
                validator: (value) =>
                value!.isEmpty ? 'Arrival Time is required' : null,
                onSaved: (value) => arrivalTime = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => null,
                // value!.isEmpty ? 'Description is required' : null,
                onSaved: (value) => description = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price :'),
                validator: (value) => null,
                // value!.isEmpty ? 'Midpoint name is required' : null,
                onSaved: (value) => price = int.tryParse(value ?? ""),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveMidpoint,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _saveMidpoint() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final midpoint = Midpoint(
        description: description,
        arrivalTime: arrivalTime,
        city: midpointCity,
        price: price,
      );
      Navigator.pop(context, midpoint);
    }
  }
}

/// Model

class RouteModel {
  City origin;
  City destination;

  // String origin;
  // String destination;
  DateTime? scheduleDate;
  double? pricePerTraveller;
  List<Midpoint> midpoints;
  String? routeImagePath; // Optional image file path
  List<String>? routeImagePaths; // Optional image file paths
  RouteModel({
    required this.origin,
    required this.destination,
    required this.scheduleDate,
    required this.pricePerTraveller,
    required this.midpoints,
    this.routeImagePath, // Can be null if no image is uploaded
    this.routeImagePaths, // Can be empty if no image is uploaded
  });
}

class Midpoint {
  String? description;
  String? arrivalTime;
  int? price;
  City? city;

  Midpoint({
    this.city,
    this.price,
    this.description,
    this.arrivalTime,
  });
}

/// Upload New Post logic
///
/*
import 'package:dio/dio.dart';

Future<void> uploadRoute(RouteModel route) async {
  Dio dio = Dio();

  FormData formData = FormData.fromMap({
    "origin": route.origin,
    "destination": route.destination,
    "scheduleDate": route.scheduleDate.toIso8601String(),
    "pricePerTraveller": route.pricePerTraveller,
    "midpoints": route.midpoints.map((m) => m.toJson()).toList(),
    if (route.routeImagePath != null)
      "routeImage": await MultipartFile.fromFile(route.routeImagePath!),
  });

  Response response = await dio.post(
    'https://your-api-url.com/upload-route',
    data: formData,
  );

  if (response.statusCode == 200) {
    // Handle success
  } else {
    // Handle error
  }
}

*/
