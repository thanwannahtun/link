import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';

import 'package:link/ui/utils/route_list.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

import '../../../core/utils/app_insets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint("initStateCalled  :ProfileScreen");
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(
      body: _body(context),
      title: Text(
        "Profile",
        style: TextStyle(
            color: context.onPrimaryColor,
            fontSize: AppInsets.font20,
            fontWeight: FontWeight.bold),
      ),
      action: Row(
        children: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppInsets.inset8,
                          vertical: AppInsets.inset15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /*
                          ListTile(
                              title: const Text("Upload New Post")
                                  .styled(fw: FontWeight.bold),
                              trailing: const Icon(Icons.add_box_outlined),
                              onTap: () => context
                                  .pushNamed(RouteLists.postCreatePage)
                                  .then((value) => context.pop())),
                          */
                          ListTile(
                              title: const Text("Upload New Route")
                                  .styled(fw: FontWeight.bold),
                              trailing: const Icon(Icons.add_box_rounded),
                              onTap: () => context
                                  .pushNamed(
                                    RouteLists.uploadNewPost,
                                  )
                                  .then((value) =>
                                      context.mounted ? context.pop() : null)),
                        ],
                      ),
                    );
                  },
                );
                // Navigator.of(context).pushNamed(RouteLists.postCreatePage);
              },
              icon: Icon(
                Icons.add_box_rounded,
                color: context.onPrimaryColor,
              )),
          IconButton(
              onPressed: () {
                context.pushNamed(RouteLists.settingScreen);
              },
              icon: Icon(
                Icons.settings,
                color: context.onPrimaryColor,
              ))
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }

  /// ignore: unused_element
  SingleChildScrollView _examplePages(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ShowCustomAppBarBody(),
              ));
            },
            child: const ListTile(title: Text("Create a new post => ")),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 2),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ShowCustomAppBarBody(),
              ));
            },
            child: const ListTile(title: Text("Intro Search Screen by Stack")),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CustomSliverBody(),
              ));
            },
            child: const ListTile(
                title: Text("Intro Search Screen by CustomSliver")),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ScrollBarExample(),
              ));
            },
            child: const ListTile(title: Text("ScrollBar Widget")),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const DraggableScrollableSheetExample(),
              ));
            },
            child:
                const ListTile(title: Text("DraggableScrollableSheet Widget")),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FlexibleExample(),
              ));
            },
            child: const ListTile(title: Text("Flexible Widget")),
          ),
        ],
      ),
    );
  }
}

class ShowCustomAppBarBody extends StatelessWidget {
  const ShowCustomAppBarBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StateLessWidgetWithAppBar(
      title: const Text(""),
      trailing: const Icon(Icons.home),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: const Color(0xFFD4DEE7),
              height: 300,
            ),
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(50)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueAccent.shade100,
                      border: Border.all(color: Colors.black54)),
                  child: ListView.builder(
                    itemCount: 20,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {},
                        title:
                            Text("TitleTitleTitleTitleTitleTitleTitle $index"),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class StateLessWidgetWithAppBar extends StatelessWidget {
  StateLessWidgetWithAppBar(
      {super.key,
      required this.child,
      required this.title,
      this.trailing,
      this.color});

  Widget child;
  Widget title;
  Widget? trailing;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        Positioned.fill(
          child: Container(
            color: color,
            child: child,
          ),
        ),
        Positioned.fill(
          bottom: MediaQuery.of(context).size.height - 80,
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: Center(
              child: ListTile(
                leading: const BackButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                    Colors.white,
                  )),
                ),
                title: title,
                trailing: trailing,
              ),
            ),
          ),
        ),

        /// appbar

        ///
      ]),
    );
  }
}

class CustomSliverBody extends StatefulWidget {
  const CustomSliverBody({super.key});

  @override
  State<CustomSliverBody> createState() => _CustomSliverBodyState();
}

class _CustomSliverBodyState extends State<CustomSliverBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          // SliverAppBar(
          //   title: const Text('Hello World'),
          //   actions: <Widget>[
          //     IconButton(
          //       icon: const Icon(Icons.shopping_cart),
          //       tooltip: 'Open shopping cart',
          //       onPressed: () {
          //         // handle the press
          //       },
          //     ),
          //   ],
          // ),

          SliverAppBar(
              // expandedHeight: 150.0,
              // flexibleSpace:  FlexibleSpaceBar(
              //   title: Container(color:Colors.green, child: const Text('Available seats')),
              // ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  tooltip: 'Add new entry',
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  tooltip: 'Add new entry',
                  onPressed: () {},
                ),
              ]),
          SliverList.builder(
            itemCount: 15,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("HEllo World $index"),
              );
            },
          ),
          // ...rest of body...
        ],
      ),
    );
  }
}

/// [ScrollBar]
///
class ScrollBarExample extends StatelessWidget {
  const ScrollBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ScrollBar Widget")),
        body: Scrollbar(
            thickness: 15,
            interactive: true,
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => ListTile(
                title: Text("Text $index"),
              ),
            )));
  }
}

/// [DraggableScrollableSheet]
///
class DraggableScrollableSheetExample extends StatelessWidget {
  const DraggableScrollableSheetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DraggableScrollableSheet Widget")),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Container(
              color: Colors.black,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Text(
                    "Hello World",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Welcome to My Home Page",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            maxChildSize: 0.7,
            initialChildSize: 0.7,
            minChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )),
                child: Scrollbar(
                  controller: scrollController,
                  interactive: true,
                  thickness: 10,
                  child: ListView.builder(
                    itemCount: 20,
                    controller: scrollController,
                    itemBuilder: (context, index) => ListTile(
                      title: Text("Text $index"),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// [Flexible]
///
class FlexibleExample extends StatelessWidget {
  const FlexibleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Flexible Widget")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.loose,
              flex: 2,
              child: ListView.builder(
                // shrinkWrap: true,
                itemCount: 20,
                itemBuilder: (context, index) => ListTile(
                  title: Text("Text $index"),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                color: Colors.green,
                child: ListView.builder(
                  // shrinkWrap: true,
                  itemCount: 20,
                  itemBuilder: (context, index) => ListTile(
                    title: Text("Text ${index * 2}"),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
