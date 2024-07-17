import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/domain/bloc_utils/bloc_crud_status.dart';
import 'package:link/models/post_route.dart';
import 'package:link/ui/widget_extension.dart';

class RouteListScreen extends StatefulWidget {
  const RouteListScreen({super.key});

  @override
  State<RouteListScreen> createState() => _RouteListScreenState();
}

class _RouteListScreenState extends State<RouteListScreen> {
  List<PostRoute> posts = [];
  @override
  void initState() {
    super.initState();
    context.read<PostRouteCubit>().fetchRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Container(),
        title: const Text("Link"),
      ),
      body: BlocConsumer<PostRouteCubit, PostRouteState>(
        builder: (context, state) {
          posts = state.routes;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemBuilder: (context, index) {
                PostRoute post = posts[index];
                return PostRouteCard(post: post);
              },
              itemCount: posts.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                height: 20,
              ),
            ),
          );
        },
        listener: (context, state) {
          showSnackBar({String? message}) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            SnackBar snackBar = SnackBar(content: Text(message ?? ""));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }

          if (state.status == BlocStatus.done) {
            showSnackBar(message: 'success');
          }
          if (state.status == BlocStatus.doing) {
            showSnackBar(message: "fetching..");
          } else if (state.status == BlocStatus.doNot) {
            showSnackBar(message: state.error);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<PostRouteCubit>().fetchRoutes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PostRouteCard extends StatelessWidget {
  const PostRouteCard({
    super.key,
    required this.post,
  });

  final PostRoute post;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.black38,
                      child: Image.network(
                        post.agency?.logo ?? "",
                        fit: BoxFit.cover,
                      ),
                    ).clipRRect(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.agency?.name ?? "agency",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          post.scheduleDate?.toIso8601String() ?? "",
                          style:
                              const TextStyle(fontSize: 10, color: Colors.red),
                        ),
                      ],
                    )
                  ],
                ).sizedBox(),
              ), // profile section
              Expanded(
                  child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 100),
                          itemBuilder: (context, index) => Row(
                            children: [
                              Text(post.seats?[index].name ?? ""),
                            ],
                          ),
                          itemCount: post.seats?.length ?? 0,
                        )));
                      },
                      child: const Icon(Icons.more_vert_outlined)),
                ),
              )), // option section
            ],
          ), // head
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.blueAccent,
            child: Image.network(
                "https://images.stockcake.com/public/8/4/f/84f518cc-4f5c-4bd4-95fd-7432ac50086d_large/doctors-in-meeting-stockcake.jpg"),
          ),
          SizedBox(
            height: 50,
            child: Expanded(
              child: ListView.builder(
                itemCount: post.midpoints?.length ?? 0,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index < post.midpoints!.length) {
                    TextStyle textStyle =
                        const TextStyle(fontSize: 12, color: Colors.black54);
                    if (index == 0 || index == (post.midpoints!.length - 1)) {
                      textStyle = textStyle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black);
                    }
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            post.midpoints![index].cityName ?? "",
                            style: textStyle,
                          ),
                        ),
                        if (index < post.midpoints!.length - 1)
                          const Text(
                              ' -> '), // Add separator if not the last item
                      ],
                    );
                  } else {
                    return Container(); // Placeholder, should not be reached
                  }
                },
              ),
            ),
          ),
          // ),
          const Divider(
            height: 0.3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text((post.likeCounts ?? 0).toString())),
              Expanded(child: Text((post.commentCounts ?? 0).toString())),
              Expanded(child: Text((post.commentCounts ?? 0).toString())),
            ],
          ),
          // image
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: Icon(Icons.hotel_class_outlined)),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        //showModelBottomSheet for commented content
                      },
                      child: const Icon(Icons.comment))),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        //function for phone call
                      },
                      child: const Icon(Icons.phone))),
              const Expanded(
                child: Icon(Icons.location_on_outlined),
              ),
              Expanded(
                child: InkWell(
                    onTap: () {
                      //showModelBottomSheet for shared users
                    },
                    child: const Icon(Icons.share)),
              ),
            ],
          ).padding(padding: const EdgeInsets.all(10.0)),
          // icons
          const Divider(
            height: 0.3,
          ),
        ],
      ),
    );
  }
}
