import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:link/bloc/city/city_cubit.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/bloc/theme/theme_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/domain/api_utils/api_query.dart';
import 'package:link/domain/api_utils/search_routes_query.dart';
import 'package:link/domain/enums/category_type.dart';
import 'package:link/models/city.dart';
import 'package:link/repositories/post_route.dart';
import 'package:link/ui/sections/hero_home/widgets/suggested_routes_list.dart';
import 'package:link/ui/sections/hero_home/widgets/trending_and_hot_routes_list.dart';
import 'package:link/ui/sections/upload/drop_down_autocomplete.dart';
import 'package:link/ui/utils/route_list.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

class HeroHomeScreen extends StatefulWidget {
  const HeroHomeScreen({super.key});

  @override
  State<HeroHomeScreen> createState() => _HeroHomeScreenState();
}

class _HeroHomeScreenState extends State<HeroHomeScreen> {
  late final ValueNotifier<DateTime?> _selectedDateNotifier;

  late final PostRouteCubit _trendingRouteBloc;
  late final PostRouteCubit _suggestedRouteBloc;

  final ValueNotifier<City?> _originNotifier = ValueNotifier(null);
  final ValueNotifier<City?> _destinationNotifier = ValueNotifier(null);

  final _originAutoCompleteController = CityAutocompleteController();
  final _destinationAutoCompleteController = CityAutocompleteController();

