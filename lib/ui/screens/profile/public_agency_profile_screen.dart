// ignore_for_file: avoid_print
// ignore_for_file: unused_element, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/ui/widget_extension.dart';

import '../../../bloc/agency/agency_cubit.dart';
import '../../../bloc/routes/post_route_cubit.dart';
import '../../../core/utils/app_insets.dart';
import '../../../core/widgets/cached_image.dart';
import '../../../domain/bloc_utils/bloc_status.dart';
import '../../../models/agency.dart';
import '../../../models/post.dart';
import '../post_route_card.dart';

class PublicAgencyProfileScreen extends StatefulWidget {
  const PublicAgencyProfileScreen({super.key});

  @override
  State<PublicAgencyProfileScreen> createState() =>
      _PublicAgencyProfileScreenState();
}

class _PublicAgencyProfileScreenState extends State<PublicAgencyProfileScreen>
    with SingleTickerProviderStateMixin {
  Agency? _agency;

  bool _initial = true;

  // late TabController _tabController;
  late final PostRouteCubit _postTabCubit;
  late final AgencyCubit _agencyListBloc;

  //  List<Post> _postTabCubitPosts = [];
  List<Agency> _agencyLists = [];

  late String _selectedCategory;
  final int _currentIndex = 0;

  /// Temp Variables
  ///
  late final ValueNotifier<String?> _postSectionFilterNotifier;
  final List<String> categories = ['Latest', 'Popular'];

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 4, vsync: this);

    // Listen to tab changes and fetch relevant data
    /*
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _onTabChanged(_tabController.index);
      }
    });
    */

    /// Temp
    _postSectionFilterNotifier = ValueNotifier(categories.first);
    _selectedCategory = categories.first;
  }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_initial) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        Agency agency = ModalRoute.of(context)?.settings.arguments as Agency;
        context.read<AgencyCubit>().fetAgencies(agencyId: agency.id);
      }
      _initial = false;
      // _postTabCubit = PostRouteCubit();
      _postTabCubit = context.read<PostRouteCubit>();
      // _agencyListBloc = AgencyCubit();
      _agencyListBloc = context.read<AgencyCubit>();
    }
    super.didChangeDependencies();
  }

  // Method to handle tab change
  void _onTabChanged(int index) {
    switch (index) {
      case 0:
        // Fetch posts data
        // if (_postTabCubitPosts.isEmpty) {
        //   _postTabCubit.fetchRoutes(query: {"limit": 10});
        // }
        break;
      case 1:
        // Fetch services data

        if (_agencyLists.isEmpty) {
          _agencyListBloc.fetAgencies();
        }
        break;
      case 2:
        // Fetch ratings data
        context.read<AgencyCubit>().fetchRatings();
        break;
      case 3:
        // Fetch gallery images
        context.read<AgencyCubit>().fetchGalleryImages();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build method Called!");
    return BlocConsumer<AgencyCubit, AgencyState>(
      listener: (BuildContext context, AgencyState state) {},
      builder: (BuildContext context, AgencyState state) {
        if (state.status == BlocStatus.fetched) {
          _agency = state.agencies.first;
          return DefaultTabController(
            length: 4, // Number of sections (tabs)
            child: Scaffold(
              // appBar: _appBar(),
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    // SliverAppBar to stick the TabBar when scrolling
                    // _sliverAppBar_normal(),
                    _sliverAppBarDegree2(),
                    //
                    _agencyInfoBoxAdapter(),
                    // Custom SliverPersistentHeader with TabBar
                    _customSliverPersistentHeader(),
                    // _sliverList_builder(),
                  ];
                },
                body: TabBarView(
                  // body: IndexedStack(
                  //   index: _currentIndex,
                  // controller: _tabController,
                  children: [
                    _buildPostSection(context),
                    _buildServicesSection(context),
                    _buildRatingsSection(context),
                    _buildGallerySection(context),
                  ],
                ),
              ),
              /*Column(
            children: [
              // The info widget you want to place between AppBar and TabBar
              Container(
                height: 200, // Your desired height
                color: Colors.blueGrey, // Customize as needed
                child: const Center(
                  child: Text(
                    'Agency Highlight Info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // The TabBar (below the info widget)
              const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: "About"),
                  Tab(text: "Services Offered"),
                  Tab(text: "Ratings & Reviews"),
                  Tab(text: "Gallery"),
                ],
              ),

              TabBarView(
                children: [
                  _buildAboutSection(context),
                  _buildServicesSection(context),
                  _buildRatingsSection(context),
                  _buildGallerySection(context),
                ],
              ).expanded(),
            ],
          ),
          */
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(_agency?.name ?? 'Agency Profile'),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // Share agency profile logic
          },
        ),
      ],
    );
  }

  SliverToBoxAdapter _agencyInfoBoxAdapter() {
    return SliverToBoxAdapter(
      child: Container(
        child: _aboutContentWidget(),
      ),
    );
  }

  SliverPersistentHeader _customSliverPersistentHeader() {
    return SliverPersistentHeader(
      pinned: true, // Makes the TabBar stick to the top
      delegate: CustomSliverPersistentHeaderDelegate(
        child: TabBar(
          isScrollable: true,
          overlayColor: WidgetStatePropertyAll(context.primaryColor),
          indicatorColor: Colors.deepPurpleAccent,
          indicatorWeight: 3.0,
          // controller: _tabController,
          onTap: (value) {
            print("onTap ::: $value");
            // _currentIndex = value;
            _onTabChanged(value);
            // setState(() {});
            // _onTabChanged(_currentIndex);
          },
          tabs: const [
            Tab(text: "Posts"),
            Tab(text: "Services Offered"),
            Tab(text: "Ratings & Reviews"),
            Tab(text: "Gallery"),
          ],
          dividerColor: context.primaryColor,
          unselectedLabelColor: context.primaryColor,
          labelColor: context.secondaryColor,
        ),
      ),
    );
  }

  SliverList _sliverListBuilder() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ListTile(
            title: Text('Item #$index'),
          );
        },
        childCount: 20,
      ),
    );
  }

  SliverAppBar _sliverAppBarDegree2() {
    return SliverAppBar(
      pinned: true,
      floating: false,
      // automaticallyImplyLeading: false, // Removes back button
      expandedHeight: 200.0, // Expands the AppBar
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(16), // Custom title padding
        centerTitle: true,

        title: Text(
          _agency?.name ?? 'Agency Name',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                  backgroundBlendMode: BlendMode.screen,
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.blueAccent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/icon/app_logo.png",
                      ),
                      fit: BoxFit.cover)),
            ),
            // Optional: Add image background or any other element
            // Image.network('https://example.com/header-background.jpg', fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }

  // About Section
  Widget _buildPostSection(BuildContext context) {
    print("rebuild _buildPostSection");

    // return _buildPostContentWidgetNestedScrollView();
    // _nestedScrollViewForPostContentSection(categories, allPosts);
    // return BuildPostSection();
    return const PostSectionBuilder();
    // return BuildPostSection(
    //     postSectionFilterNotifier: _postSectionFilterNotifier,
    //     categories: categories,
    //     bloc: _postTabCubit,
    //     postTabCubitPosts: _postTabCubitPosts);
  }

