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
  final String? contextId;

  const PostCard({
    super.key,
    required this.post,
    this.contextId,
  });

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
    final homeProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    UserModel? user = Provider.of<UserProvider>(context).user;
    final isLoggedUserPost = user?.userName == widget.post.user;
    final imagesUrls = widget.post.resources?.map((e) => e.url).toList();

    // Fetch comments count when card is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        homeProvider.getCommentsQuantity(widget.post.id);
      }
    });

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: widget.post.height,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: widget.post.isVisible ? 1.0 : 0.0,
          curve: Curves.easeInOut,
          child: Card(
            margin: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            elevation: 4,
            shadowColor: Theme.of(context).shadowColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
              side: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          Semantics(
                            label: AppLocalizations.of(context)!
                                .viewProfileLabel(widget.post.user ?? 'user'),
                            button: true,
                            child: GestureDetector(
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
                                  height: 48.h,
                                  width: 48.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: _isAvatarPressed
                                        ? []
                                        : [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .shadowColor
                                                  .withOpacity(0.15),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                  ),
                                  child: CircleAvatar(
                                    maxRadius: 24.h,
                                    backgroundImage: (widget
                                                    .post.urlProfileImage !=
                                                null &&
                                            widget.post.urlProfileImage!
                                                .isNotEmpty &&
                                            (widget.post.urlProfileImage!
                                                    .startsWith('http://') ||
                                                widget.post.urlProfileImage!
                                                    .startsWith('https://')))
                                        ? NetworkImage(
                                            widget.post.urlProfileImage!)
                                        : const AssetImage(
                                                'assets/user_image.jpg')
                                            as ImageProvider,
                                    onBackgroundImageError:
                                        (exception, stackTrace) {
                                      // Error handling for image loading
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () => _navigateToUserProfile(
                                      context, widget.post.user ?? ''),
                                  child: Text(
                                    widget.post.user ?? 'user',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.sp,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  formatTimeElapsed(
                                      DateTime.parse(widget.post.createdAt),
                                      context),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withOpacity(0.7),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isLoggedUserPost)
                            PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert,
                                size: 20.sp,
                              ),
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
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        if (widget.post.copy != null &&
                            widget.post.copy!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: MentionText(
                                text: widget.post.copy!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  height: 1.5,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                ),
                              ),
                            ),
                          ),
                        if (imagesUrls != null && imagesUrls.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: MediaGrid(
                                resources: widget.post.resources ?? [],
                                heroTagPrefix: widget.post.id,
                                contextId: widget.contextId ?? 'home'),
                          ),
                        if (widget.post.sharedPost != null)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 4.h,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: SharedPost(
                                post: widget.post.sharedPost!,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Consumer<HomeScreenProvider>(
                      builder: (_, provider, __) {
                        final commentsCount =
                            provider.getCommentsCountForPost(widget.post.id);
                        if ((widget.post.likes != null &&
                                widget.post.likes! > 0) ||
                            commentsCount > 0) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (widget.post.likes != null &&
                                    widget.post.likes! > 0)
                                  Flexible(
                                    flex: 1,
                                    child: IntrinsicWidth(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            size: 16.sp,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ),
                                          SizedBox(width: 6.w),
                                          TweenAnimationBuilder<int>(
                                            tween: IntTween(
                                              begin: widget.post.likes ?? 0,
                                              end: widget.post.likes ?? 0,
                                            ),
                                            duration: const Duration(
                                                milliseconds: 300),
                                            builder: (context, value, child) {
                                              return AnimatedSwitcher(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                child: Text(
                                                  value.toString(),
                                                  key: ValueKey(value),
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.color,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  const SizedBox.shrink(),
                                if (commentsCount > 0)
                                  Flexible(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () {
                                        provider.openCommentsModal(
                                          context,
                                          postId: widget.post.id,
                                          onCommentAdded: () {
                                            provider.refreshCommentsQuantity(
                                                widget.post.id);
                                          },
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                      ),
                                      child: Text(
                                        "$commentsCount ${AppLocalizations.of(context)!.commentsLabel}",
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                      height: 1,
                      thickness: 0.5,
                      indent: 16.w,
                      endIndent: 16.w,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // Botón de Like Animado
                          Semantics(
                            label: _isLiked
                                ? AppLocalizations.of(context)!.unlikePostLabel
                                : AppLocalizations.of(context)!.likePostLabel,
                            button: true,
                            child: AnimatedBuilder(
                              animation: _likeScaleAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _likeScaleAnimation.value,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12.r),
                                      onTap: _handleLike,
                                      child: Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        child: AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: Icon(
                                            _isLiked
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            key: ValueKey(_isLiked),
                                            color: _isLiked
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .error
                                                : Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color
                                                    ?.withOpacity(0.7),
                                            size: 24.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Botón de Comentarios Animado
                          Semantics(
                            label:
                                AppLocalizations.of(context)!.addCommentLabel,
                            button: true,
                            child: GestureDetector(
                              onTapDown: (_) {
                                setState(() {
                                  _showComments = true;
                                });
                              },
                              onTapUp: (_) {
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
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
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12.r),
                                    onTap: () {
                                      homeProvider.openCommentsModal(
                                        context,
                                        autofocus: true,
                                        postId: widget.post.id,
                                        onCommentAdded: () {
                                          homeProvider.refreshCommentsQuantity(
                                              widget.post.id);
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Icon(
                                        Icons.message_outlined,
                                        size: 24.sp,
                                        color: AppTheme.accent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Botón de Share Animado
                          Semantics(
                            label: AppLocalizations.of(context)!.sharePostLabel,
                            button: true,
                            child: GestureDetector(
                              onTapDown: (_) {
                                setState(() {
                                  _isSharePressed = true;
                                });
                              },
                              onTapUp: (_) {
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
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
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12.r),
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        constraints: BoxConstraints(
                                          maxHeight: 600.h,
                                          maxWidth: 1200,
                                        ),
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        builder: (BuildContext context) {
                                          return ChangeNotifierProvider(
                                            create: (_) => PostProvider()
                                              ..generatePostId(),
                                            child: CreatePost(
                                              sharedPost: widget.post,
                                            ),
                                          );
                                        },
                                      ).then((value) {
                                        imageProvider.clearMediaFileList();
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: AnimatedRotation(
                                        turns: _isSharePressed ? 0.1 : 0.0,
                                        duration:
                                            const Duration(milliseconds: 100),
                                        child: Icon(
                                          Icons.share_outlined,
                                          size: 24.sp,
                                          color: AppTheme.success,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