  final _originDestinationFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("initStateCalled  :HeroHomeScreen");
    }
    _trendingRouteBloc =
        PostRouteCubit(postRouteRepo: context.read<PostRouteRepo>())
          ..getRoutesByCategory(
              query: APIQuery(categoryType: CategoryType.trendingRoutes));
    _suggestedRouteBloc =
        PostRouteCubit(postRouteRepo: context.read<PostRouteRepo>())
          ..getRoutesByCategory(
              query: APIQuery(categoryType: CategoryType.suggestedRoutes));
    _selectedDateNotifier = ValueNotifier(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator.adaptive(
        onRefresh: _onRefresh,
        child: _heroBody(context),
      ),
      title: Text(
        "Home",
        style: TextStyle(
            color: context.onPrimaryColor,
            fontSize: AppInsets.font25,
            fontWeight: FontWeight.bold),
      ),
      action: _actionWidgets(context),
    );
  }

  Future<void> _onRefresh() async {
    context.read<CityCubit>().fetchCities();
    _suggestedRouteBloc
      ..clearRoutes()
      ..updatePage();
    _trendingRouteBloc
      ..clearRoutes()
      ..updatePage();
    _trendingRouteBloc.getRoutesByCategory(
        query: APIQuery(categoryType: CategoryType.trendingRoutes));
    _suggestedRouteBloc.getRoutesByCategory(
        query: APIQuery(categoryType: CategoryType.suggestedRoutes));
  }

  Row _actionWidgets(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            icon: Icon(
              Icons.notifications_rounded,
              color: context.onPrimaryColor,
            ))
      ],
    );
  }

  Widget _heroBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _originDestinationCard(context),
            _dateChoiceActionCard(),
            const SizedBox(height: AppInsets.inset8),
            Container(
              padding: const EdgeInsets.only(bottom: AppInsets.inset5),
              margin: const EdgeInsets.all(0.0),
              color: Theme.of(context).cardColor.withOpacity(0.5),
              child: Column(
                children: [
                  _trendingSearchTitleField(context),
                  SizedBox(
                    height: 200,
                    child: BlocProvider.value(
                      value: _trendingRouteBloc,
                      child: const TrendingAndHotRoutesList(),
                    ),
                  ),
                ],
              ).padding(padding: const EdgeInsets.all(5)),
            ),
            const SizedBox(
              height: AppInsets.inset8,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: AppInsets.inset5),
              margin: const EdgeInsets.all(0.0),
              color: Theme.of(context).cardColor.withOpacity(0.5),
              child: Column(
                children: [
                  _sponsoredPostsTitleField(context),
                  const SizedBox(
                    height: AppInsets.inset8,
                  ),
                  SizedBox(
                      height: 380,
                      child: BlocProvider.value(
                        value: _suggestedRouteBloc,
                        child: const SuggestedRoutesList(),
                      )),
                  _suggestedViewAllAction(context),
                ],
              ).padding(padding: const EdgeInsets.all(5)),
            ),
            const SizedBox(height: AppInsets.inset8),
          ],
        ),
      ),
    );
  }

  Widget _trendingSearchTitleField(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Trending & Hot",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () {
                APIQuery query = APIQuery(
                    categoryType: CategoryType.trendingRoutes, limit: 10);
                context.pushNamed(RouteLists.showRoutesByCategoryScreen,
                    arguments: {"query": query});
              },
              icon: const Icon(Icons.keyboard_arrow_right_sharp)),
        ],
      ),
    );
  }

  Widget _suggestedViewAllAction(BuildContext context) {
    return InkWell(
      onTap: () {
        _viewAllSuggestedRoutes();
      },
      child: Opacity(
        opacity: 0.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "View All",
              style: GoogleFonts.robotoMono(
                fontSize: 12,
              ),
            ).styled(),
            const Icon(Icons.keyboard_double_arrow_right_outlined)
          ],
        ),
      ),
    );
  }

  Widget _sponsoredPostsTitleField(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Suggested For you",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
              onPressed: () {
                APIQuery query = APIQuery(
                    categoryType: CategoryType.suggestedRoutes, limit: 10);
                context.pushNamed(RouteLists.showRoutesByCategoryScreen,
                    arguments: {"query": query});
              },
              icon: const Icon(Icons.keyboard_arrow_right_sharp)),
        ],
      ),
    );
  }

  Card _dateChoiceActionCard() {
    return Card.filled(
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppInsets.inset15, vertical: AppInsets.inset8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "When you want to go?",
                      ),
                      const SizedBox(
                        height: AppInsets.inset15,
                      ),
                      InkWell(
                        onTap: () async {
                          DateTime? value = await showDatePicker(
                              context: context,
                              initialDate: _selectedDateNotifier.value,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 10));
                          if (value != null) {
                            _selectedDateNotifier.value = value;
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
                              child: ValueListenableBuilder<DateTime?>(
                                valueListenable: _selectedDateNotifier,
                                builder: (context, value, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: context.primaryColor,
                                                style: BorderStyle.solid))),
                                    child: Text(
                                        DateTimeUtil.formatDate(
                                            value ?? DateTime.now()),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  /// How many people
                  // const Column(
                  //   children: [
                  //     Icon(Icons.arrow_drop_up_rounded),
                  //     Text('5'),
                  //     Icon(Icons.arrow_drop_down_rounded),
                  //   ],
                  // )
                ],
              ),
            ),
          ),

          /// search Icon
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: context.secondaryColor,
                  borderRadius: BorderRadius.circular(AppInsets.inset5)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppInsets.inset25),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        _navigateToSearchedRoutesScreen();
                      },
                      icon: Icon(
                        color: context.onPrimaryColor,
                        size: AppInsets.inset35,
                        Icons.search_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _navigateToSearchedRoutesScreen() {
    if (_originDestinationFormKey.currentState?.validate() ?? false) {
      _originDestinationFormKey.currentState?.save();

      if (kDebugMode) {
        print("""
          
          ${_originNotifier.value?.name} - ${_destinationNotifier.value?.name} "
          
          """);
      }
      if (_originNotifier.value == null || _destinationNotifier.value == null) {
        return;
      }

      SearchRoutesQuery searchedRouteQuery = SearchRoutesQuery(
          origin: _originNotifier.value,
          destination: _destinationNotifier.value,
          date: _selectedDateNotifier.value);

      APIQuery query = APIQuery(
          categoryType: CategoryType.searchedRoutes,
          searchedRouteQuery: searchedRouteQuery);

      context.pushNamed(
        RouteLists.searchRoutesScreen,
        arguments: {"query": query},
      );
    }
  }

  Widget _originDestinationCard(BuildContext context) {
    return BlocBuilder<CityCubit, CityState>(
      builder: (BuildContext context, CityState state) {
        return Card.filled(
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _originDestinationFormKey,
              child: Column(
                children: [
                  /// FROM
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: _originNotifier,
                          builder: (BuildContext context, City? value,
                              Widget? child) {
                            return CityAutocomplete(
                              cities: state.cities,
                              controller: _originAutoCompleteController,
                              onSelected: (city) {
                                _originNotifier.value = city;
                              },
                              border: InputBorder.none,
                              // labelText: "Origin",
                              fillColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              filled: true,
                              hintText: "From Origin",
                              validator: (value) => (value!.isEmpty ||
                                      !_originAutoCompleteController.isValid)
                                  ? ''
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.1,
                  ),

                  /// REMOVE SWAP LOCATIONS IN HOME SCREEN
                  /*
                /// DIVIDER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.keyboard_double_arrow_down,
                        color: Colors.grey, size: AppInsets.inset30),
                    const Divider(color: Colors.grey, height: 1, thickness: 0.1)
                        .expanded(),
                    InkWell(
                      onTap: () {
                        City? origin = _originNotifier.value;
                        City? destination = _destinationNotifier.value;
                        _originNotifier.value = destination;
                        _destinationNotifier.value = origin;
                        _destinationAutoCompleteController.text =
                            _originAutoCompleteController.text;
                        _originAutoCompleteController.text =
                            _destinationAutoCompleteController.text;
                      },
                      child: const Icon(
                        Icons.swap_vert_circle,
                        size: AppInsets.inset30,
                      ),
                    )
                  ],
                ),
            */

                  /// TO
                  Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: _destinationNotifier,
                          builder: (BuildContext context, City? value,
                              Widget? child) {
                            return CityAutocomplete(
                              cities: state.cities,
                              controller: _destinationAutoCompleteController,
                              onSelected: (city) {
                                _destinationNotifier.value = city;
                              },
                              fillColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              filled: true,
                              border: InputBorder.none,
                              // labelText: "Destination",
                              hintText: "To Destination",
                              validator: (value) => (value!.isEmpty ||
                                      !_destinationAutoCompleteController
                                          .isValid)
                                  ? ''
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  /// FILTER

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: selections.map((value) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: StatefulBuilder(
                              builder: (BuildContext context,
                                  void Function(void Function()) rebuild) {
                                return FilterChip(
                                  color: WidgetStatePropertyAll(
                                      context.primaryColor),
                                  label: Text(
                                    value,
                                    style: TextStyle(
                                        color: context.secondaryColor),
                                  ),
                                  selected: selectedHobbies.contains(value),
                                  onSelected: (bool isSelected) {
                                    rebuild(() {
                                      if (isSelected) {
                                        selectedHobbies.add(value);
                                      } else {
                                        selectedHobbies.remove(value);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // List of all hobbies
  final List<String> selections = [
    "AC",
    "VIP",
    "Business",
    "Accomodation",
  ];

  // Set to hold selected hobbies
  Set<String> selectedHobbies = {};

  void _viewAllSuggestedRoutes() {
    APIQuery query = APIQuery(
        categoryType: CategoryType.suggestedRoutes,
        limit: 10,
        page: _suggestedRouteBloc.getPage);
    context.pushNamed(RouteLists.showRoutesByCategoryScreen,
        arguments: {"query": query});
  }
}
