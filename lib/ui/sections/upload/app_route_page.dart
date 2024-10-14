import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewRouteUploadScreenSimple extends StatefulWidget {
  const NewRouteUploadScreenSimple({super.key});
  @override
  State<NewRouteUploadScreenSimple> createState() =>
      _NewRouteUploadScreenSimpleState();
}

class _NewRouteUploadScreenSimpleState
    extends State<NewRouteUploadScreenSimple> {
  List<Map<String, dynamic>> routes = [{}]; // A list of routes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Route'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleInput(),
              const SizedBox(height: 16),
              _buildDescriptionInput(),
              const SizedBox(height: 16),
              _buildImageCarousel(),
              const SizedBox(height: 16),
              _buildRoutesList(),
              _buildAddMoreRouteButton(),
              const SizedBox(height: 16),
              _buildSubmitButton(),
            ],
          ),
        ),
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

  Widget _buildRoutesList() {
    return Column(
      children: List.generate(routes.length, (index) {
        return _buildRouteCard(index);
      }),
    );
  }

  Widget _buildRouteCard(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(label: 'Origin'),
            const SizedBox(height: 8),
            _buildTextField(label: 'Destination'),
            const SizedBox(height: 8),
            _buildTextField(label: 'Schedule Date'),
            const SizedBox(height: 8),
            _buildTextField(label: 'Price Per Traveller'),
            const SizedBox(height: 16),
            _buildMidpointsList(index),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildMidpointsList(int routeIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Midpoints',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 3, // Here you can add dynamic count as well
          itemBuilder: (context, index) {
            return Column(
              children: [
                _buildTextField(label: 'Midpoint Description'),
                const SizedBox(height: 8),
                _buildTextField(label: 'Arrival Time'),
                const SizedBox(height: 8),
              ],
            );
          },
        ),
        TextButton.icon(
          onPressed: () {
            // Add new midpoint logic
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Midpoint'),
        ),
      ],
    );
  }

  Widget _buildAddMoreRouteButton() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          routes.add({});
        });
      },
      icon: const Icon(Icons.add),
      label: const Text('Add More Route'),
    );
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

/// AddRoutePage
class AddRoutePage extends StatefulWidget {
  const AddRoutePage({super.key});

  @override
  State<AddRoutePage> createState() => _AddRoutePageState();
}

