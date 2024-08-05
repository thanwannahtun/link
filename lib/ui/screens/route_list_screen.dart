import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/domain/bloc_utils/bloc_crud_status.dart';
import 'package:link/models/post_route.dart';
import 'package:link/ui/screens/post_route_card.dart';
import 'package:link/ui/utils/route_list.dart';
import 'package:shimmer/shimmer.dart';

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
          print("::::::::::::: ${state.status}");
          if (state.status == BlocStatus.doNot) {
            return _buildShimmer(context);
          } else if (state.status == BlocStatus.doing) {
            return _buildShimmer(context);
          }
          posts = state.routes;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemBuilder: (context, index) {
                PostRoute post = posts[index];
                return PostRouteCard(
                  post: post,
                  onAgencyPressed: () => Navigator.of(context)
                      .pushNamed(RouteLists.agencyProfile, arguments: post),
                );
              },
              itemCount: posts.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                height: 20,
              ),
            ),
          );
        },
        listener: (context, state) {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<PostRouteCubit>().fetchRoutes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _buildShimmer(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.black12,
          highlightColor: Colors.black45,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PostRouteCard(
              post: PostRoute(),
              loading: true,
            ),
          ),
        );
      },
    );
  }
}
