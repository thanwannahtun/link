import 'package:flutter/material.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

import '../../../core/utils/platform.dart';
import '../../utils/context.dart';

class UserActivityScreen extends StatefulWidget {
  const UserActivityScreen({super.key});

  @override
  State<UserActivityScreen> createState() => _UserActivityScreenState();
}

class _UserActivityScreenState extends State<UserActivityScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(body: _body(context), title: "Activity");
  }

  Center _body(BuildContext context) {
              Platform platform = Platform.currentPlatform(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         if(Platform.laptop || Platform.desktop) ElevatedButton(
            onPressed: () {
              context.showSnackBar(Context.snackBar(Text(
                  "${platform.name} : ${platform.width} : actural width : ${context.size?.width}")));
            },
            child: const Text("Current Platform"),
          ),
        ],
      ),
    );
  }
}
