import 'package:flutter/material.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/models/comment.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/screens/post_route_card.dart';
import 'package:link/ui/utils/context.dart';
import 'package:link/ui/widgets/comment_persistent_footer_button.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Post? post;

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      post = ModalRoute.of(context)?.settings.arguments as Post;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PostRouteCard(
              post: post ?? const Post(),
              onCommentPressed: onCommentPressed,
              onLocationPressed: () {},
              onStarPressed: (isLiked) {},
              paddingLeft: const EdgeInsets.only(left: 10),
            ),
          ],
        ),
      ),
    );
  }

  // ? : onCommentPressed
  void Function()? onCommentPressed() {
    List<Comment> comments = post?.comments ?? [];

    Context.showBottomSheet(context,
        setViewInset: true,
        isScrollControlled: true,
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: comments.length,
          itemBuilder: (context, index) {
            Comment comment = comments[index];
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(comment.content ?? ""),
              subtitle: Text(comment.user?.email ?? "user@gmail.com"),
              trailing: Text(comment.createdAt != null
                  ? DateTimeUtil.formatDateTime(comment.createdAt)
                  : ""),
            );
          },
        ),
        persistentFooterButtons: [
          CommentPersistentFooterButton(
            onIconPressed: () {},
            onEditingComplete: () {},
          )
        ]);
    return null;
  }

// ? : onStarPressed
// void Function()? onStarPressed() {
//   List<Like> likes = post?.likes ?? [];

//   Context.showBottomSheet(
//     context,
//     body: ListView.builder(
//       shrinkWrap: true,
//       itemCount: likes.length,
//       itemBuilder: (context, index) {
//         if (likes.isEmpty) {
//           return const ListTile(
//             title: Text("Be the First Person!"),
//             subtitle: Text("hit the like button!"),
//           );
//         }

//         Like like = likes[index];

//         return ListTile(
//           leading: const Icon(Icons.person),
//           title: Text(like.user?.fullName ?? ""),
//           subtitle: Text(like.user?.email ?? "user@gmail.com"),
//           trailing: Text(like.createdAt != null
//               ? AppDateUtil.formatDateTime(like.createdAt)
//               : ""),
//         );
//       },
//     ),
//   );
//   return null;
// }
}
