import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/models/user.dart';
import 'package:link/ui/widget_extension.dart';

import '../../../core/utils/app_insets.dart';
import '../../../core/widgets/cached_image.dart';
import '../../widgets/custom_scaffold_body.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(
      body: _body(context),
      backButton: BackButton(
        onPressed: () => context.pop(),
      ),
      title: Text("Settings",
          style: TextStyle(
              color: context.onPrimaryColor,
              fontSize: AppInsets.font25,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _body(BuildContext context) {
    return ListTile(
      title: const Text("Agency Profile by 1"),
      trailing: IconButton.filled(
          onPressed: () {
            context.push(MaterialPageRoute(
              builder: (context) => AgencyProfilePage(
                agency: sampleAgency,
              ),
            ));
          },
          icon: const Icon(Icons.arrow_right)),
    );
  }

  Agency sampleAgency = Agency(
    address: "Yangon (Address)",
    averageRating: 45,
    contactInfo: "Contact Info ::: 55520245",
    coverImage: "",
    createdAt: DateTime.now(),
    description: "Description :::",
    gallery: ["", "", "", "", "", "", "", "", "", ""],
    id: "id42",
    location: {},
    name: "World Travel Agency",
    profileImage: "",
    reviews: [
      Review(rating: 15, reviewText: "Good", username: "Reviewer 1"),
      Review(
        rating: 15,
        reviewText: "Good",
        username: "Reviewer 2",
      )
    ],
    services: [
      Service(
          title: "Service1", description: "Service1 Description", imageUrl: ""),
      Service(
          title: "Service2", description: "Service2 Description", imageUrl: ""),
    ],
    socialMediaLinks: SocialMediaLinks(
        facebook: "Facebook link",
        instagram: "Instagram link",
        twitter: "Twitter link"),
  );
}

class AgencyProfilePage extends StatelessWidget {
  final Agency agency;

  const AgencyProfilePage({super.key, required this.agency});

  @override
  Widget build(BuildContext context) {
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
              _sliverPersistentHeader_custom_degree3(),
              // _sliverList_builder(),
            ];
          },
          body: TabBarView(
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

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Contact action
          },
          child: const Icon(Icons.call),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(agency.name ?? 'Agency Profile'),
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
        color: Colors.white24,
        child: _aboutContentWidget(),
      ),
    );
  }

  SliverPersistentHeader _sliverPersistentHeader_custom_degree3() {
    return SliverPersistentHeader(
      pinned: true, // Makes the TabBar stick to the top
      delegate: CustomSliverPersistentHeaderDelegate(
        child: const TabBar(
          isScrollable: true,
          labelColor: Colors.black,
          indicatorColor: Colors.deepPurpleAccent,
          indicatorWeight: 3.0,
          tabs: [
            Tab(text: "Posts"),
            Tab(text: "Services Offered"),
            Tab(text: "Ratings & Reviews"),
            Tab(text: "Gallery"),
          ],
        ),
      ),
    );
  }

  SliverList _sliverList_builder() {
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
          agency.name ?? 'Agency Name',
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
                  // backgroundBlendMode: BlendMode.luminosity,
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

  SliverAppBar _sliverAppBar_normal() {
    return const SliverAppBar(
      pinned: true, // Sticks the TabBar at the top when scrolling
      floating: false,
      automaticallyImplyLeading: false, // Removes back button
      bottom: TabBar(
        isScrollable: true,
        tabs: [
          Tab(text: "About"),
          Tab(text: "Services Offered"),
          Tab(text: "Ratings & Reviews"),
          Tab(text: "Gallery"),
        ],
      ),
    );
  }

  // About Section
  Widget _buildPostSection(BuildContext context) {
    // Sample data model for Post

// Sample data
    final List<Post> allPosts = List<Post>.generate(
      20,
      (index) => Post('Post 1 in Category $index', 'Content of Post $index'),
    );

    final List<String> categories = ['Category 1', 'Category 2'];
    // return _buildPostContentWidgetNestedScrollView();
    // Build the Post Section with dropdown and posts list

    NestedScrollView(
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
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
                height: 0), // You can use this to add spacing if needed
          ),
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
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown for selecting category
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: categories.first,
            onChanged: (String? newValue) {
              // setState(() {
              //   selectedCategory = newValue;
              //   filterPosts(); // Filter posts based on selected category
              // });
            },
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        // List of posts based on the selected category
        Expanded(
          child: ListView.builder(
            itemCount: allPosts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(allPosts[index].title),
                subtitle: Text(allPosts[index].content),
              );
            },
          ),
        ),
      ],
    );
  }

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
            automaticallyImplyLeading: false, // Removes back button
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
          Text(
            agency.description ?? 'No description available.',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 8),
              Text(agency.address ?? 'No address available'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(width: 8),
              Text(agency.contactInfo ?? 'No contact available'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Services Offered',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (agency.services == null || agency.services!.isEmpty)
          const Text('No services available')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: agency.services?.length ?? 0,
            itemBuilder: (context, index) {
              final service = agency.services![index];
              return ListTile(
                title: Text(service.title ?? 'Service Title'),
                subtitle:
                    Text(service.description ?? 'No description available.'),
                leading: CachedImage(imageUrl: service.imageUrl ?? ""),
              );
            },
          ).expanded(),
      ],
    );
  }

  // Ratings and Reviews Section
  Widget _buildRatingsSection(BuildContext context) {
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
            Text(agency.averageRating?.toStringAsFixed(1) ?? 'N/A'),
            const SizedBox(width: 8),
            Text('(${agency.reviews?.length ?? 0} reviews)'),
          ],
        ),
        const SizedBox(height: 16),
        if (agency.reviews != null && agency.reviews!.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: agency.reviews!.length,
            itemBuilder: (context, index) {
              final review = agency.reviews![index];
              return ListTile(
                title: Text(review.username ?? 'Anonymous'),
                subtitle: Text(review.reviewText ?? 'No review text.'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      starIndex < (review.rating ?? 0)
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                    );
                  }),
                ),
              );
            },
          ).expanded(),
      ],
    );
  }

  // Gallery Section
  Widget _buildGallerySection(BuildContext context) {
    if (agency.gallery == null || agency.gallery!.isEmpty) {
      return const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No images in gallery'),
          ),
        ],
      );
    }
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: agency.gallery?.length ?? 0,
          itemBuilder: (context, index) {
            return CachedImage(imageUrl: agency.gallery![index])
                .clipRRect(borderRadius: BorderRadius.circular(5));
          },
        ),
      ).expanded(),
    ]);
  }

  Widget _buildSocialMediaLinks() {
    return Row(
      children: [
        if (agency.socialMediaLinks?.facebook != null)
          IconButton(
            icon: const Icon(Icons.facebook),
            onPressed: () {
              // Open Facebook link
            },
          ),
        if (agency.socialMediaLinks?.instagram != null)
          IconButton(
            icon: const Icon(Icons.note),
            onPressed: () {
              // Open Instagram link
            },
          ),
        if (agency.socialMediaLinks?.twitter != null)
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

/*
import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/models/user.dart';
import 'package:link/ui/screens/post/upload_new_post_page.dart';
import 'package:link/ui/widget_extension.dart';

import '../../../core/utils/app_insets.dart';
import '../../../core/widgets/cached_image.dart';
import '../../widgets/custom_scaffold_body.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(
      body: _body(context),
      backButton: BackButton(
        onPressed: () => context.pop(),
      ),
      title: Text("Settings",
          style: TextStyle(
              color: context.onPrimaryColor,
              fontSize: AppInsets.font25,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _body(BuildContext context) {
    return ListTile(
      title: const Text("Agency Profile by 1"),
      trailing: IconButton.filled(
          onPressed: () {
            context.push(MaterialPageRoute(
              builder: (context) => AgencyProfilePage(
                agency: sampleAgency,
              ),
            ));
          },
          icon: const Icon(Icons.arrow_right)),
    );
  }

  Agency sampleAgency = Agency(
    address: "Yangon (Address)",
    averageRating: 45,
    contactInfo: "Contact Info ::: 55520245",
    coverImage: "",
    createdAt: DateTime.now(),
    description: "Descripton :::",
    gallery: ["", "", "", "", ""],
    id: "id42",
    location: {},
    name: "World Travel Agency",
    profileImage: "",
    reviews: [
      Review(rating: 15, reviewText: "Good", username: "Reviewr 1"),
      Review(
        rating: 15,
        reviewText: "Good",
        username: "Reviewr 2",
      )
    ],
    services: [
      Service(title: "Service1", description: "Service1 Descri", imageUrl: ""),
      Service(title: "Service2", description: "Service2 Descri", imageUrl: ""),
      Service(title: "Service1", description: "Service1 Descri", imageUrl: ""),
      Service(title: "Service2", description: "Service2 Descri", imageUrl: ""),
    ],
    socialMediaLinks: SocialMediaLinks(
        facebook: "FackBook link",
        instagram: "instragram link",
        twitter: "twitter link"),
  );
}

class AgencyProfilePage extends StatelessWidget {
  final Agency agency;

  const AgencyProfilePage({super.key, required this.agency});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(agency.name ?? 'Agency Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share agency profile logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image and Profile Picture
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: CachedImage(imageUrl: agency.profileImage ?? ""),
                ),
                Positioned(
                  bottom: -50,
                  left: 16,
                  child: CircleAvatar(
                    radius: 50,
                    child: CachedImage(imageUrl: agency.profileImage ?? "")
                        .clipRRect(borderRadius: BorderRadius.circular(50)),
                  ),
                ),
              ],
            ),
            // To avoid overlap
            // Agency Name and Description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agency.name ?? 'Agency Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    agency.description ?? 'Description not available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 8),
                      Text(agency.address ?? 'No address available'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone),
                      const SizedBox(width: 8),
                      Text(agency.contactInfo ?? 'No contact available'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSocialMediaLinks(),
                ],
              ),
            ),
            const Divider(thickness: 0.1),
            // Services Section
            _buildServicesSection(),
            const Divider(thickness: 0.1),
            // Ratings and Reviews
            _buildRatingsSection(),

            // Gallery Section
            _buildGallerySection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Contact action
        },
        child: const Icon(Icons.call),
      ),
    );
  }

  Widget _buildSocialMediaLinks() {
    return Row(
      children: [
        if (agency.socialMediaLinks?.facebook != null)
          IconButton(
            icon: const Icon(Icons.facebook),
            onPressed: () {
              // Open Facebook link
            },
          ),
        if (agency.socialMediaLinks?.instagram != null)
          IconButton(
            icon: const Icon(Icons.note),
            onPressed: () {
              // Open Instagram link
            },
          ),
        if (agency.socialMediaLinks?.twitter != null)
          IconButton(
            icon: const Icon(Icons.import_contacts_outlined),
            onPressed: () {
              // Open Twitter link
            },
          ),
      ],
    );
  }

  Widget _buildServicesSection() {
    if (agency.services == null || agency.services!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No services available'),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Services Offered',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: agency.services?.length ?? 0,
              itemBuilder: (context, index) {
                final service = agency.services![index];
                return Container(
                  width: 200,
                  color: Colors.blue[50],
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: CachedImage(imageUrl: service.imageUrl ?? ""),
                      ).expanded(flex: 5),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.title ?? 'Service Title',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            service.description ?? 'No description available.',
                            style: TextStyle(color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                          ).expanded(),
                        ],
                      )
                          .padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5))
                          .expanded(flex: 2),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ratings & Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 8),
              Text(agency.averageRating?.toStringAsFixed(1) ?? 'N/A'),
              const SizedBox(width: 8),
              Text('(${agency.reviews?.length ?? 0} reviews)'),
            ],
          ),
          const SizedBox(height: 16),
          if (agency.reviews != null && agency.reviews!.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: agency.reviews!.length,
              itemBuilder: (context, index) {
                final review = agency.reviews![index];
                return ListTile(
                  title: Text(review.username ?? 'Anonymous'),
                  subtitle: Text(review.reviewText ?? 'No review text.'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (starIndex) {
                      return Icon(
                        starIndex < (review.rating ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                      );
                    }),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildGallerySection() {
    if (agency.gallery == null || agency.gallery!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No images in gallery'),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gallery',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: agency.gallery?.length ?? 0,
            itemBuilder: (context, index) {
              return CachedImage(imageUrl: agency.gallery![index]);
            },
          ),
        ],
      ),
    );
  }
}
*/

class Agency {
  Agency({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.profileImage,
    this.coverImage,
    this.contactInfo,
    this.address,
    this.location,
    this.services,
    this.averageRating,
    this.reviews,
    this.gallery,
    this.socialMediaLinks,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final User? userId; // Reference to the owner (Agency User)
  final String? name;
  final String? description;
  final String? profileImage; // Profile picture URL
  final String? coverImage; // Cover image for the agency
  final String? contactInfo; // Contact details like phone, email
  final String? address;
  final Map<String, double>? location; // Geolocation with lat and lon
  final List<Service>? services; // List of services offered by the agency
  final double? averageRating; // Average rating based on reviews
  final List<Review>? reviews; // List of reviews from users
  final List<String>? gallery; // Gallery with image URLs
  final SocialMediaLinks? socialMediaLinks; // Social media links
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Agency copyWith({
    String? id,
    User? userId,
    String? name,
    String? description,
    String? profileImage,
    String? coverImage,
    String? contactInfo,
    String? address,
    Map<String, double>? location,
    List<Service>? services,
    double? averageRating,
    List<Review>? reviews,
    List<String>? gallery,
    SocialMediaLinks? socialMediaLinks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Agency(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      profileImage: profileImage ?? this.profileImage,
      coverImage: coverImage ?? this.coverImage,
      contactInfo: contactInfo ?? this.contactInfo,
      address: address ?? this.address,
      location: location ?? this.location,
      services: services ?? this.services,
      averageRating: averageRating ?? this.averageRating,
      reviews: reviews ?? this.reviews,
      gallery: gallery ?? this.gallery,
      socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "name": name,
      "description": description,
      "profile_image": profileImage,
      "cover_image": coverImage,
      "contactInfo": contactInfo,
      "address": address,
      "location": location,
      "services": services?.map((e) => e.toJson()).toList(),
      "averageRating": averageRating,
      "reviews": reviews?.map((e) => e.toJson()).toList(),
      "gallery": gallery,
      "socialMediaLinks": socialMediaLinks?.toJson(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(
      id: json['_id'],
      userId: json['user_id'] == null
          ? null
          : User.fromJson(json['user_id'] as Map<String, dynamic>),
      name: json['name'],
      description: json['description'],
      profileImage: json['profile_image'],
      coverImage: json['cover_image'],
      contactInfo: json['contactInfo'],
      address: json['address'],
      location: Map<String, double>.from(json['location'] ?? {}),
      services: json['services'] != null
          ? List<Service>.from(json['services'].map((x) => Service.fromJson(x)))
          : null,
      averageRating: json['averageRating']?.toDouble(),
      reviews: json['reviews'] != null
          ? List<Review>.from(json['reviews'].map((x) => Review.fromJson(x)))
          : null,
      gallery: List<String>.from(json['gallery'] ?? []),
      socialMediaLinks: json['socialMediaLinks'] != null
          ? SocialMediaLinks.fromJson(json['socialMediaLinks'])
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  @override
  String toString() {
    return 'Agency{id: $id, userId: $userId, name: $name, description: $description, profileImage: $profileImage, coverImage: $coverImage, contactInfo: $contactInfo, address: $address, location: $location, services: $services, averageRating: $averageRating, reviews: $reviews, gallery: $gallery, socialMediaLinks: $socialMediaLinks, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

class Service {
  Service({this.id, this.title, this.description, this.imageUrl});

  final String? id;
  final String? title;
  final String? description;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "imageUrl": imageUrl,
    };
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

class Review {
  Review({this.id, this.username, this.rating, this.reviewText});

  final String? id;
  final String? username;
  final double? rating;
  final String? reviewText;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "rating": rating,
      "reviewText": reviewText,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      username: json['username'],
      rating: json['rating']?.toDouble(),
      reviewText: json['reviewText'],
    );
  }
}

class SocialMediaLinks {
  SocialMediaLinks({this.facebook, this.instagram, this.twitter});

  final String? facebook;
  final String? instagram;
  final String? twitter;

  Map<String, dynamic> toJson() {
    return {
      "facebook": facebook,
      "instagram": instagram,
      "twitter": twitter,
    };
  }

  factory SocialMediaLinks.fromJson(Map<String, dynamic> json) {
    return SocialMediaLinks(
      facebook: json['facebook'],
      instagram: json['instagram'],
      twitter: json['twitter'],
    );
  }
}

///
///

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
class Post {
  final String title;
  final String content;

  Post(this.title, this.content);
}
