import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/bloc/theme/theme_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/app.dart';
import 'package:link/ui/utils/route_list.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/post.dart';
import '../../widgets/custom_scaffold_body.dart';

class HeroHomeScreen extends StatefulWidget {
  const HeroHomeScreen({super.key});

  @override
  State<HeroHomeScreen> createState() => _HeroHomeScreenState();
}

class _HeroHomeScreenState extends State<HeroHomeScreen> {
  late final ValueNotifier<DateTime?> _selectedDateNotifier;

  List<Post> _trendingRoutes = [];

  @override
  void initState() {
    super.initState();
    _selectedDateNotifier = ValueNotifier(DateTime.now());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("dependency changes");
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild");

    return CustomScaffoldBody(
      body: _heroBody(context),
      title: "Home",
      action: Row(
        children: [
          IconButton(
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              icon: Icon(
                Icons.notifications_rounded,
                color: context.onPrimaryColor,
              ))
        ],
      ),
    );

    //   return Scaffold(
    //     appBar: AppBar(
    //       title: const Text(
    //         "Home",
    //       ),
    //       centerTitle: false,
    //       actions: [
    //         IconButton(
    //             onPressed: () => context.read<ThemeCubit>().toggleTheme(),
    //             icon: Icon(
    //               Icons.notifications_rounded,
    //               color: context.onPrimaryColor,
    //             ))
    //       ],
    //     ),
    //     body: SafeArea(
    //       child: Stack(
    //         children: [
    //           Container(
    //             height: 100,
    //             width: double.infinity,
    //             decoration: BoxDecoration(
    //               color: context.secondaryColor,
    //             ),
    //           ),
    //           _heroBody(context),
    //         ],
    //       ),
    //     ),
    //   );
  }

  SingleChildScrollView _heroBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _originDestinationCard(context),

            /// Date Choice field
            _dateChoiceActionCard(),
            const SizedBox(
              height: AppInsets.inset8,
            ),
            _trendingSearchTitleField(context),
            const SizedBox(
              height: AppInsets.inset8,
            ),
            _trendingRoutesList(),
            const SizedBox(
              height: 300,
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _trendingRoutesList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: BlocConsumer<PostRouteCubit, PostRouteState>(
          listener: (BuildContext context, Object? state) {},
          builder: (BuildContext context, state) {
            if (state.status == BlocStatus.fetchFailed ||
                state.status == BlocStatus.fetching) {
              return _buildTrendingRoutesShimmer(context);
            }
            if (state.status == BlocStatus.fetched) {
              _trendingRoutes = state.routes;
              return _buildTrendingRoutesCard(context);
            } else {
              return _buildTrendingRoutesShimmer(context);
            }
          }),
    );
  }

  Row _trendingSearchTitleField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Trending Search",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: context.onPrimaryColor),
        ),
        TextButton(
            onPressed: () {
              context.pushNamed(RouteLists.trendingRouteCards);
            },
            child: Text(
              "View All",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: context.onPrimaryColor.withOpacity(0.8)),
            )),
      ],
    );
  }

  Row _buildTrendingRoutesCard(BuildContext context) {
    return Row(
      children: [
        ..._trendingRoutes.map(
          (post) => Card.filled(
            elevation: 0.5,
            color: context.secondaryColor,
            child: Column(
              children: [
                InkWell(
                  onTap: () =>
                      context.pushNamed(RouteLists.trendingRouteCardDetail),
                  child: Card.filled(
                    shape: Border.all(width: 0.01),
                    margin: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage((post.images?.isNotEmpty == true)
                            ? "${App.baseImgUrl}${post.images?.first}"
                            : "https://images.pexels.com/photos/3278215/pexels-photo-3278215.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                        fit: BoxFit.cover,
                        opacity: 0.5,
                        onError: (exception, stackTrace) => Container(
                          color: Colors.amber,
                        ),
                      )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppInsets.inset10,
                            vertical: AppInsets.inset5),
                        child: SizedBox(
                          height: 80,
                          width: 250,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.bus_alert_rounded,
                                    color: context.primaryColor,
                                  ),
                                  const SizedBox(
                                    width: AppInsets.inset5,
                                  ),
                                  Text(
                                      "${post.origin?.name ?? ""}-${post.destination?.name ?? ""}"),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppInsets.inset10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.today_rounded,
                                          color: context.primaryColor,
                                        ),
                                        const SizedBox(
                                          width: AppInsets.inset5,
                                        ),
                                        Text(DateTimeUtil.formatDateTime(
                                            post.scheduleDate))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: AppInsets.inset15,
                                          color: Colors.amber,
                                        ),
                                        Text(post.commentCounts.toString())
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                          vertical: AppInsets.inset5,
                          horizontal: AppInsets.inset10)),
                    ),
                    onPressed: () {
                      context.pushNamed(RouteLists.trendingRouteCardDetail);
                    },
                    child: const Text("Book Now")),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row _buildTrendingRoutesShimmer(BuildContext context) {
    return Row(
      children: [
        ...List<Widget>.generate(
          7,
          (index) => Shimmer.fromColors(
            baseColor: context.primaryColor,
            highlightColor: context.onPrimaryColor,
            child: Card.filled(
              elevation: 0.5,
              color: context.secondaryColor,
              child: Column(
                children: [
                  const Card.filled(
                    child: SizedBox(
                      height: 80,
                      width: 200,
                    ),
                  ),
                  TextButton(
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                            vertical: AppInsets.inset5,
                            horizontal: AppInsets.inset10)),
                      ),
                      onPressed: () {},
                      child: const Text("Book Now")),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Card _dateChoiceActionCard() {
    return Card.filled(
      elevation: 0.5,
      // color: context.secondaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                                      child: Text(DateTimeUtil.formatDate(
                                          value ?? DateTime.now())),
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
                          context.pushNamed(RouteLists.searchQueryRoutes);
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
      ),
    );
  }

  Card _originDestinationCard(BuildContext context) {
    return Card.filled(
      // color: context.secondaryColor,
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            /// from & to
            Column(
              children: [
                /// FROM
                const Row(
                  children: [
                    Icon(Icons.filter_tilt_shift_outlined),
                    SizedBox(
                      width: AppInsets.inset25,
                    ),
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),

                /// DIVIDER
                Row(
                  children: [
                    const Icon(Icons.keyboard_double_arrow_down),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: const Divider(
                        indent: AppInsets.inset20,
                        thickness: 0.2,
                      ),
                    ),
                    const SizedBox(
                      width: AppInsets.inset5,
                    ),
                    const Icon(
                      Icons.swap_vert_circle,
                      size: AppInsets.inset30,
                    )
                  ],
                ),

                /// TO
                const Row(
                  children: [
                    Icon(Icons.filter_tilt_shift_outlined),
                    SizedBox(
                      width: AppInsets.inset25,
                    ),
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),

            /// filter

            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppInsets.inset10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: selections.map((value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) rebuild) {
                          return FilterChip(
                            color: WidgetStatePropertyAll(context.primaryColor),
                            label: Text(
                              value,
                              style: TextStyle(color: context.secondaryColor),
                            ),
                            selected: selectedHobbies.contains(value),
                            onSelected: (bool isSelected) {
                              print("selected");
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
}
