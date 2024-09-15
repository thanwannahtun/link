import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link/bloc/post_create_util/post_create_util_cubit.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/bloc/theme/theme_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/styles/app_style.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
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

  final ValueNotifier<City?> _fromCityNotifier = ValueNotifier(null);
  final ValueNotifier<City?> _toCityNotifier = ValueNotifier(null);
  final ValueNotifier<DateTime?> _scheduleDateNotifier = ValueNotifier(null);

  DateTime? _seletedDepartureDate;
  DateTime? _seletedArrivalDate;

  late FocusNode _descriptionFocusNode;
  late FocusNode _titleFocusNode;

  final ValueNotifier<bool> _showMidpointCard = ValueNotifier(false);

  final ValueNotifier<bool> _validFromCity = ValueNotifier(false);
  final ValueNotifier<bool> _validToCity = ValueNotifier(false);
  final ValueNotifier<bool> _validScheduleDate = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _postCreateUtilCubit = context.read<PostCreateUtilCubit>();
    _postRouteCubit = context.read<PostRouteCubit>();
    _initFocusNodes();
  }

  @override
  void didChangeDependencies() {
    print("DEPENDENCY CHANDED :: REBUILD!");
    super.didChangeDependencies();
  }

  _initFocusNodes() {
    _descriptionFocusNode = FocusNode();
    _titleFocusNode = FocusNode();
  }

  _disposeNotifiers() {
    _showMidpointCard.dispose();
    _fromCityNotifier.dispose();
    _toCityNotifier.dispose();
    _scheduleDateNotifier.dispose();
    _validFromCity.dispose();
    _validToCity.dispose();
  }

  @override
  void dispose() {
    _disposeFocusNodes();
    _disposeNotifiers();
    super.dispose();
  }

  _unfoucsNode(FocusNode focusNode) {
    FocusScope.of(context).unfocus();
    focusNode.unfocus();
  }

  _disposeFocusNodes() {
    _descriptionFocusNode.dispose();
    _titleFocusNode.dispose();
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
    print("rebuild");

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

                /// [Midpoint]
                /// <Midpoint Card start>
                ValueListenableBuilder<bool>(
                  valueListenable: _showMidpointCard,
                  builder: (context, value, child) {
                    return value
                        ? InkWell(
                            // child: _buildMidpointCard(context),
                            child: _buildRouteInfoCard(context),
                          )
                        : Container();
                  },
                ),

                /// <Midpoint Card End>

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
                            _showBottomSheetTiles(context);
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
                            // print(_xfiles.map((f) {
                            //   print("${f.mimeType} : ${f.path}: ${f.name}");
                            // }));
                            context.read<ThemeCubit>().toggleTheme();
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
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheetTiles(BuildContext context) {
    Context.showBottomSheet(context,
        constraints: const BoxConstraints.expand(height: 200),
        showDragHandle: false,
        padding: const EdgeInsets.all(8),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () async {
                await _pickFromCamera(context);
              },
              leading: const Icon(Icons.camera_alt),
              title: const Text("Choose Photos"),
            ),
            ListTile(
              onTap: () async {
                await _pickFromGallery(context);
              },
              leading: const Icon(Icons.photo_camera_back_outlined),
              title: const Text("Add Images"),
            ),
            ListTile(
              onTap: () {
                showMidpointCard();
              },
              leading: const Icon(Icons.photo_camera_back_outlined),
              title: const Text("Add Routes Info"),
            ),
          ],
        ));
  }

  Widget _buildRouteInfoCard(BuildContext context) {
    return Card.filled(
      color: context.tertiaryColor,
      margin: const EdgeInsets.symmetric(
          horizontal: AppInsets.inset10, vertical: AppInsets.inset8),
      child: Column(children: [
        // date time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: context.onPrimaryColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () async {
                    DateTime? date =
                        await DateTimeUtil.showDateTimePickerDialog(context);

                    if (date != null) {
                      _scheduleDateNotifier.value = date;
                      _validScheduleDate.value = true;
                    }
                  },
                  child: ValueListenableBuilder(
                    valueListenable: _validScheduleDate,
                    builder: (BuildContext context, value, Widget? child) {
                      TextStyle textStyle = value
                          ? TextStyle(color: context.onPrimaryColor)
                          : const TextStyle(color: Colors.red);

                      return ValueListenableBuilder(
                        valueListenable: _scheduleDateNotifier,
                        builder: (BuildContext context, DateTime? value,
                            Widget? child) {
                          return Text(
                            value == null
                                ? "Add Schedule Date"
                                : DateTimeUtil.formatDateTime(value),
                            style: textStyle,
                          ).center();
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            IconButton(
                onPressed: () {
                  _hideMidpointCard(context);
                },
                icon: Icon(
                  Icons.clear,
                  color: context.onPrimaryColor,
                ))
          ],
        ),
        // from & to
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _fromCityField(context).expanded(),
            SizedBox(
              width: 25,
              child: Icon(
                Icons.compare_arrows,
                color: context.onPrimaryColor,
              ),
            ),
            _toCityField().expanded(),
          ],
        ).padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
        // midpoint lines
        _showMidpointTiles(),
        // _midpointListTiles(),
        const SizedBox(
          height: 10,
        ),
        // Button
        ElevatedButton.icon(
          style: AppStyle.buttonExpanded(context),
          onPressed: () {
            _showRouteCityBottomSheet(context);
          },
          label: const Text("Add Middle Routes"),
          icon: const Icon(Icons.add),
          iconAlignment: IconAlignment.start,
        ),
        const SizedBox(
          height: AppInsets.inset5,
        ),
        // mini info
        // _showMidpointDescription(context)
      ]).padding(padding: const EdgeInsets.all(10)),
    );
  }

  // mini info
  // ignore: unused_element
  Text _showMidpointDescription(BuildContext context) {
    return Text(
      "this is short info description",
      style: TextStyle(color: context.onPrimaryColor.withOpacity(0.8)),
      textAlign: TextAlign.center,
    );
  }

  // ignore: unused_element
  ListView _midpointListTiles() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: context.onPrimaryColor,
              ),
              child: ListTile(
                dense: true,
                title: Text(
                  "Yangon",
                  style: TextStyle(
                    color: context.tertiaryColor,
                  ),
                ).bold(),
                trailing: Text(
                  "12-03-20204 11:45 AM",
                  style: TextStyle(
                    color: context.tertiaryColor,
                  ),
                ),
              ),
            ));
  }

  Container _fromCityField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.onPrimaryColor)),
      height: 70,
      child: InkWell(
        onTap: () async {
          City? city = await _chooseCity();

          if (city != null) {
            _fromCityNotifier.value = city;
            _validFromCity.value = true;
          }
        },
        child: ValueListenableBuilder(
          valueListenable: _validFromCity,
          builder: (BuildContext context, value, Widget? child) {
            TextStyle textStyle = value
                ? TextStyle(color: context.onPrimaryColor)
                : const TextStyle(color: Colors.red);

            return ValueListenableBuilder(
              valueListenable: _fromCityNotifier,
              builder: (BuildContext context, City? value, Widget? child) {
                return Text(
                  value == null ? "From" : value.name ?? "",
                  style: textStyle,
                ).center();
              },
            );
          },
        ),
      ),
    );
  }

  Container _toCityField() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white)),
      height: 70,
      child: InkWell(
        onTap: () async {
          City? city = await _chooseCity();

          if (city != null) {
            _toCityNotifier.value = city;
            _validToCity.value = true;
          }
        },
        child: ValueListenableBuilder(
          valueListenable: _validToCity,
          builder: (BuildContext context, value, Widget? child) {
            TextStyle textStyle = value
                ? TextStyle(color: context.onPrimaryColor)
                : const TextStyle(color: Colors.red);

            return ValueListenableBuilder(
              valueListenable: _toCityNotifier,
              builder: (BuildContext context, City? value, Widget? child) {
                return Text(
                  value == null ? "To" : value.name ?? "",
                  style: textStyle,
                ).center();
              },
            );
          },
        ),
      ),
    );
  }

  Future<City?> _chooseCity() async {
    return await Context.showAlertDialog<City>(
      context,
      headerWidget: ListTile(
        leading: const Icon(Icons.location_on_outlined),
        title: const Text("Choose Cities").bold(),
      ).padding(
          padding: const EdgeInsets.symmetric(vertical: AppInsets.inset8)),
      itemList: App.cities,
      itemBuilder: (ctx, index) {
        return StatefulBuilder(
          builder: (BuildContext ctx, void Function(void Function()) setState) {
            return ListTile(
              onTap: () {
                setState(() {});
                Navigator.pop(context, App.cities[index]);
              },
              leading: const Icon(Icons.add_circle_outlined),
              title: Text(App.cities[index].name ?? ""),
            );
          },
        );
      },
    );
  }

  void _hideMidpointCard(BuildContext context) {
    _showMidpointCard.value = false;
    context.showSnackBar(Context.snackBar(
      const Text("Restore Changes").bold(),
      action: SnackBarAction(
          label: "Undo",
          textColor: context.tertiaryColor,
          onPressed: () {
            _showMidpointCard.value = true;
          }),
    ));
  }

  // ignore: unused_element
  Card _buildMidpointCard(BuildContext context) {
    return Card.filled(
      margin: const EdgeInsets.symmetric(
          horizontal: AppInsets.inset10, vertical: AppInsets.inset8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppInsets.inset10, vertical: AppInsets.inset8),
        child: Column(
          children: [_showMidpointTiles(), _addMidpointField(context)],
        ),
      ),
    );
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    return await _picker.pickMultiImage().then(
      (value) async {
        await _postCreateUtilCubit.selectImages(xfiles: value);
        if (context.mounted) context.pop();
      },
    );
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    return await _picker.pickImage(source: ImageSource.camera).then(
      (value) async {
        if (value != null) {
          await _postCreateUtilCubit.selectImages(xfiles: [value]);
          if (context.mounted) {
            context.pop();
          }
        }
      },
    );
  }

  void showMidpointCard() {
    _showMidpointCard.value = true;
    _postCreateUtilCubit.resetMidpoints();
    context.pop();
  }

  BlocBuilder<PostCreateUtilCubit, PostCreateUtilState> _showMidpointTiles() {
    return BlocBuilder<PostCreateUtilCubit, PostCreateUtilState>(
      builder: (context, state) {
        if (state.status == BlocStatus.adding) {
          return Container();
        } else if (state.status == BlocStatus.added) {
          _midpoints = state.midpoints;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _midpoints.length,
            itemBuilder: (context, index) {
              Midpoint midpoint = _midpoints[index];

              return Dismissible(
                // key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                key: Key(midpoint.runtimeType.toString()),
                direction: DismissDirection.endToStart,
                resizeDuration: Durations.long1,
                background: _midpointTileOnDismissedBackground(context),
                onDismissed: (direction) {
                  Midpoint temp = midpoint;
                  _postCreateUtilCubit.removeMidpoint(index: index);
                  context.showSnackBar(
                    Context.snackBar(const Text("Restore Changes"),
                        action: SnackBarAction(
                            label: "Undo",
                            textColor: context.tertiaryColor,
                            onPressed: () {
                              _postCreateUtilCubit.addMidpoint(midpoint: temp);
                            })),
                  );
                },
                child: Card.filled(
                  margin: const EdgeInsets.all(0.0),
                  child: ListTile(
                    onTap: () {},
                    dense: true,
                    // leading: Text((index + 1).toString()),
                    title: Text(
                      midpoint.city?.name ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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

  Container _midpointTileOnDismissedBackground(BuildContext context) {
    return Container(
      color: context.secondaryColor,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: AppInsets.inset15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: context.onPrimaryColor),
                    borderRadius: BorderRadius.circular(AppInsets.inset30)),
                child: const Icon(Icons.delete, color: Colors.red)
                    .padding(padding: const EdgeInsets.all(AppInsets.inset5)),
              ),
              const SizedBox(
                width: AppInsets.inset15,
              ),
              Icon(
                Icons.keyboard_double_arrow_left,
                color: context.onPrimaryColor,
              )
            ],
          ),
        ),
      ),
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
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(context.secondaryColor)),
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
        child: Text(
          "Add Route",
          style: TextStyle(color: context.onPrimaryColor),
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
      decoration:
          AppStyle.inputDecoration(context).copyWith(hintText: "Description"),
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
      decoration: AppStyle.inputDecoration(context).copyWith(
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
      decoration: AppStyle.inputDecoration(context).copyWith(
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
                  title: Text(App.cities[index].name ?? ""),
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
      decoration: AppStyle.inputDecoration(context).copyWith(
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
        } else if (state.status == BlocStatus.added) {
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
                          onPhotoDeleted: (value) =>
                              state.xfiles.removeAt(value),
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
          context.showSnackBar(
            Context.snackBar(
              Text(state.error ?? "Exceed Maximum limit!"),
            ),
          );
        }
      },
    );
  }

  TextField _descriptionField(BuildContext context) {
    return TextField(
        focusNode: _descriptionFocusNode,
        autocorrect: true,
        maxLines: null,
        minLines: 5,
        onTapOutside: (event) => _unfoucsNode(_descriptionFocusNode),
        maxLength: 7000,
        controller: _descriptionController,
        decoration: const InputDecoration(
          hintText: "Dercription",
          border: InputBorder.none,
        ));
  }

  TextField _titleField() {
    return TextField(
        focusNode: _titleFocusNode,
        autocorrect: true,
        maxLines: null,
        minLines: 1,
        onTapOutside: (event) => _unfoucsNode(_titleFocusNode),
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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0.0,
      title: const Text("Create Post"),
      actions: [
        BlocListener<PostRouteCubit, PostRouteState>(
          listener: (BuildContext context, state) {
            SnackBar showSnackBar(String text, Icon icon) {
              return SnackBar(
                  content: Row(
                      children: [icon, const SizedBox(width: 10), Text(text)]));
            }

            if (state.status == BlocStatus.uploadFailed) {
              context.showSnackBar(
                Context.snackBar(const Text("Something went wrong!"),
                    icon: Icon(Icons.warning_rounded,
                        color: context.tertiaryColor)),
              );
            }
            if (state.status == BlocStatus.uploaded) {
              context.showSnackBar(
                Context.snackBar(const Text("Successfully Uploaded"),
                    icon: Icon(Icons.panorama_fish_eye_outlined,
                        color: context.tertiaryColor)),
              );
            }
          },
          child: OutlinedButton(
                  style: AppStyle.buttonDark(context),
                  onPressed: () {
                    _uploadNewPost();
                  },
                  child: Text("Post",
                      style: TextStyle(color: context.onPrimaryColor)))
              .padding(padding: const EdgeInsets.symmetric(horizontal: 10)),
        )
      ],
    );
  }

  void _uploadNewPost() {
    _origin = _fromCityNotifier.value;
    _destination = _toCityNotifier.value;
    Post post = Post(
      agency: Agency(
        id: "66b8d3c63e1a9b47a2c0e6a5",
      ),
      title: _titleController.text,
      description: _descriptionController.text,
      origin: _origin,
      destination: _destination,
      midpoints: _midpoints,
      scheduleDate: _scheduleDateNotifier.value,
      pricePerTraveler: 35000,
    );

    _postRouteCubit.uploadNewPost(
      post: post,
      files: _xfiles.map((xfile) => File(xfile.path)).toList(),
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
