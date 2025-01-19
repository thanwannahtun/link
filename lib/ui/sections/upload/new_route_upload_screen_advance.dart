// ignore_for_file: unused_element

import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/app.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/sections/upload/drop_down_autocomplete.dart';
import 'package:link/ui/sections/upload/post_create/post_create_cubit.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/utils/context.dart';
import 'package:link/ui/utils/snackbar_util.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

import '../../../bloc/routes/post_route_cubit.dart';
import '../../../core/utils/app_insets.dart';
import '../../../models/agency.dart';
import '../../../models/city.dart';

class NewRouteUploadScreen extends StatefulWidget {
  const NewRouteUploadScreen({super.key});

  @override
  State<NewRouteUploadScreen> createState() => _NewRouteUploadScreenState();
}

class _NewRouteUploadScreenState extends State<NewRouteUploadScreen> {
  List<RouteModel> routes = [];
  List<String> images = [];

  late FocusNode _titleFocusNode;
  late FocusNode _descriptionFocusNode;

  late PostCreateCubit _postCreateCubit;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _postCreateCubit = PostCreateCubit();

    _initFocusNodes();
  }

  @override
  void dispose() {
    _disposeFocusNodes();
    super.dispose();
  }

  _initFocusNodes() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _descriptionFocusNode = FocusNode();
    _titleFocusNode = FocusNode();
  }

  _disposeFocusNodes() {
    _titleController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    _titleFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("dependencies changed");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("rebuild");

    return CustomScaffoldBody(
        body: Padding(
          padding: const EdgeInsets.only(
              top: AppInsets.inset15,
              left: AppInsets.inset15,
              right: AppInsets.inset15,
              bottom: 3),
          child: Column(
            children: [
              Expanded(child: _buildFormFields()),
              _buildSubmitButton(),
            ],
          ),
        ),
        title: const Text('Create New Post'),
        action: null,
        backButton: BackButton(
          onPressed: () => context.pop(),
        ));
  }

  Widget _buildFormFields() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildImageCarousel(),
            const SizedBox(height: 8),
            _titleField(),
            const SizedBox(height: 16),
            _descriptionField(context),
            const SizedBox(height: 16),
            _buildRoutesListView(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// START

  Widget _titleField() {
    return TextFormField(
      validator: (value) => (value!.isEmpty) ? 'Title is required!' : null,
      focusNode: _titleFocusNode,
      autocorrect: true,
      maxLines: null,
      minLines: 1,
      onTapOutside: (event) => _titleFocusNode.unfocus(),
      style: Theme.of(context).textTheme.headlineMedium,
      controller: _titleController,
      decoration: const InputDecoration(
        hintText: "Title",
        hintStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: AppInsets.font20),
        border: InputBorder.none,
      ),
    );
  }

  Widget _descriptionField(BuildContext context) {
    return TextFormField(
        validator: (value) =>
            (value!.isEmpty) ? 'Description is required!' : null,
        focusNode: _descriptionFocusNode,
        autocorrect: true,
        maxLines: null,
        minLines: 2,
        onTapOutside: (event) => _descriptionFocusNode.unfocus(),
        style: Theme.of(context).textTheme.bodyLarge,
        // maxLength: 7000,
        controller: _descriptionController,
        decoration: const InputDecoration(
          hintText: "Description",
          border: InputBorder.none,
        ));
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
    final pickedFiles = await ImagePicker().pickMultiImage();
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
  Widget _buildRoutesListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        BlocBuilder<PostCreateCubit, PostCreateState>(
          bloc: _postCreateCubit,
          builder: (context, state) {
            if (state.status == BlocStatus.added) {
              routes = state.routes;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: routes.length,
                itemBuilder: (context, index) {
                  final route = routes[index];
                  return RouteCardWidget(
                    route: route,
                    onEditRoute: () => _editRoute(route, index),
                    onRemoveRoute: () =>
                        _postCreateCubit.updateOrDeleteRoute(index: index),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
        const SizedBox(height: 8),
        Center(
          child: ElevatedButton.icon(
            onPressed: _addNewRoute,
            icon: const Icon(Icons.add),
            label: const Center(
              child: Text(
                'Add Route(s)',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _addNewRoute() async {
    await showModalBottomSheet<Route>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      backgroundColor: context.scaffoldBackgroundColor,
      useSafeArea: true,
      builder: (context) => AddRouteScreen(
        onClosed: (RouteModel? value) {
          if (value != null) {
            _postCreateCubit.addRoute(route: value);
          }
        },
      ),
    );

    // if (newRoute != null) {
    //   _postCreateCubit.addRoute(route: newRoute);
    // }
  }

  void _editRoute(RouteModel route, int index) async {
    // final updatedRoute =
    await showModalBottomSheet<RouteModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      backgroundColor: context.scaffoldBackgroundColor,
      builder: (context) => AddRouteScreen(
        route: route,
        onClosed: (RouteModel? value) {
          if (value != null) {
            _postCreateCubit.updateOrDeleteRoute(
                index: index, routeToUpdate: value);
          }
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
        onPressed: () {
          // Submit to the server
          _uploadRoute();
        },
        child: BlocConsumer<PostRouteCubit, PostRouteState>(
          builder: (BuildContext context, PostRouteState state) {
            if (state.status == BlocStatus.uploading) {
              return const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator.adaptive(strokeWidth: 3),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("uploading..."),
                    ),
                  ],
                ),
              );
            } else if (state.status == BlocStatus.uploadFailed) {
              return const Center(
                child: Text(
                  'Try again',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              );
            }
            return const Center(
              child: Text(
                'Upload Route',
                style: TextStyle(fontSize: 16),
              ),
            );
          },
          listener: (BuildContext context, PostRouteState state) {
            if (state.status == BlocStatus.uploaded) {
              context.pop();
              SnackbarUtils.showSnackBar(context, "Successfully Uploaded",
                  type: SnackBarType.success);
            }
          },
        )).padding(padding: const EdgeInsets.symmetric(vertical: 5));
  }

  _uploadRoute() async {
    final SnackBar requiredRouteSnackBar = SnackBar(
      content: const Text("Add Routes"),
      backgroundColor: context.dangerColor,
      margin: const EdgeInsets.symmetric(
          vertical: (AppInsets.inset30) * 2, horizontal: AppInsets.inset8),
      behavior: SnackBarBehavior.floating,
    );

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (routes.isEmpty) {
        context.showSnackBar(requiredRouteSnackBar);
        return;
      }
      List<File?> files = routes
          .where((r) => r.image != null)
          .map((r) => File(r.image ?? ""))
          .toList();

      final post = Post(
          agency: Agency(id: "66b8d28d3e1a9b47a2c0e69c"),
          title: _titleController.text,
          description: _descriptionController.text,
          routes: routes);
      context.read<PostRouteCubit>().uploadNewPost(post: post, files: files);
    }
  }
}

class PostModel {
  final List<Route> routes;
  final String title;
  final String description;

  PostModel(
      {required this.routes, required this.title, required this.description});
}

class RouteCardWidget extends StatefulWidget {
  final RouteModel route;
  final void Function()? onEditRoute;
  final void Function()? onRemoveRoute;

  const RouteCardWidget(
      {super.key, required this.route, this.onEditRoute, this.onRemoveRoute});

  @override
  State<RouteCardWidget> createState() => _RouteCardWidgetState();
}

class _RouteCardWidgetState extends State<RouteCardWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: const EdgeInsets.all(10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppInsets.inset8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.route.image != null)
              SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Image.file(
                    File(widget.route.image ?? ""),
                    fit: BoxFit.cover,
                  )).clipRRect(borderRadius: BorderRadius.circular(5)),
            const SizedBox(height: 8),

            // Origin & Schedule Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 15,
                    ),
                    Text(
                      widget.route.origin?.name ?? "",
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
            Padding(
              padding: const EdgeInsets.only(left: AppInsets.inset15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildMidpointSummaries(widget.route.midpoints ?? []),
                  if ((widget.route.midpoints?.length ?? 0) > 2)
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
                                  ? Icons.arrow_drop_down_rounded
                                  : Icons.arrow_drop_up_rounded,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Destination & Price Per Traveller
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 15,
                    ),
                    Text(
                      widget.route.destination?.name ?? "",
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
                      widget.route.pricePerTraveller?.toString() ?? "",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ).expanded(),
              ],
            ),
            const SizedBox(height: 8),
            _routeDescriptionWidget(widget.route.description),

            /// Edit Button and Accommodation
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Wrap(
                  children: List<Widget>.generate(
                    5,
                    (index) => Card(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      child: Text("service ${index + 1}").styled(
                          fs: 10, fw: FontWeight.bold, color: Colors.grey),
                    )),
                  ),
                ).expanded(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_square),
                      iconSize: 15,
                      onPressed: widget.onEditRoute,
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      iconSize: 15,
                      onPressed: widget.onRemoveRoute,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _routeDescriptionWidget(String? description) {
    return description != null
        ? Text(
            widget.route.description ?? "",
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
          )
        : Container();
  }

  // Helper to build midpoints summaries with expand/collapse functionality
  List<Widget> _buildMidpointSummaries(List<RouteMidpoint> midpoints) {
    int displayedMidpoints = isExpanded ? midpoints.length : 2;
    return midpoints.take(displayedMidpoints).map((midpoint) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppInsets.inset5),
        child: Opacity(
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
                      Text(
                        midpoint.description ?? "",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                      ),
                  ],
                ).expanded(flex: 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateTimeUtil.formatTime(context,
                          TimeOfDay.fromDateTime(midpoint.arrivalTime!)),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
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
                ).expanded(),
              ],
            )),
      );
    }).toList();
  }
}

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
              top: AppInsets.inset15,
              left: AppInsets.inset15,
              right: AppInsets.inset15,
              bottom: 3),
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
                            widget.route != null
                                ? 'Edit Route'
                                : 'Add New Route',
                            style: Theme.of(context).textTheme.titleMedium,
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
                            validator: (value) =>
                                (value!.isEmpty || !originController.isValid)
                                    ? ''
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
                            labelText: "Destination",
                            validator: (value) => (value!.isEmpty ||
                                    !destinationController.isValid)
                                ? ''
                                : null,
                          ),

                          const SizedBox(height: 8),
                          _buildDatePicker(),
                          const SizedBox(height: 8),
                          _buildTextField(
                              label: 'Price Per Traveller',
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
                          // _buildImagePicker(), // Add image picker here
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

  TextFormField _buildRouteDescriptionInput(BuildContext context) {
    return TextFormField(
        autocorrect: true,
        maxLines: null,
        controller: _routeDescriptionController,
        decoration: InputDecoration(
          hintText: "Description",
          label: const Text("Description(optional)"),
          hintStyle: Theme.of(context).textTheme.labelMedium,
          labelStyle: Theme.of(context).textTheme.labelMedium,
          border: const OutlineInputBorder(
              borderSide: BorderSide(width: 0.05, color: Colors.grey)),
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
            style: TextStyle(fontWeight: FontWeight.bold)),
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
      style: const TextStyle(fontWeight: FontWeight.bold),
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? '' : null,
      onSaved: onSaved,
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _selectDate,
      child: AbsorbPointer(
        child: TextFormField(
          style: const TextStyle(fontWeight: FontWeight.bold),
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
        midpoints.isNotEmpty
            ? const Text(
                'Midpoints',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            : Container(),
        ...midpoints.map((midpoint) {
          int index = midpoints.indexOf(midpoint);
          return Card(
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
                      Text(DateTimeUtil.formatDateTime(midpoint.arrivalTime))
                          .expanded(),
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
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      debugPrint("index ::: $index");
                      midpoints.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          ));
        }),
        const SizedBox(
          height: AppInsets.inset5,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _addMidpoint,
            icon: const Icon(Icons.add),
            label: const Text('Add Midpoint'),
          ),
        ),
      ],
    );
  }

  void _addMidpoint() async {
    final newMidpoint = await showDialog<RouteMidpoint>(
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
