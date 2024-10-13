import 'package:flutter/material.dart';
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
    ListTile(
      title: const Text("Agency Profile by 1"),
      trailing: IconButton.filled(
          onPressed: () {
            // context.pushNamed(
            //   RouteLists.publicAgencyProfile,
            //   arguments: Agency(id: "66b8d3c63e1a9b47a2c0e6a5"),
            // );
            /*
            context.push(
              MaterialPageRoute(
                  builder: (context) => BlocProvider(
                        create: (BuildContext context) => AgencyCubit(),
                        child: const PublicAgencyProfileScreen(),
                      ),
                  settings: RouteSettings(
                      arguments: Agency(id: "66b8d3c63e1a9b47a2c0e6a5"))),
            );
            */
            /*
            context.push(
              MaterialPageRoute(
                  builder: (context) => BlocProvider(
                        create: (BuildContext context) => AgencyCubit(),
                        child: const PublicProfileScreen(),
                      ),
                  settings: RouteSettings(
                      arguments: Agency(id: "66b8d3c63e1a9b47a2c0e6a5"))),
            );
            */
          },
          icon: const Icon(Icons.arrow_right)),
    );
    return Container();
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
