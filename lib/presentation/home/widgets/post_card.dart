import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/post/post_model.dart';
import 'package:jugaenequipo/datasources/models/user_model.dart';
import 'package:jugaenequipo/datasources/post_use_cases/add_like_post_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_users_by_username_use_case.dart';
import 'package:jugaenequipo/global_widgets/create_post.dart';
import 'package:jugaenequipo/global_widgets/mention_text.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/utils/utils.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';

enum Menu { delete }

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late Animation<double> _likeScaleAnimation;

  bool _isLiked = false;
  bool _showComments = false;
  bool _isAvatarPressed = false;
  bool _isSharePressed = false;

  @override
  void initState() {
    super.initState();

    // Inicializar controlador de animación para likes
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Configurar animación de escala para el botón de like
    _likeScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _likeAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleLike() async {
    setState(() {
      _isLiked = !_isLiked;
    });

    if (_isLiked) {
      await _likeAnimationController.forward();
      await _likeAnimationController.reverse();
    }

    // Llamar a la función original de like
    addLikePost(widget.post.id);
  }

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
    final isLoggedUserPost = user?.userName == widget.post.user;
    final imagesUrls = widget.post.resources?.map((e) => e.url).toList();

    return ChangeNotifierProvider.value(
      value: PostProvider()..getCommentsQuantity(widget.post.id),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: widget.post.height,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: widget.post.isVisible ? 1.0 : 0.0,
            curve: Curves.easeInOut,
            child: Card(
              margin: EdgeInsets.only(
                top: 8.0.w,
              ),
              elevation: 12,
              shadowColor: AppTheme.primary.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              _isAvatarPressed = true;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _isAvatarPressed = false;
                            });
                            _navigateToUserProfile(
                                context, widget.post.user ?? '');
                          },
                          onTapCancel: () {
                            setState(() {
                              _isAvatarPressed = false;
                            });
                          },
                          child: AnimatedScale(
                            scale: _isAvatarPressed ? 0.9 : 1.0,
                            duration: const Duration(milliseconds: 100),
                            child: Container(
                              height: 50.h,
                              width: 50.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: _isAvatarPressed
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                              ),
                              child: CircleAvatar(
                                maxRadius: 25.h,
                                backgroundImage: (widget.post.urlProfileImage !=
                                            null &&
                                        widget
                                            .post.urlProfileImage!.isNotEmpty &&
                                        (widget.post.urlProfileImage!
                                                .startsWith('http://') ||
                                            widget.post.urlProfileImage!
                                                .startsWith('https://')))
                                    ? NetworkImage(widget.post.urlProfileImage!)
                                    : const AssetImage('assets/user_image.jpg')
                                        as ImageProvider,
                              ),
                            ),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => _navigateToUserProfile(
                                  context, widget.post.user ?? ''),
                              child: Text(
                                widget.post.user ?? 'user',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.h,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            if (isLoggedUserPost)
                              PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (Menu item) {
                                  homeProvider.handlePostMenuOptionClick(
                                      item, widget.post.id);
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
                                      DateTime.parse(widget.post.createdAt),
                                      context),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 13.h)),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          if (widget.post.copy != null &&
                              widget.post.copy!.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              width: double.infinity,
                              child: MentionText(
                                text: widget.post.copy!,
                                style: TextStyle(fontSize: 13.h),
                              ),
                            ),
                          if (imagesUrls != null && imagesUrls.isNotEmpty)
                            Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: MediaGrid(
                                    resources: widget.post.resources ?? [])),
                          if (widget.post.sharedPost != null)
                            Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                width: double.infinity,
                                child: SharedPost(
                                  post: widget.post.sharedPost!,
                                )),
                        ],
                      ),
                      Consumer<PostProvider>(
                        builder: (_, provider, __) {
                          final commentsCount =
                              provider.getCommentsCountForPost(widget.post.id);
                          if ((widget.post.likes != null &&
                                  widget.post.likes! > 0) ||
                              commentsCount > 0) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (widget.post.likes != null &&
                                    widget.post.likes! > 0)
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
                                      TweenAnimationBuilder<int>(
                                        tween: IntTween(
                                          begin: widget.post.likes ?? 0,
                                          end: widget.post.likes ?? 0,
                                        ),
                                        duration:
                                            const Duration(milliseconds: 300),
                                        builder: (context, value, child) {
                                          return AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            child: Text(
                                              value.toString(),
                                              key: ValueKey(value),
                                              style: TextStyle(
                                                fontSize: 14.h,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                else
                                  const SizedBox.shrink(),
                                if (commentsCount > 0)
                                  TextButton(
                                    onPressed: () {
                                      homeProvider.openCommentsModal(context,
                                          postId: widget.post.id);
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
                          // Botón de Like Animado
                          AnimatedBuilder(
                            animation: _likeScaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _likeScaleAnimation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    icon: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: Icon(
                                        _isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        key: ValueKey(_isLiked),
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                    iconSize: 24.h,
                                    onPressed: _handleLike,
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: AppTheme.primary,
                                      elevation: 0,
                                      padding: EdgeInsets.all(8.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Botón de Comentarios Animado
                          GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                _showComments = true;
                              });
                            },
                            onTapUp: (_) {
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                setState(() {
                                  _showComments = false;
                                });
                              });
                            },
                            onTapCancel: () {
                              setState(() {
                                _showComments = false;
                              });
                            },
                            child: AnimatedScale(
                              scale: _showComments ? 0.9 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.message),
                                  iconSize: 24.h,
                                  color: AppTheme.accent,
                                  onPressed: () {
                                    homeProvider.openCommentsModal(context,
                                        autofocus: true,
                                        postId: widget.post.id);
                                  },
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: AppTheme.accent,
                                    elevation: 0,
                                    padding: EdgeInsets.all(8.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Botón de Share Animado
                          GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                _isSharePressed = true;
                              });
                            },
                            onTapUp: (_) {
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                setState(() {
                                  _isSharePressed = false;
                                });
                              });
                            },
                            onTapCancel: () {
                              setState(() {
                                _isSharePressed = false;
                              });
                            },
                            child: AnimatedScale(
                              scale: _isSharePressed ? 0.9 : 1.0,
                              duration: const Duration(milliseconds: 100),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: AnimatedRotation(
                                    turns: _isSharePressed ? 0.1 : 0.0,
                                    duration: const Duration(milliseconds: 100),
                                    child: const Icon(Icons.share),
                                  ),
                                  iconSize: 24.h,
                                  color: AppTheme.success,
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
                                          sharedPost: widget.post,
                                        );
                                      },
                                    ).then((value) {
                                      postProvider.clearPostId();
                                      imageProvider.clearMediaFileList();
                                    });
                                  },
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: AppTheme.success,
                                    elevation: 0,
                                    padding: EdgeInsets.all(8.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
