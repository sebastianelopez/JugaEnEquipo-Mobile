import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/post/post_model.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:provider/provider.dart';

class AnimatedPostCard extends StatelessWidget {
  final PostModel post;
  final int index;
  final bool isLoading;

  const AnimatedPostCard({
    super.key,
    required this.post,
    required this.index,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return PostCard(post: post);
    }

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: PostCard(post: post),
          ),
        );
      },
    );
  }
}

class Posts extends StatelessWidget {
  const Posts({super.key});

  @override
  Widget build(BuildContext context) {
    final homeScreen = Provider.of<HomeScreenProvider>(context);
    final size = MediaQuery.of(context).size;

    final posts = homeScreen.isLoading
        ? List.filled(
            7,
            PostModel(
              id: '',
              copy: 'aaaaaaaaaaaaaaaaa',
              likes: 1,
              comments: 2,
              createdAt: '2024-04-20 20:18:04Z',
              updatedAt: '',
              deletedAt: '',
            ))
        : homeScreen.posts;

    return Stack(
      children: [
        RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: homeScreen.onRefresh,
          child: homeScreen.isLoading || posts.isNotEmpty
              ? Skeletonizer(
                  enabled: homeScreen.isLoading,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    controller: homeScreen.scrollController,
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimatedPostCard(
                        post: posts[index],
                        index: index,
                        isLoading: homeScreen.isLoading,
                      );
                    },
                  ),
                )
              : _buildEmptyState(context),
        ),
        if (homeScreen.isLoading)
          Positioned(
              bottom: 40,
              left: size.width * 0.5 - 30,
              child: const LoadingIcon())
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.post_add_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Text(
                        AppLocalizations.of(context)!.noPostsYet,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Text(
                        AppLocalizations.of(context)!.followToSeePosts,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
