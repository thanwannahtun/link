import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/theme/theme_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/models/agency.dart';
import 'package:link/ui/utils/route_list.dart';

import '../../../core/utils/app_insets.dart';
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
    return Column(
      children: [
        // ListTile(
        //   title: const Text("Get Routes Screen"),
        //   trailing: const Icon(Icons.arrow_right_alt_sharp),
        //   onTap: () => context.pushNamed(
        //     RouteLists.getTrendingRoutes,
        //   ),
        // ),
        Card(
          child: ListTile(
            title: const Text("Theme"),
            leading: const Icon(Icons.sunny),
            onTap: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ),

        /// Temp UI Sketch
        Card(
          child: ListTile(
            title: const Text("Sign Up Screen (Sketch)"),
            leading: const Icon(Icons.person),
            // onTap: () => context.pushNamed(RouteLists.signUp),
            onTap: () => context.pushNamed(RouteLists.createPasswordAuthScreen),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text("Sign In With Email Screen (Sketch)"),
            leading: const Icon(Icons.email_outlined),
            onTap: () => context.pushNamed(RouteLists.signInWithEmail),
          ),
        ),
      ],
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
    id: "66b8d3c63e1a9b47a2c0e6a5",
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
