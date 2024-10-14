import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  _NewRouteUploadScreenState createState() => _NewRouteUploadScreenState();
}

class _NewRouteUploadScreenState extends State<NewRouteUploadScreen> {
  List<RouteModel> routes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Route'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: _buildFormFields()),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleInput(),
          const SizedBox(height: 16),
          _buildDescriptionInput(),
          const SizedBox(height: 16),
          _buildImageCarousel(),
          const SizedBox(height: 16),
          _buildRoutesSummary(),
        ],
      ),
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
        const Text('Images',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
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
      ],
    );
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

  Widget _buildRoutesSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Routes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        routes.isEmpty
            ? const Text('No routes added yet.')
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: routes.length,
                itemBuilder: (context, index) {
                  final route = routes[index];
                  return ListTile(
                    title: Text('${route.origin} to ${route.destination}'),
                    subtitle: Text('Schedule: ${route.scheduleDate.toLocal()}'
                        .split(' ')[0]),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editRoute(route, index);
                      },
                    ),
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

/// Main End
///

class AddRouteScreen extends StatefulWidget {
  final RouteModel? route;

  const AddRouteScreen({super.key, this.route});
  @override
  State<AddRouteScreen> createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  final _formKey = GlobalKey<FormState>();
  late String origin;
  late String destination;
  late DateTime scheduleDate;
  late double pricePerTraveller;
  List<Midpoint> midpoints = [];
  String? routeImagePath; // Path to the selected image
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
      // routeImagePath = widget.route!.routeImagePath;
      routeImagePaths = (widget.route!.routeImagePaths ?? []).isNotEmpty
          ?
          // widget.route!.routeImagePaths!
          widget.route!.routeImagePaths!
          // If a route has a previously uploaded image
          : [];
      // routeImagePaths = widget.route!.routeImagePath != null
      //     ? [
      //         widget.route!.routeImagePath!
      //       ] // If a route has a previously uploaded image
      //     : [];
    } else {
      origin = '';
      destination = '';
      scheduleDate = DateTime.now();
      pricePerTraveller = 0.0;
      midpoints = [];
      // routeImagePath = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // To make the modal full-screen
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.route != null ? 'Edit Route' : 'Add New Route',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Origin',
                      initialValue: origin,
                      onSaved: (value) => origin = value!,
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      label: 'Destination',
                      initialValue: destination,
                      onSaved: (value) => destination = value!,
                    ),
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
                    const SizedBox(
                      height: 16,
                    ),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ],
          ),
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
        const Text(
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
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    midpoints.removeAt(index);
                  });
                },
              ),
            ),
          );
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

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveRoute,
      child: Center(
        child: Text(
          widget.route != null ? 'Save Changes' : 'Add Route',
          style: const TextStyle(fontSize: 16),
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
        // routeImagePath: routeImagePath, // Save image path
        routeImagePath: routeImagePaths.isNotEmpty
            ? routeImagePaths.first
            : null, // Save first image if available
        routeImagePaths: routeImagePaths.isNotEmpty
            ? routeImagePaths
            : null, // Save first image if available
      );
      Navigator.pop(context, route);
    }
  }
}

/// Dialog
///
class AddMidpointDialog extends StatefulWidget {
  const AddMidpointDialog({super.key});

  @override
  _AddMidpointDialogState createState() => _AddMidpointDialogState();
}

class _AddMidpointDialogState extends State<AddMidpointDialog> {
  final _formKey = GlobalKey<FormState>();
  late String description;
  late String arrivalTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Midpoint'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) =>
                  value!.isEmpty ? 'Description is required' : null,
              onSaved: (value) => description = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Arrival Time'),
              validator: (value) =>
                  value!.isEmpty ? 'Arrival Time is required' : null,
              onSaved: (value) => arrivalTime = value!,
            ),
          ],
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
      );
      Navigator.pop(context, midpoint);
    }
  }
}

/// Model

class RouteModel {
  String origin;
  String destination;
  DateTime scheduleDate;
  double pricePerTraveller;
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
  String description;
  String arrivalTime;

  Midpoint({
    required this.description,
    required this.arrivalTime,
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