/*
  // ignore: unused_element
  NestedScrollView _nestedScrollViewForPostContentSection(
      List<String> categories, List<PostModel> allPosts) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: categories.first,
                  onChanged: (String? newValue) {
                    // setState(() {
                    //   selectedCategory = newValue;
                    //   filterPosts(); // Filter posts based on selected category
                    // });
                  },
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ];
      },
      body: BlocConsumer<PostRouteCubit, PostRouteState>(
          bloc: _postTabCubit,
          listener: (BuildContext context, PostRouteState state) {},
          builder: (BuildContext context, PostRouteState state) {
            return CustomScrollView(
              slivers: [
                _agencyInfoBoxAdapter(),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return ListTile(
                        title: Text(allPosts[index].title),
                        subtitle: Text(allPosts[index].content),
                      );
                    },
                    childCount: allPosts.length,
                  ),
                ),
              ],
            );
          }),
    );
  }
*/

  ///
  ///

  NestedScrollView _buildPostContentWidgetNestedScrollView() {
    return NestedScrollView(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => ListTile(
                title: Text(index.toString()),
              ),
              childCount: 50, // Specify the number of items
            ),
          ),
        ],
      ),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          // _buildPostContentWidget(context),
          SliverAppBar(
            pinned: true,
            floating: false,
            automaticallyImplyLeading: false,
            // Removes back button
            title: _postFilterDropDown(),
            expandedHeight: 20.0,
          ),
        ];
      },
    );
  }

  Padding _aboutContentWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(_agency?.description ?? '').styled(fs: 16, fw: FontWeight.bold),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 15,
              ),
              const SizedBox(width: 8),
              Text(_agency?.address ?? 'Address'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.phone,
                size: 15,
              ),
              const SizedBox(width: 8),
              Text(_agency?.contactInfo ?? 'No contact available'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSocialMediaLinks(),
        ],
      ),
    );
  }

  // Services Section
  Widget _buildServicesSection(BuildContext context) {
    print("rebuild _buildServicesSection");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Services Offered',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // if (_agency?.services == null || (_agency?.services ?? []).isEmpty)
        //   const Text('No services available')
        // else
        BlocConsumer<AgencyCubit, AgencyState>(
          bloc: _agencyListBloc,
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == BlocStatus.fetched) {
              _agencyLists = state.agencies;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _agencyLists.length,
                itemBuilder: (context, index) {
                  // final service = _agency?.services![index];
                  Agency agency = _agencyLists[index];
                  return ListTile(
                    title: Text(agency.name ?? 'Service Title'),
                    subtitle:
                        Text(agency.description ?? 'No description available.'),
                    leading: CachedImage(imageUrl: agency.coverImage ?? ""),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          },
        ).expanded(),
      ],
    );
  }

  // Ratings and Reviews Section
  Widget _buildRatingsSection(BuildContext context) {
    print("rebuild _buildRatingsSection");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ratings & Reviews',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber),
            const SizedBox(width: 8),
            Text(_agency?.averageRating?.toStringAsFixed(1) ?? 'N/A'),
            const SizedBox(width: 8),
            Text('(${_agency?.reviews?.length ?? 0} reviews)'),
          ],
        ),
        const SizedBox(height: 16),
        if (_agency?.reviews != null && (_agency?.reviews ?? []).isNotEmpty)
          SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _agency?.reviews!.length,
              itemBuilder: (context, index) {
                final review = _agency?.reviews![index];
                return ListTile(
                  title: Text(review?.username ?? 'Anonymous'),
                  subtitle: Text(review?.reviewText ?? 'No review text.'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (starIndex) {
                      return Icon(
                        starIndex < (review?.rating ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                      );
                    }),
                  ),
                );
              },
            ),
          ).expanded(),
      ],
    );
  }

  // Gallery Section
  Widget _buildGallerySection(BuildContext context) {
    print("rebuild _buildGallerySection");

/*
    if (_agency?.gallery == null || (_agency?.gallery ?? []).isEmpty) {
      return const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No images in gallery'),
          ),
        ],
      );
    }
    */

    /// For Tempory purpose
    List<String> gallery = ["", "", "", "", "", "", "", "", "", ""];
    // : [];
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: gallery.length,
          itemBuilder: (context, index) {
            return CachedImage(imageUrl: gallery[index])
                .clipRRect(borderRadius: BorderRadius.circular(5));
          },
        ),
      ).expanded(),
    ]);
  }

  Widget _buildSocialMediaLinks() {
    return Row(
      children: [
        if (_agency?.socialMediaLinks?.facebook != null)
          IconButton(
            icon: const Icon(Icons.facebook),
            onPressed: () {
              // Open Facebook link
            },
          ),
        if (_agency?.socialMediaLinks?.instagram != null)
          IconButton(
            icon: const Icon(Icons.note),
            onPressed: () {
              // Open Instagram link
            },
          ),
        if (_agency?.socialMediaLinks?.twitter != null)
          IconButton(
            icon: const Icon(Icons.import_contacts_outlined),
            onPressed: () {
              // Open Twitter link
            },
          ),
      ],
    );
  }

  Widget _buildPostContentWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _postFilterDropDown(),
        Container(
          color: Colors.amber,
        )
      ],
    );
  }

  Widget _postFilterDropDown() {
    return InkWell(
      onTap: () {},
      child: Container(
        color: Colors.white70,
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [Text("Latest"), Icon(Icons.keyboard_arrow_down_rounded)],
        ).padding(padding: const EdgeInsets.symmetric(horizontal: 10)),
      ),
    );
  }
}

