import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link/bloc/post_create_util/post_create_util_cubit.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/core/utils/app_date_util.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/domain/bloc_utils/bloc_crud_status.dart';
import 'package:link/models/agency.dart';
import 'package:link/models/city.dart';
import 'package:link/models/midpoint.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/utils/context.dart';
import 'package:link/ui/utils/widget_util.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:link/ui/widgets/photo_view_gallery_widget.dart';

class UploadNewPostPage extends StatefulWidget {
  const UploadNewPostPage({super.key});

  @override
  State<UploadNewPostPage> createState() => _UploadNewPostPageState();
}

class _UploadNewPostPageState extends State<UploadNewPostPage> {
  late PostCreateUtilCubit _postCreateUtilCubit;
  late PostRouteCubit _postRouteCubit;

  @override
  void initState() {
    _postCreateUtilCubit = context.read<PostCreateUtilCubit>();
    _postRouteCubit = context.read<PostRouteCubit>();
    super.initState();
  }

  // Todo : Post Field section

  City? _origin;
  City? _destination;

  // Todo : Controller section

  final TextEditingController _titleController =
      TextEditingController(text: "");
  final TextEditingController _descriptionController =
      TextEditingController(text: "");
  final TextEditingController _originController =
      TextEditingController(text: "");
  final TextEditingController _destinationController =
      TextEditingController(text: "");
  final TextEditingController _departureTimeController =
      TextEditingController(text: "");
  final TextEditingController _arrivalTimeController =
      TextEditingController(text: "");

  // Todo: Midpoints section
  List<Midpoint> _midpoints = [];

  final TextEditingController _midpointCityController =
      TextEditingController(text: "");
  final TextEditingController _midpointArrivalTimeController =
      TextEditingController();
  final TextEditingController _midpointDescriptionController =
      TextEditingController(text: "");

