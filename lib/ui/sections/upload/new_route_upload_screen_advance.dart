// ignore_for_file: unused_element

import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/core/utils/platform.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/sections/upload/post_create/post_create_cubit.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/utils/context.dart';
import 'package:link/ui/utils/snackbar_util.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

import '../../../bloc/routes/post_route_cubit.dart';
import '../../../core/utils/app_insets.dart';
import '../../../models/agency.dart';
import 'widgets/add_route_screen.dart';

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
        key: const Key("NewRouteUploadScreen"),
        body: Padding(
          padding: const EdgeInsets.only(
              top: AppInsets.inset15, left: 50, right: 50, bottom: 3),
          child: Column(
            children: [
              Expanded(child: _buildFormFields()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key:const Key("add_route") ,
          backgroundColor: context.successColor,
          onPressed: _addNewRoute,
          tooltip: "New Route",
          child: const Icon(Icons.add),
        ),
        title: Text(
          'Create New Post',
          style: TextStyle(
              color: context.onPrimaryColor,
              fontSize: AppInsets.font20,
              fontWeight: FontWeight.bold),
        ),
        action: Container(
          margin: const EdgeInsets.only(right: AppInsets.inset15),
          child: _buildSubmitButton(),
        ),
        backButton: BackButton(
          onPressed: () => context.pop(),
          color: context.onPrimaryColor,
        ));
  }

  Widget _buildFormFields() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppInsets.inset25),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
    return BlocBuilder<PostCreateCubit, PostCreateState>(
      bloc: _postCreateCubit,
      builder: (context, state) {
        if (state.status == BlocStatus.added) {
          routes = state.routes;
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final mobile = constraints.maxWidth < PlatformType.tablet.width;
              // final laptop = constraints.maxWidth < PlatformType.laptop.width;
              final laptop = constraints.maxWidth < 1000;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: mobile
                      ? 1
                      : laptop
                          ? 2
                          : 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 16,
                  // childAspectRatio: 3,
                ),
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
            },
          );
        } else {
          return Container();
        }
      },
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
    return BlocConsumer<PostRouteCubit, PostRouteState>(
      listener: (BuildContext context, PostRouteState state) {
        if (state.status == BlocStatus.uploaded) {
          /// exit the page
          context.pop();
          SnackbarUtils.showSnackBar(context, "Successfully Uploaded",
              type: SnackBarType.success);
        }
        if (state.status == BlocStatus.uploadFailed) {
          SnackbarUtils.showSnackBar(context, "Failed to upload!",
              type: SnackBarType.error);
        }
      },
      builder: (BuildContext context, PostRouteState state) {
        if (state.status == BlocStatus.uploading) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: null,
            child: const Text("Loading.."),
          );
        }

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade800,
            textStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => _uploadRoute(),
          child: const Text(
            "Upload",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
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
            const Divider(height: 16.0, thickness: 0.05),
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
                            Text(
                              isExpanded ? "Collapse" : "View All",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: context.successColor,
                                  color: context.successColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const Divider(height: 16.0, thickness: 0.05),

            // Destination & Price Per Traveller1
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
            const Divider(height: 16.0, thickness: 0.05),
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
                      color: context.successColor,
                      onPressed: widget.onEditRoute,
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      iconSize: 15,
                      color: context.dangerColor,
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
      return Card(
        margin: const EdgeInsets.only(bottom: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    midpoint.city?.name ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: context.greyColor),
                  ),
                  Text(
                    DateTimeUtil.formatTime(
                        context, TimeOfDay.fromDateTime(midpoint.arrivalTime!)),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((midpoint.description ?? "").isNotEmpty)
                    Text(
                      midpoint.description ?? "",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      softWrap: true,
                    ).expanded(),
                  if (((midpoint.price ?? 0).toString()).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        (midpoint.price ?? 0.0).toString(),
                        style: TextStyle(color: context.greyColor),
                      ),
                    ),
                ],
              ),
              // const Divider(height: 16.0, thickness: 0.05),
            ],
          ),
        ),
      );
    }).toList();
  }
}
