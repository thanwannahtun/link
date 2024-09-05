import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link/bloc/post_create_util/post_create_util_cubit.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/core/styles/app_colors.dart';
import 'package:link/core/styles/app_style.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/domain/bloc_utils/bloc_crud_status.dart';
import 'package:link/models/agency.dart';
import 'package:link/models/app.dart';
import 'package:link/models/city.dart';
import 'package:link/models/midpoint.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/utils/context.dart';
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

  City? selectedCity;

  DateTime? _seletedDepartureDate;
  DateTime? _seletedArrivalDate;

  @override
  void initState() {
    _postCreateUtilCubit = context.read<PostCreateUtilCubit>();
    _postRouteCubit = context.read<PostRouteCubit>();
    super.initState();
  }

  // Todo : Post Field section

  City? _origin;
  City? _destination;

  // Todo: Midpoints section
  List<Midpoint> _midpoints = [];

  // Todo : Controller section

  final TextEditingController _titleController =
      TextEditingController(text: "");
  final TextEditingController _descriptionController =
      TextEditingController(text: "");
  // final TextEditingController _originController =
  //     TextEditingController(text: "");
  // final TextEditingController _destinationController =
  //     TextEditingController(text: "");
  // final TextEditingController _departureTimeController =
  //     TextEditingController(text: "");
  // final TextEditingController _arrivalTimeController =
  //     TextEditingController(text: "");

  final TextEditingController _midpointCityController =
      TextEditingController(text: "");
  final TextEditingController _midpointDepartureTimeController =
      TextEditingController();
  final TextEditingController _midpointArrivalDateController =
      TextEditingController();
  final TextEditingController _midpointDescriptionController =
      TextEditingController(text: "");

  List<XFile> _xfiles = [];

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Padding(
      padding: EdgeInsets.only(bottom: !keyboardVisible ? 0.0 : keyboardHeight),
      child: Theme(
        data: Theme.of(context).copyWith(
            dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        )),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _xFiledDisplayer(),

                const SizedBox(height: 5),

                _titleField().padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppInsets.inset8)),
                const SizedBox(height: 5),
                _descriptionField(context).padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppInsets.inset10, vertical: 5),
                ),

                /// [Origin & Destination]