/// Custom POst Builder
class PostSectionBuilder extends StatefulWidget {
  const PostSectionBuilder({super.key});

  @override
  State<PostSectionBuilder> createState() => _PostSectionBuilderState();
}

class _PostSectionBuilderState extends State<PostSectionBuilder>
    with AutomaticKeepAliveClientMixin<PostSectionBuilder> {
  late final PostRouteCubit _postRouteCubit;
  List<Post> _postOfAgencies = [];

  // Separate ScrollControllers for each tab
  final ScrollController _postScrollController = ScrollController();

  final List<String> categories = ['Latest', 'Popular'];
  late final ValueNotifier<String?> _postSectionFilterNotifier;

  @override
  void initState() {
    print(">PostSectionBuilder> initState");
    super.initState();
    // _postRouteCubit = PostRouteCubit();
    _postRouteCubit = context.read<PostRouteCubit>();
    // _selectedValue = categories.first;
    _postSectionFilterNotifier = ValueNotifier(categories.first);
  }

  @override
  void dispose() {
    print(">PostSectionBuilder> dispose");
    _postScrollController.dispose();
    _postSectionFilterNotifier.dispose();
    super.dispose();
  }

  final bool _initial = true;

  @override
  void didChangeDependencies() {
    print(">PostSectionBuilder> didChangeDependencies");
    super.didChangeDependencies();
    if (_initial) {
      print(">PostSectionBuilder> _initial $_initial");
      if (_postOfAgencies.isEmpty) {
        // _postRouteCubit.fetchRoutes(
        //     query: {"limit": 10, "agency_id": "66b8d3c63e1a9b47a2c0e6a5"});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            // child: DropdownCategory(
            //     onCategoryChanged: (value) =>
            //         _postSectionFilterNotifier.value = value,
            //     categories: categories,
            //     selectedCategory: _postSectionFilterNotifier.value!),
            child: CommentHeaderFilterTab(
              valueLists: categories,
              valueAsString: (value) => value,
              onValueChanged: (value) {
                print("$value changed");
                _postSectionFilterNotifier.value = value;
              },
            ),
          ),
          // List of posts based on the selected category
          Expanded(
            child: BlocConsumer<PostRouteCubit, PostRouteState>(
              bloc: _postRouteCubit,
              listener: (BuildContext context, PostRouteState state) {},
              builder: (BuildContext context, PostRouteState state) {
                if (state.status == BlocStatus.fetched) {
                  _postOfAgencies = state.routes;
                  return ListView.builder(
                    controller: _postScrollController,
                    itemCount: _postOfAgencies.length,
                    // physics: const NeverScrollableScrollPhysics(),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (_postOfAgencies.isEmpty) {
                        return Center(
                          child: Container(
                            color: Colors.amber,
                            height: 100,
                          ),
                        );
                      }
                      return PostRouteCard(post: _postOfAgencies[index]);
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              },
            ),
          ),
        ],
      ).padding(
          padding: const EdgeInsets.symmetric(horizontal: AppInsets.inset5)),
    );
  }

  @override
  // TODO: keep the state alive across tabs
  bool get wantKeepAlive => true;

  /// Build method
}

