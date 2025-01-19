/*
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
  double? price;

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
                border: const UnderlineInputBorder(),
                validator: (value) =>
                (value!.isEmpty || !_midpointCityController.isValid)
                    ? 'City name is required'
                    : null,
                labelText: "Midpoint Name",
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
                maxLines: null,
                // value!.isEmpty ? 'Description is required' : null,
                onSaved: (value) => description = value!,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price :'),
                validator: (value) => null,
                // value!.isEmpty ? 'Midpoint name is required' : null,
                onSaved: (value) => price = double.tryParse(value ?? ""),
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
      final midpoint = RouteMidpoint(
        description: description,
        arrivalTime: DateTime.now(),
        city: midpointCity,
        price: price,
      );
      Navigator.pop(context, midpoint);
    }
  }
}

*/
