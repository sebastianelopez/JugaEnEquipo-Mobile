import 'package:flutter/material.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/hashtags/business_logic/hashtag_posts_provider.dart';
import 'package:jugaenequipo/presentation/home/widgets/post_card.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HashtagPostsScreen extends StatefulWidget {
  final String hashtag;

  const HashtagPostsScreen({
    super.key,
    required this.hashtag,
  });

  @override
  State<HashtagPostsScreen> createState() => _HashtagPostsScreenState();
}

class _HashtagPostsScreenState extends State<HashtagPostsScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return ChangeNotifierProvider(
      create: (_) => HashtagPostsProvider(hashtag: widget.hashtag),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            '#${widget.hashtag}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Consumer<HashtagPostsProvider>(
          builder: (context, provider, _) {
            final posts = provider.posts;
            final isLoading = provider.isLoading && posts.isEmpty;

            if (isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              );
            }

            if (posts.isEmpty && !provider.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.post_add,
                      size: 64.h,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      localizations?.noPostsYet ?? 'No posts found',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: AppTheme.primary,
              onRefresh: provider.onRefresh,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                controller: provider.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: posts.length + (provider.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final post = posts[index];
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      provider.getCommentsQuantity(post.id);
                    }
                  });

                  return PostCard(
                    post: post,
                    contextId: 'hashtag',
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