class CommentHeaderFilterTab<T> extends StatefulWidget {
  const CommentHeaderFilterTab(
      {super.key,
      required this.valueLists,
      required this.valueAsString,
      required this.onValueChanged});

  final List<T> valueLists;
  final String Function(T) valueAsString;
  final void Function(T) onValueChanged;

  @override
  State<CommentHeaderFilterTab<T>> createState() =>
      _CommentHeaderFilterTabState<T>();
}

class _CommentHeaderFilterTabState<T> extends State<CommentHeaderFilterTab<T>> {
  /*
  * list<t>
  * valueAsString(value:String)
  * onValueChanged(value : index)
  * */
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...widget.valueLists.map(
          (e) => ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  backgroundColor:
                      const WidgetStatePropertyAll(Colors.transparent)),
              onPressed: () => widget.onValueChanged.call(e),
              child: Text(widget.valueAsString(e),
                  style: Theme.of(context).textTheme.labelSmall)),
        )
      ],
    );
  }
}

///

class BuildPostSection extends StatefulWidget {
  const BuildPostSection({
    super.key,
    required ValueNotifier<String?> postSectionFilterNotifier,
    required this.categories,
    required List<Post> postTabCubitPosts,
    required this.bloc,
  })  : _postSectionFilterNotifier = postSectionFilterNotifier,
        _postTabCubitPosts = postTabCubitPosts;

  final ValueNotifier<String?> _postSectionFilterNotifier;
  final List<String> categories;
  final List<Post> _postTabCubitPosts;
  final PostRouteCubit bloc;

  @override
  State<BuildPostSection> createState() => _BuildPostSectionState();
}

class _BuildPostSectionState extends State<BuildPostSection> {
  // Separate ScrollControllers for each tab
  final ScrollController _postScrollController = ScrollController();

  List<Post> postTabCubitPosts = [];

