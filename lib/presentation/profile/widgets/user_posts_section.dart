import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/post/post_model.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';

class UserPostsSection extends StatelessWidget {
  final List<PostModel> posts;
  final bool isLoading;

  const UserPostsSection({
    super.key,
    required this.posts,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.postsLabel,
            style: TextStyle(
              fontSize: 16.h,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (posts.isEmpty)
            Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppTheme.primary.withOpacity( 0.2),
                  width: 1,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.post_add,
                      size: 48.h,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity( 0.3),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      AppLocalizations.of(context)!.noPostsYet,
                      style: TextStyle(
                        fontSize: 14.h,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity( 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: posts.take(3).map((post) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: PostCard(post: post),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