class _AddRoutePageState extends State<AddRoutePage> {
  // Placeholder variables for the inputs
  String title = '';
  String description = '';
  List<String> images = [
    "https://img.freepik.com/free-photo/baby-is-happy-bed_1150-15663.jpg?t=st=1728916851~exp=1728920451~hmac=10fd74f2c0ffa388a4f174a87376af6ac7ea7f17f27f5857e7f519593e16ffaf&w=740",
    "https://img.freepik.com/free-photo/portrait-young-family_1328-3800.jpg?t=st=1728916854~exp=1728920454~hmac=f10ac00aadbf9060ad9a854dd2d438424e3ef2c45bccf55225e19a1ab264cd52&w=740",
    "https://img.freepik.com/free-photo/happy-baby-sitting-white-bed_1150-15661.jpg?t=st=1728916857~exp=1728920457~hmac=fb276291b5cb5af2947a441029f4757cf45c90d30fc46d73b68625419016c028&w=740",
    "https://img.freepik.com/free-photo/baby-is-happy-bed_1150-15663.jpg?t=st=1728916851~exp=1728920451~hmac=10fd74f2c0ffa388a4f174a87376af6ac7ea7f17f27f5857e7f519593e16ffaf&w=740",
    "https://img.freepik.com/free-photo/portrait-young-family_1328-3800.jpg?t=st=1728916854~exp=1728920454~hmac=f10ac00aadbf9060ad9a854dd2d438424e3ef2c45bccf55225e19a1ab264cd52&w=740",
    "https://img.freepik.com/free-photo/happy-baby-sitting-white-bed_1150-15661.jpg?t=st=1728916857~exp=1728920457~hmac=fb276291b5cb5af2947a441029f4757cf45c90d30fc46d73b68625419016c028&w=740"
  ];
  List<RouteModel> routes = [RouteModel()]; // List to store routes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Route'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitleAndDescription(),
            buildImageCarousel(),
            ...routes.asMap().entries.map((entry) {
              int index = entry.key;
              return buildRouteCard(index);
            }),
            buildAddRouteButton(),
            buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  /// Title & Description
  Widget buildTitleAndDescription() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Post Title', style: Theme.of(context).textTheme.headlineMedium),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Enter the title of your post',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Handle title input
            },
          ),
          const SizedBox(height: 16),
          Text('Description', style: Theme.of(context).textTheme.headlineLarge),
          TextField(
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Enter the description',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Handle description input
            },
          ),
        ],
      ),
    );
  }

  /// Image Carousel

  Widget buildImageCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Images', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Image.network(
                      images[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          // Handle image removal
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            // Handle image picker
            ImagePicker().pickMultiImage();
          },
          icon: const Icon(Icons.add_a_photo),
          label: const Text('Add Images'),
        ),
      ],
    );
  }

  /// Route Lists
  Widget buildRouteCard(int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Route ${index + 1}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: 'Origin City'),
              onChanged: (value) {
                // Handle origin city input
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Destination City'),
              onChanged: (value) {
                // Handle destination city input
              },
            ),
            const SizedBox(height: 8),
            Text('Schedule Date', style: Theme.of(context).textTheme.bodyLarge),
            ElevatedButton(
              onPressed: () {
                // Open Date Picker
              },
              child: const Text('Select Date'),
            ),
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Price per Traveller'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Handle price input
              },
            ),
            const SizedBox(height: 8),
            buildMidpointsSection(index),
          ],
        ),
      ),
    );
  }

  Widget buildMidpointsSection(int routeIndex) {
    final List<Midpoint> midpoints = routes[routeIndex].midpoints;
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Midpoints', style: Theme.of(context).textTheme.bodyLarge),
        ListView.builder(
          shrinkWrap: true, // Important to avoid the unbounded height error
          itemCount: midpoints.length,
          itemBuilder: (context, midIndex) {
            return Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Midpoint City'),
                  onChanged: (value) {
                    // Handle midpoint input
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Arrival Time (Optional)'),
                  onChanged: (value) {
                    // Handle arrival time input
                  },
                ),
              ],
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            // Add new midpoint
          },
          child: const Text('Add Midpoint'),
        ),
      ],
    );

    return ListView.builder(
      shrinkWrap: true,
      itemCount: midpoints.length,
      itemBuilder: (context, midpointIndex) {
        return Card(
          child: ListTile(
            title: Text(midpoints[midpointIndex].city),
            subtitle:
                Text(midpoints[midpointIndex].description ?? "No description"),
            trailing: Text(midpoints[midpointIndex].arrivalTime != null
                ? midpoints[midpointIndex].arrivalTime.toString()
                : "No time set"),
          ),
        );
      },
    );
  }

  /// More Route Button
  Widget buildAddRouteButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: () {
          // Add new route to the list
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Another Route'),
      ),
    );
  }

  /// Submit Button
  Widget buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // Send all the data to the server
        },
        child: const Text('Submit Post'),
      ),
    );
  }

  /// State Ful Widget
  ///
}

/// Model
class RouteModel {
  String originCity;
  String destinationCity;
  DateTime? scheduleDate;
  double? pricePerTraveller;
  List<Midpoint> midpoints;

  RouteModel({
    this.originCity = '',
    this.destinationCity = '',
    this.scheduleDate,
    this.pricePerTraveller,
    this.midpoints = const [],
  });

  // Optional: Convert to JSON method for sending the data to the server
  Map<String, dynamic> toJson() {
    return {
      'originCity': originCity,
      'destinationCity': destinationCity,
      'scheduleDate': scheduleDate?.toIso8601String(),
      'pricePerTraveller': pricePerTraveller,
      'midpoints': midpoints.map((midpoint) => midpoint.toJson()).toList(),
    };
  }
}

class Midpoint {
  String city;
  String? description;
  DateTime? arrivalTime;

  Midpoint({
    this.city = '',
    this.description,
    this.arrivalTime,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'description': description,
      'arrivalTime': arrivalTime?.toIso8601String(),
    };
  }
}