  @override
  void dispose() {
    _postScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown for selecting category
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
            valueListenable: widget._postSectionFilterNotifier,
            builder: (BuildContext context, String? value, Widget? child) {
              return DropdownButton<String>(
                value: value,
                onChanged: (String? newValue) {
                  widget._postSectionFilterNotifier.value = newValue;
                  // context.read<CategoryCubit>().changeCategory(newValue!);
                  // filterPosts(); // Filter posts based on selected category
                },
                items: widget.categories
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              );
            },
            child: Container(
              width: 50,
              height: 50,
              color: Colors.amber,
            ),
          ),
        ),
        // List of posts based on the selected category
        Expanded(
          child: BlocConsumer<PostRouteCubit, PostRouteState>(
            bloc: widget.bloc,
            listener: (BuildContext context, PostRouteState state) {},
            builder: (BuildContext context, PostRouteState state) {
              if (state.status == BlocStatus.fetched) {
                postTabCubitPosts = state.routes;
                return ListView.builder(
                  controller: _postScrollController,
                  itemCount: postTabCubitPosts.length,
                  itemBuilder: (context, index) {
                    if (postTabCubitPosts.isEmpty) {
                      return Center(
                        child: Container(
                          color: Colors.amber,
                          height: 100,
                        ),
                      );
                    }
                    return Card.filled(
                      child: ListTile(
                        title: Text(postTabCubitPosts[index].title ?? ""),
                        subtitle: Text(
                            "${widget._postTabCubitPosts[index].origin?.name ?? ""} - ${widget._postTabCubitPosts[index].destination?.name ?? ""}"),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            },
          ),
        ),
      ],
    ).padding(
        padding: const EdgeInsets.symmetric(horizontal: AppInsets.inset5));
  }
}

///
///Extrected Widgets

class PostContentWidget extends StatelessWidget {
  const PostContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppInsets.inset5));
  }
}

// Custom SliverPersistentHeaderDelegate class
class CustomSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final TabBar child;

  CustomSliverPersistentHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // Background color for the TabBar
      child: child, // The TabBar is the child widget
    );
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

// Sticky Header Delegate for Dropdown
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: child,
    );
  }

  @override
  double get maxExtent => child is PreferredSizeWidget
      ? (child as PreferredSizeWidget).preferredSize.height
      : 100;

  @override
  double get minExtent => maxExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

/// Model
///
// Sample data model for Post
class PostModel {
  final String title;
  final String content;

  PostModel(this.title, this.content);
}

/// DropDown Widget
///
class DropdownCategory extends StatefulWidget {
  final Function(String) onCategoryChanged;
  final List<String> categories;
  final String selectedCategory;

  const DropdownCategory({
    required this.onCategoryChanged,
    required this.categories,
    required this.selectedCategory,
    super.key,
  });

  @override
  State<DropdownCategory> createState() => _DropdownCategoryState();
}

class _DropdownCategoryState extends State<DropdownCategory> {
  late final ValueNotifier<String?> selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = ValueNotifier(widget.selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedCategory,
      builder: (BuildContext context, String? value, Widget? child) {
        return DropdownButton<String>(
          value: value,
          style: Theme.of(context).textTheme.labelSmall,
          onChanged: (String? newValue) {
            selectedCategory.value = newValue;
            widget.onCategoryChanged(newValue!);
          },
          items:
              widget.categories.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          isDense: true,
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          padding: const EdgeInsets.symmetric(vertical: 0.0),
        );
      },
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';

import '../../../bloc/agency/agency_cubit.dart';
import '../../../models/agency.dart';

class PublicProfileScreen extends StatefulWidget {
  const PublicProfileScreen({super.key});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  Agency? _agency;

  bool _initial = true;

  @override
  void didChangeDependencies() {
    if (_initial) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        Agency agency = ModalRoute.of(context)?.settings.arguments as Agency;
        context.read<AgencyCubit>().fetAgencies(agencyId: agency.id);
      }
      _initial = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AgencyCubit, AgencyState>(
        listener: (BuildContext context, AgencyState state) {},
        builder: (BuildContext context, AgencyState state) {
          if (state.status == BlocStatus.fetched) {
            _agency = state.agencies.first;
            print("_agency::: ${_agency?.toJson()} ");
            return Scaffold(
              appBar: AppBar(
                title: Text(_agency?.name ?? "HELLO"),
              ),
              backgroundColor: context.tertiaryColor,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        });
  }
}
*/