/*
                Column(
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
*/
                /// [Midpoint]

                Card.filled(
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppInsets.inset10,
                      vertical: AppInsets.inset8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppInsets.inset10,
                        vertical: AppInsets.inset8),
                    child: Column(
                      children: [
                        _showMidpointTiles(),
                        _addMidpointField(context)
                      ],
                    ),
                  ),
                ),

                const Divider(
                  thickness: 0.3,
                ),
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
                          onPressed: () {
                            Context.showBottomSheet(context,
                                constraints:
                                    const BoxConstraints.expand(height: 200),
                                showDragHandle: false,
                                padding: const EdgeInsets.all(8),
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
                                      leading: Icon(
                                          Icons.photo_camera_back_outlined),
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
                            Context.showBottomSheet(context,
                                constraints:
                                    const BoxConstraints.expand(height: 250),
                                showDragHandle: false,
                                padding: const EdgeInsets.all(8),
                                body: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [],
                                    ),
                                    Row(),
                                  ],
                                ));
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
                          onPressed: () {
                            print(_xfiles.map((f) {
                              print("${f.mimeType} : ${f.path}: ${f.name}");
                            }));
                          },
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
      ),
    );
  }

  BlocBuilder<PostCreateUtilCubit, PostCreateUtilState> _showMidpointTiles() {
    return BlocBuilder<PostCreateUtilCubit, PostCreateUtilState>(
      builder: (context, state) {
        if (state.status == BlocStatus.doing) {
          return Container();
        } else if (state.status == BlocStatus.done) {
          _midpoints = state.midpoints;
          return ListView.builder(
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

                  isThreeLine: midpoint.description != null ? true : false,
                  subtitle: midpoint.description != null
                      ? Opacity(
                          opacity: 0.8,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                softWrap: true,
                                maxLines: 2,
                                midpoint.description ?? "",
                                style: const TextStyle(
                                    fontSize: 13,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              // Row(
                              // children: [
                              // const Icon(
                              //   Icons.date_range,
                              //   size: AppInsets.inset15,
                              // ),
                              Row(
                                children: [
                                  Text(
                                    midpoint.departureTime != null
                                        ? DateTimeUtil.formatDateTime(
                                            midpoint.departureTime)
                                        : "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppInsets.font10,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_right_alt_rounded),
                                  Text(
                                    midpoint.arrivalTime != null
                                        ? DateTimeUtil.formatDateTime(
                                            midpoint.arrivalTime)
                                        : "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppInsets.font10,
                                    ),
                                  )
                                ],
                              ),
                              // ],
                              // )
                            ],
                          ),
                        )
                      : null,
                  // trailing: ,
                ),
              ).padding(padding: const EdgeInsets.only(bottom: 5));
            },
            // separatorBuilder: (BuildContext context, int index) =>
            //     const Divider(
            //   thickness: 0.3,
            // ),
          );
        }
        return Container();
      },
    );
  }

  Widget _addMidpointField(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton.icon(
                style: AppStyle.buttonDark(context),
                iconAlignment: IconAlignment.end,
                onPressed: () async {
                  await _showRouteCityBottomSheet(context);
                },
                label: const Text("Add middle Cities ( midpoints )"),
                icon: const Icon(Icons.add)),
          ),
        ]);
  }

  Future<dynamic> _showRouteCityBottomSheet(BuildContext context) {
    return Context.showBottomSheet(context,
        useSafeArea: true,
        isScrollControlled: true,
        setViewInset: true,
        showDragHandle: false,
        backgroundColor: AppColors.white,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppInsets.inset15),
            const Text("Cities Schedule").bold(textAlign: TextAlign.start),
            const SizedBox(height: AppInsets.inset15),
            _chooseCityName(),
            const SizedBox(height: AppInsets.inset15),
            const Text("Date*").bold(textAlign: TextAlign.start),
            _chooseDepartureDateChoiceDialog(),
            const SizedBox(height: AppInsets.inset15),
            const Text("Time*").bold(textAlign: TextAlign.start),
            // _showTimePickerDialog(context),
            _chooseArrivalDateChoiceDialog(),
            const SizedBox(height: AppInsets.inset15),
            const Text("Description(optional)")
                .bold(textAlign: TextAlign.start),
            _writeCityDescripton(),
            const SizedBox(height: AppInsets.inset15),
            _chowPrivacyInfo(),
          ],
        ).padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppInsets.inset15, vertical: AppInsets.inset10),
        ),
        persistentFooterButtons: [_addRoutePersistentButton(context)]);
  }

  Widget _addRoutePersistentButton(BuildContext context) {
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) setState) {
      return SizedBox.expand(
          child: OutlinedButton(
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.black)),
        onPressed: () {
          Midpoint midpoint = Midpoint(
              city: selectedCity,
              departureTime: _seletedDepartureDate,
              arrivalTime: _seletedArrivalDate,
              description: _midpointDescriptionController.text);

          _seletedArrivalDate = null;
          _seletedDepartureDate = null;

          _midpointCityController.clear();
          _midpointDescriptionController.clear();
          _postCreateUtilCubit.addMidpoint(midpoint: midpoint);
          Navigator.pop(context);
          setState(() {});
        },
        child: const Text(
          "Add Route",
          style: TextStyle(color: Colors.white),
        ),
      ));
    });
  }

  Row _chowPrivacyInfo() {
    return const Row(
      children: [
        Icon(Icons.workspace_premium_rounded),
        Expanded(
          child:
              Text("We use this info to show the relevant info for the query"),
        )
      ],
    );
  }

  TextField _writeCityDescripton() {
    return TextField(
      autocorrect: true,
      maxLines: null,
      maxLength: 500,
      minLines: 4,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      // expands: true,
      controller: _midpointDescriptionController,
      decoration: AppStyle.inputDecoration.copyWith(hintText: "Description"),
    );
  }

  // TextField _showTimePickerDialog(BuildContext context) {
  //   return TextField(
  //     onTap: () async {
  //       TimeOfDay? time = await showTimePicker(
  //         context: context,
  //         initialTime: TimeOfDay.now(),
  //       );

  //       if (time != null) {
  //         if (context.mounted) {
  //           _midpointArrivalTimeController.text = time.format(context);
  //         }
  //       }
  //     },
  //     readOnly: true,
  //     controller: _midpointArrivalTimeController,
  //     decoration: AppStyle.inputDecoration.copyWith(
  //       hintText: TimeOfDay.now().format(context),
  //       suffixIcon: const Icon(Icons.access_time),
  //     ),
  //   );
  // }

  TextField _chooseDepartureDateChoiceDialog() {
    return TextField(
      onTap: () async {
        // DateTime? date = await showDatePicker(
        //     context: context,
        //     firstDate: DateTime.now(),
        //     lastDate: DateTime(2025));
        DateTime? date = await DateTimeUtil.showDateTimePickerDialog(context);

        if (date != null) {
          _seletedDepartureDate = date;
          _midpointDepartureTimeController.text =
              DateTimeUtil.formatDateTime(date);
          // DateTime.parse(date.toIso8601String()).toString();
        }
      },
      readOnly: true,
      controller: _midpointDepartureTimeController,
      decoration: AppStyle.inputDecoration.copyWith(
        suffixIcon: const Icon(Icons.date_range_rounded),
        hintText:
            " ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
      ),
    );
  }

  TextField _chooseArrivalDateChoiceDialog() {
    return TextField(
      onTap: () async {
        DateTime? date = await DateTimeUtil.showDateTimePickerDialog(context);

        if (date != null) {
          _seletedArrivalDate = date;
          _midpointArrivalDateController.text =
              DateTimeUtil.formatDateTime(date);
          // DateTime.parse(date.toIso8601String()).toString();
        }
      },
      readOnly: true,
      controller: _midpointArrivalDateController,
      decoration: AppStyle.inputDecoration.copyWith(
        suffixIcon: const Icon(Icons.date_range_rounded),
        hintText:
            " ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
      ),
    );
  }

  TextField _chooseCityName() {
    return TextField(
      onTap: () async {
        City? city = await Context.showAlertDialog<City>(
          context,
          headerWidget: ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text("Choose Cities").bold(),
          ).padding(
              padding: const EdgeInsets.symmetric(vertical: AppInsets.inset8)),
          itemList: App.cities,
          itemBuilder: (ctx, index) {
            return StatefulBuilder(
              builder:
                  (BuildContext ctx, void Function(void Function()) setState) {
                return ListTile(
                  onTap: () {
                    setState(() {});
                    Navigator.pop(context, App.cities[index]);
                  },
                  leading: const Icon(Icons.add_circle_outlined),
                  title: Expanded(child: Text(App.cities[index].name ?? "")),
                );
              },
            );
          },
        );

        if (city != null) {
          selectedCity = city;
          _midpointCityController.text = city.name ?? "HELLo";
        }
      },
      readOnly: true,
      controller: _midpointCityController,
      decoration: AppStyle.inputDecoration.copyWith(
        hintText: "City Name",
        suffixIcon: const Icon(Icons.location_on_outlined),
      ),
    );
  }

  BlocConsumer<PostCreateUtilCubit, PostCreateUtilState> _xFiledDisplayer() {
    return BlocConsumer<PostCreateUtilCubit, PostCreateUtilState>(
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
                          backgroundDecoration:
                              const BoxDecoration(color: Colors.black45),
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
          SnackBar snackBar =
              SnackBar(content: Text(state.error ?? "Exceed Maximum limit!"));
          Context.showSnackBar(context, snackBar);
        }
      },
    );
  }

  TextField _descriptionField(BuildContext context) {
    return TextField(
        autocorrect: true,
        maxLines: null,
        minLines: 5,
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
        maxLength: 7000,
        // expands: true,
        controller: _descriptionController,
        decoration: const InputDecoration(
          hintText: "Dercription",
          border: InputBorder.none,
        ));
  }

  TextField _titleField() {
    return TextField(
        autocorrect: true,
        maxLines: null,
        minLines: 1,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: AppInsets.font20),
        controller: _titleController,
        decoration: const InputDecoration(
          hintText: "Title",
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: AppInsets.font20),
          border: InputBorder.none,
        ));
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
              _origin = _midpoints.firstOrNull?.city;
              _destination = _midpoints.lastOrNull?.city;

              Post post = Post(
                  agency: Agency(
                      id: "66b8d2ff3e1a9b47a2c0e69f",
                      name: "Asia World",
                      profileImage: "profile_image"),
                  title: _titleController.text,
                  description: _descriptionController.text,
                  origin: _origin,
                  midpoints: _midpoints,
                  destination: _destination,
                  // images: _xfiles.map((f) => f.path).toList(),
                  scheduleDate: DateTime(2025, 9, 7, 17, 30),
                  pricePerTraveler: 50000);

              /*
                  {
  "agency": "66b8d28d3e1a9b47a2c0e69c",
  "origin": "66b613cd6c17b0be8b372dc7",
  "destination": "66b613cd6c17b0be8b372dce",
  "scheduleDate": "2024-09-01T09:00:00.000Z",
  "pricePerTraveler": 38000,
  "title": "Travel around the world with us!",
  "description": "Happy Travelling!😎😎."
}

                   */

              _postRouteCubit.uploadNewPost(
                post: post,
                files: _xfiles.map((xfile) => File(xfile.path)).toList(),
              );
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
    print("rebuild==========================");
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