  List<XFile> _xfiles = [];

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Padding(
      padding: EdgeInsets.only(bottom: !keyboardVisible ? 0.0 : keyboardHeight),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.white70,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.blueGrey.withOpacity(0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "title",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black54,
                          wordSpacing: 5,
                          fontWeight: FontWeight.bold),
                    ).padding(padding: const EdgeInsets.symmetric(vertical: 5)),
                    TextField(
                        autocorrect: true,
                        minLines: 2,
                        maxLines: 5,
                        // autofocus: true,
                        controller: _titleController,
                        decoration: const InputDecoration(
                          fillColor: Colors.white70,
                          filled: true,
                          hintText: "Title",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: InputBorder.none,
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "description",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black54,
                          wordSpacing: 5,
                          fontWeight: FontWeight.bold),
                    ).padding(padding: const EdgeInsets.symmetric(vertical: 5)),
                    TextField(
                        autocorrect: true,
                        maxLines: null,
                        minLines: 5,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        maxLength: 5000,
                        maxLengthEnforcement: MaxLengthEnforcement.none,
                        // expands: true,
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          fillColor: Colors.white70,
                          filled: true,
                          hintText: "Post Dercription",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: InputBorder.none,
                        )),
                  ],
                ).padding(padding: const EdgeInsets.symmetric(horizontal: 8)),
              ),

              // const Divider(
              //   thickness: 0.2,
              // ),

              /// [Origin & Destination]

              Container(
                color: Colors.grey.withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Choose Cities"),
                    const SizedBox(
                      height: AppInsets.inset5,
                    ),

                    // ? : Origin TextField
                    Row(
                      children: [
                        Expanded(
                          // flex: 2,
                          child: WidgetUtil.textField(
                              onTap: () async {
                                City? city = await chooseCity(context);

                                if (city != null) {
                                  _originController.text = city.name ?? "";
                                  _origin = city;
                                }
                              },
                              controller: _originController,
                              fillColor: Colors.white70,
                              hintText: "Origin"),
                        ),
                        const SizedBox(
                          width: AppInsets.inset5,
                        ),
                        Expanded(
                          // flex: 2,
                          child: WidgetUtil.textField(
                              onTap: () async {
                                await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                //   DateTime? selectedDate = await showDatePicker(
                                //     context: context,
                                //     firstDate: DateTime.now(),
                                //     lastDate: DateTime(2025),
                                //   );
                                //   if (selectedDate != null) {
                                //     _departureTimeController.text =
                                //         DateTime.parse(selectedDate.toString())
                                //             .toString();
                                //   }
                              },
                              controller: _departureTimeController,
                              fillColor: Colors.white70,
                              hintText: "Departure Time"),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppInsets.inset10,
                    ),
                    // ? : Destination TextField
                    Row(
                      children: [
                        Expanded(
                          // flex: 2,
                          child: WidgetUtil.textField(
                              onTap: () async {
                                City? city = await chooseCity(context);
                                if (city != null) {
                                  _destinationController.text = city.name ?? "";
                                  _destination = city;
                                }
                              },
                              controller: _destinationController,
                              fillColor: Colors.white70,
                              hintText: "Destination"),
                        ),
                        const SizedBox(
                          width: AppInsets.inset5,
                        ),
                        Expanded(
                          // flex: 2,
                          child: WidgetUtil.textField(
                              onTap: () async {},
                              controller: _arrivalTimeController,
                              fillColor: Colors.white70,
                              hintText: "Arrival Time"),
                        ),
                      ],
                    ),
                  ],
                ).padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: AppInsets.inset10)),
              ),

              /// [Midpoint]

              BlocBuilder<PostCreateUtilCubit, PostCreateUtilState>(
                builder: (context, state) {
                  if (state.status == BlocStatus.doing) {
                    return Container();
                  } else if (state.status == BlocStatus.done) {
                    _midpoints = state.midpoints;
                    return Container(
                      color: Colors.white54,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _midpoints.length,
                          itemBuilder: (context, index) {
                            Midpoint midpoint = _midpoints[index];
                            return Card.filled(
                              color: Colors.white70,
                              margin: const EdgeInsets.all(0.0),
                              child: ListTile(
                                onTap: () {},
                                leading: Text((index + 1).toString()),
                                title: Text(midpoint.city?.name ?? ""),

                                isThreeLine:
                                    midpoint.description != null ? true : false,
                                subtitle: midpoint.description != null
                                    ? Opacity(
                                        opacity: 0.8,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              softWrap: true,
                                              maxLines: 2,
                                              midpoint.description ?? "",
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            Text(
                                              midpoint.arrivalTime != null
                                                  ? AppDateUtil.formatDateTime(
                                                      midpoint.arrivalTime)
                                                  : "",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: AppInsets.font10,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : null,
                                // trailing: ,
                              ),
                            ).padding(
                                padding: const EdgeInsets.only(bottom: 5));
                          },
                          // separatorBuilder: (BuildContext context, int index) =>
                          //     const Divider(
                          //   thickness: 0.3,
                          // ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: 5,
              ),

              // const Divider(
              //   thickness: 0.5,
              // ),

              /// [Midpoint]

              Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 1.0, // Shadow elevation
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.white10),
                              borderRadius:
                                  BorderRadius.circular(3), // Border radius
                            ),
                            textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold), // Text style
                          ),
                          iconAlignment: IconAlignment.end,
                          onPressed: () async {
                            await Context.showBottomSheet(context,
                                useSafeArea: false,
                                isScrollControlled: true,
                                setViewInset: true,
                                body: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextField(
                                      controller: _midpointCityController,
                                      decoration: const InputDecoration(
                                          fillColor: Colors.white70,
                                          filled: true,
                                          prefixIcon:
                                              Icon(Icons.location_on_outlined),
                                          hintText: "City Name",
                                          border: OutlineInputBorder()),
                                    ),
                                    const Divider(
                                      thickness: 0.3,
                                    ),
                                    TextField(
                                      controller:
                                          _midpointArrivalTimeController,
                                      decoration: const InputDecoration(
                                          fillColor: Colors.white70,
                                          filled: true,
                                          prefixIcon: Icon(Icons.date_range),
                                          hintText: "Guess Arrival Time",
                                          border: OutlineInputBorder()),
                                    ),
                                    const Divider(
                                      thickness: 0.3,
                                    ),
                                    TextField(
                                      autocorrect: true,
                                      maxLines: null,
                                      maxLength: 500,
                                      minLines: 4,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.none,
                                      // expands: true,
                                      controller:
                                          _midpointDescriptionController,
                                      decoration: const InputDecoration(
                                        fillColor: Colors.white70,
                                        filled: true,
                                        hintText: "Dercription",
                                        hintStyle:
                                            TextStyle(color: Colors.white54),
                                        // label: Text("Description (optional)"),
                                        labelText: "Description (optional)",

                                        alignLabelWithHint: true,
                                        labelStyle: TextStyle(
                                            fontStyle: FontStyle.italic),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ).padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppInsets.inset15,
                                        vertical: AppInsets.inset10)),
                                persistentFooterButtons: [
                                  SizedBox.expand(
                                      child: OutlinedButton(
                                    onPressed: () {
                                      Midpoint midpoint = Midpoint(
                                          city: City(
                                              name:
                                                  _midpointCityController.text,
                                              id: "city_a"),
                                          arrivalTime: DateTime.parse(
                                            _midpointArrivalTimeController.text,
                                          ),
                                          description:
                                              _midpointDescriptionController
                                                  .text);

                                      _midpointArrivalTimeController.clear();
                                      _midpointCityController.clear();
                                      _midpointDescriptionController.clear();
                                      _postCreateUtilCubit.addMidpoint(
                                          midpoint: midpoint);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("ADD"),
                                  ))
                                ]);
                          },
                          label: const Text("Add middle Cities ( midpoints )"),
                          icon: const Icon(Icons.add)),
                    ),
                  ]),

              const Divider(
                thickness: 0.3,
              ),

              ///< [XFiles] >
              ///
              BlocConsumer<PostCreateUtilCubit, PostCreateUtilState>(
                builder: (context, state) {
                  if (state.status == BlocStatus.initial) {
                    return Container();
                  } else if (state.status == BlocStatus.done) {
                    if (state.xfiles.isEmpty) {
                      return Container();
                    } else {
                      ///

                      _xfiles = [...state.xfiles];

                      ///
                      return SizedBox(
                        height: 250,
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FileViewGalleryWidget(
                                    backgroundDecoration: const BoxDecoration(
                                        color: Colors.black45),
                                    xfiles: _xfiles,
                                  ),
                                ));
                              },
                              child: FileViewGalleryWidget(
                                xfiles: _xfiles,
                              ),
                            ),
                            Positioned(
                              width: 50,
                              height: 50,
                              right: 0,
                              top: 0,
                              child: Container(
                                color: Colors.white24,
                                child: Center(
                                  child: Text(
                                    _xfiles.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    ///
                  }
                  return Container();

                  ///
                },
                listener: (BuildContext context, PostCreateUtilState state) {
                  if (state.status == BlocStatus.limited) {
                    SnackBar snackBar = SnackBar(
                        content: Text(state.error ?? "Exceed Maximum limit!"));
                    Context.showSnackBar(context, snackBar);
                  }
                },
              ),

              ///< [XFiles] />

              // midpointAdding ?   : Container(),
            ],
          ),
        ),
        persistentFooterButtons: [
          Container(
            padding: EdgeInsets.only(
              bottom:
                  keyboardVisible ? MediaQuery.of(context).viewInsets.top : 0,
            ),
            child: SizedBox.expand(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        // onPressed: () async {
                        //   await _picker.pickMultiImage().then(
                        //     (value) async {
                        //       await _postCreateUtilCubit.selectImages(
                        //           xfiles: value);
                        //     },
                        //   );
                        // },
                        onPressed: () {
                          Context.showBottomSheet(context,
                              body: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      await _picker.pickMultiImage().then(
                                        (value) async {
                                          await _postCreateUtilCubit
                                              .selectImages(xfiles: value);
                                        },
                                      );
                                    },
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text("Take Photo"),
                                  ),
                                  const ListTile(
                                    leading:
                                        Icon(Icons.photo_camera_back_outlined),
                                    title: Text("Add Images"),
                                  ),
                                ],
                              ));
                        },
                        icon: const Icon(
                          Icons.add_box_outlined,
                        ),
                      ),

                      /// [Background Color]
                      IconButton(
                        onPressed: () async {
                          await _picker.pickMultiImage().then(
                            (value) async {
                              await _postCreateUtilCubit.selectImages(
                                  xfiles: value);
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.color_lens_outlined,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        style: const ButtonStyle(
                            elevation: WidgetStatePropertyAll(0.3)),
                        child: const Text("Preview"),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<City?> chooseCity(BuildContext context) async {
    List<City> cities = List<City>.generate(
      25,
      (index) => City(id: "${index + 1}", name: "City Name ${index + 1}"),
    );
    FocusScope.of(context).unfocus();
    return await Context.showBottomSheet<City>(
      context,
      useSafeArea: true,
      setViewInset: true,
      isScrollControlled: true,
      showDragHandle: false,
      body: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: cities.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            Navigator.pop<City>(context, cities[index]);
            FocusScope.of(context).unfocus();
          },
          title: Text(
            cities[index].name ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextFormField(
                onTap: () async {},
                // controller: _productController,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  fillColor: Colors.white70,
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: () async {},
                    icon: const Icon(
                      Icons.search_sharp,
                    ),
                  ),
                  hintText: "Search City..",
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black87,
                      width: 0.2,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "$label: ",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: value, border: const OutlineInputBorder()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("Discard Changes ?"),
              ),
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("Discard"))
              ])
            ],
          ),
        );

        ///
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0.0,
      title: const Text("Create Post"),
      actions: [
        ElevatedButton(
            onPressed: () {
              Post post = Post(
                  agency:
                      Agency(id: "66b8d35d3e1a9b47a2c0e6a2", name: "Flyaway"),
                  title: _titleController.text,
                  description: _descriptionController.text,
                  origin: _origin?.copyWith(id: '66b613cd6c17b0be8b372dc5'),
                  midpoints: _midpoints,
                  destination:
                      _destination?.copyWith(id: '66b613cd6c17b0be8b372dc8'),
                  images: _xfiles.map((f) => f.path).toList());
              print("##############################");
              print("newPost : $post");

              _postRouteCubit.uploadNewPost(post: post);
            },
            child: const Text("Post"))
      ],
    );
  }
}

class PostUploadFormFieldWidget extends StatelessWidget {
  const PostUploadFormFieldWidget({
    super.key,
    required TextEditingController nameController,
    required TextEditingController valueController,
    required this.nameHint,
    required this.valueHint,
  })  : _nameController = nameController,
        _valueController = valueController;

  final TextEditingController _nameController;
  final TextEditingController _valueController;
  final String nameHint;
  final String valueHint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              fillColor: Colors.white70,
              filled: true,
              hintText: nameHint,
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 2,
          child: TextField(
            controller: _valueController,
            decoration: InputDecoration(
              hintText: valueHint,
              border: InputBorder.none,
              fillColor: Colors.white70,
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}
