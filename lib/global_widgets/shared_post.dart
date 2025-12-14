import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/post/post_model.dart';
import 'package:jugaenequipo/global_widgets/mention_text.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/utils/utils.dart';
import 'package:provider/provider.dart';

class SharedPost extends StatelessWidget {
  final PostModel post;

  const SharedPost({super.key, required this.post});

  void _navigateToPostDetail(BuildContext context) {
    Navigator.pushNamed(
      context,
      'post-detail',
      arguments: {'postId': post.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaResources = post.resources;

    return ChangeNotifierProvider.value(
      value: PostProvider()..getCommentsQuantity(post.id),
      child: Center(
        child: Card(
          elevation: 0,
          child: InkWell(
            onTap: () => _navigateToPostDetail(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.2),
                  ),
                  BoxShadow(
                    color: Theme.of(context).colorScheme.surface,
                    spreadRadius: -1.0,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: SizedBox(
                          height: 50.h,
                          width: 50.h,
                          child: CircleAvatar(
                            maxRadius: 15.h,
                            backgroundImage: (post.urlProfileImage != null &&
                                    post.urlProfileImage!.isNotEmpty &&
                                    (post.urlProfileImage!
                                            .startsWith('http://') ||
                                        post.urlProfileImage!
                                            .startsWith('https://')))
                                ? NetworkImage(post.urlProfileImage!)
                                : const AssetImage('assets/user_image.jpg')
                                    as ImageProvider,
                          ),
                        ),
                        title: Text(post.user ?? 'user',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 15.h)),
                        subtitle: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  formatTimeElapsed(
                                      DateTime.parse(post.createdAt), context),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 13.h)),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          if (post.copy != null && post.copy!.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              width: double.infinity,
                              child: MentionText(
                                text: post.copy!,
                                style: TextStyle(fontSize: 13.h),
                              ),
                            ),
                          if (mediaResources != null && mediaResources.isNotEmpty)
                            Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: MediaGrid(
                                    resources: mediaResources,
                                    heroTagPrefix: post.id,
                                    contextId: 'shared')),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
