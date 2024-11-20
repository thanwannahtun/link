import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/ui/widget_extension.dart';

import '../../core/utils/app_insets.dart';
import '../../core/utils/date_time_util.dart';
import '../../models/app.dart';
import '../../models/city.dart';
import '../sections/upload/drop_down_autocomplete.dart';

typedef OnSearchRouteCallBack = void Function(
    City? origin, City? destination, DateTime? date);

class LocationSwap extends StatefulWidget {
  const LocationSwap(
      {super.key,
      this.initialOrigin,
      this.initialDestination,
      this.initialDate,
      this.onSearchRouteCallBack});

  final City? initialOrigin;
  final City? initialDestination;
  final DateTime? initialDate;
  final OnSearchRouteCallBack? onSearchRouteCallBack;

  @override
  State<LocationSwap> createState() => _LocationSwapState();
}

class _LocationSwapState extends State<LocationSwap> {
  City? _selectedOrigin;
  City? _selectedDestination;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedOrigin = widget.initialOrigin;
    _selectedDestination = widget.initialDestination;
    _selectedDateTime = widget.initialDate ?? DateTime.now();
  }

  void _swapLocations() {
    setState(() {
      final temp = _selectedOrigin;
      _selectedOrigin = _selectedDestination;
      _selectedDestination = temp;
      widget.onSearchRouteCallBack
          ?.call(_selectedOrigin, _selectedDestination, _selectedDateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LocationInput(
          initialValue: _selectedOrigin,
          hintText: 'Enter origin',
          onChanged: (value) {
            setState(() {
              _selectedOrigin = value;
            });
          },
          key: UniqueKey(),
        ),
        _swapDividerIcon(),
        LocationInput(
          initialValue: _selectedDestination,
          hintText: 'Enter destination',
          onChanged: (value) {
            setState(() {
              _selectedDestination = value;
            });
          },
          key: UniqueKey(),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.1,
        ),
        _buildDateField(context),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Card.filled(
        child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppInsets.inset15,
            ),
            child: InkWell(
              onTap: () async {
                DateTime? value = await showDatePicker(
                    context: context,
                    initialDate: _selectedDateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 10));
                if (value != null) {
                  _selectedDateTime = value;
                  setState(() {});
                }
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.date_range_sharp,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppInsets.inset15),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: context.primaryColor,
                                  style: BorderStyle.solid))),
                      child: Text(
                          DateTimeUtil.formatDate(
                              _selectedDateTime ?? DateTime.now()),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        /// search Icon
        Expanded(child: _searchIcon(context))
      ],
    ));
  }

  Widget _swapDividerIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          color: Colors.grey,
          height: 1,
          thickness: 0.1,
        ).expanded(),
        GestureDetector(
          onTap: () {
            _swapLocations();
            // // _fetchAvailableRoutes();
          },
          child: const Icon(
            Icons.swap_vert_circle,
            size: AppInsets.inset30,
          ),
        )
      ],
    );
  }

  Widget _searchIcon(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.secondaryColor,
          borderRadius: BorderRadius.circular(AppInsets.inset5)),
      child: Column(
        children: [
          IconButton(
            onPressed: () => widget.onSearchRouteCallBack?.call(
                _selectedOrigin, _selectedDestination, _selectedDateTime),
            icon: Icon(
              color: context.onPrimaryColor,
              size: AppInsets.inset35,
              Icons.search_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class LocationInput extends StatefulWidget {
  final City? initialValue;
  final String hintText;
  final Function(City) onChanged;

  const LocationInput({
    super.key,
    this.initialValue,
    required this.hintText,
    required this.onChanged,
  });

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  final CityAutocompleteController _controller = CityAutocompleteController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CityAutocomplete(
      cities: App.cities,
      controller: _controller,
      initialValue: widget.initialValue?.name,
      onSelected: widget.onChanged,
      // labelText: "Origin",
      hintText: widget.hintText,
      validator: (value) =>
          (value!.isEmpty || !_controller.isValid) ? '' : null,
    );
  }
}
