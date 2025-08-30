import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/post/post_model.dart';
import 'package:jugaenequipo/datasources/models/user_model.dart';
import 'package:jugaenequipo/datasources/post_use_cases/add_like_post_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_users_by_username_use_case.dart';
import 'package:jugaenequipo/global_widgets/create_post.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/utils/utils.dart';
import 'package:provider/provider.dart';

enum Menu { delete }

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  Future<void> _navigateToUserProfile(
      BuildContext context, String username) async {
    try {
      final users = await getUsersByUsername(username);
      if (users != null && users.isNotEmpty) {
        final postUser = users.first;
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            'profile',
            arguments: {'userId': postUser.id},
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.errorLoadingUserProfile),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeScreenProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    UserModel? user = Provider.of<UserProvider>(context).user;
    final isLoggedUserPost = user?.userName == post.user;
    final imagesUrls = post.resources?.map((e) => e.url).toList();

    return ChangeNotifierProvider.value(
      value: PostProvider()..getCommentsQuantity(post.id),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: post.height,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: post.isVisible ? 1.0 : 0.0,
            curve: Curves.easeInOut,
            child: Card(
              margin: EdgeInsets.only(
                top: 8.0.w,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: GestureDetector(
                          onTap: () =>
                              _navigateToUserProfile(context, post.user ?? ''),
                          child: SizedBox(
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
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => _navigateToUserProfile(
                                  context, post.user ?? ''),
                              child: Text(
                                post.user ?? 'user',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.h,
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            if (isLoggedUserPost)
                              PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (Menu item) {
                                  homeProvider.handlePostMenuOptionClick(
                                      item, post.id);
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<Menu>>[
                                  PopupMenuItem<Menu>(
                                    value: Menu.delete,
                                    child: ListTile(
                                      leading: const Icon(Icons.delete_outline),
                                      title: Text(AppLocalizations.of(context)!
                                          .deletePost),
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                        subtitle: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TODO: getTeamById()
                              /*  
                              if (post.user.teamId != null)
                              Text(
                                post.user.team!.name,
                                style: const TextStyle(fontSize: 13),
                              ), */
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              width: double.infinity,
                              child: Text(
                                post.copy!,
                                style: TextStyle(fontSize: 13.h),
                              ),
                            ),
                          if (imagesUrls != null && imagesUrls.isNotEmpty)
                            Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ImageGrid(images: imagesUrls)),
                          if (post.sharedPost != null)
                            Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                width: double.infinity,
                                child: SharedPost(
                                  post: post.sharedPost!,
                                )),
                        ],
                      ),
                      Consumer<PostProvider>(
                        builder: (_, provider, __) {
                          final commentsCount =
                              provider.getCommentsCountForPost(post.id);
                          if ((post.likes != null && post.likes! > 0) ||
                              commentsCount > 0) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (post.likes != null && post.likes! > 0)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 15.0.h,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        post.likes.toString(),
                                        style: TextStyle(fontSize: 14.h),
                                      ),
                                    ],
                                  )
                                else
                                  const SizedBox.shrink(),
                                if (commentsCount > 0)
                                  TextButton(
                                    onPressed: () {
                                      homeProvider.openCommentsModal(context,
                                          postId: post.id);
                                    },
                                    child: Text(
                                      "$commentsCount ${AppLocalizations.of(context)!.commentsLabel}",
                                      style: TextStyle(fontSize: 14.h),
                                    ),
                                  ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      Divider(
                        color: Theme.of(context).dividerColor,
                        height: 5,
                        indent: 10,
                        endIndent: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                            icon: const Icon(Icons.favorite),
                            iconSize: 24.h,
                            onPressed: () {
                              addLikePost(post.id);
                              //TODO: If the user has already liked the post, remove the like
                              // removeLikePost(post.id);
                            },
                          ),
                          IconButton(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                            icon: const Icon(Icons.message),
                            iconSize: 24.h,
                            onPressed: () {
                              homeProvider.openCommentsModal(context,
                                  autofocus: true, postId: post.id);
                            },
                          ),
                          IconButton(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                            icon: const Icon(Icons.share),
                            iconSize: 24.h,
                            onPressed: () {
                              postProvider.generatePostId();
                              showModalBottomSheet(
                                context: context,
                                constraints: BoxConstraints(
                                  maxHeight: 600.h,
                                  maxWidth: 1200,
                                ),
                                isScrollControlled: true,
                                useSafeArea: true,
                                builder: (BuildContext context) {
                                  return CreatePost(
                                    sharedPost: post,
                                  );
                                },
                              ).then((value) {
                                postProvider.clearPostId();
                                imageProvider.clearMediaFileList();
                              });
                            },
                          ),
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
