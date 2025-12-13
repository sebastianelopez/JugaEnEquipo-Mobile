import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/teams/business_logic/teams_screen_provider.dart';
import 'package:jugaenequipo/presentation/teams/widgets/team_card.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Teams extends StatelessWidget {
  const Teams({super.key});

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamsScreenProvider>(context);
    final teams = teamProvider.teams;
    final isLoading = teamProvider.isLoading && teams.isEmpty;

    // Add 1 to itemCount if loading more data to show loading indicator
    final itemCount =
        isLoading ? 5 : teams.length + (teamProvider.isLoadingMore ? 1 : 0);

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: teamProvider.onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        controller: teamProvider.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          // Show skeleton loaders during initial load
          if (isLoading) {
            return Padding(
              padding: EdgeInsets.only(bottom: index < 4 ? 20.0 : 0.0),
              child: _TeamCardSkeleton(),
            );
          }

          // Show loading indicator at the end
          if (index >= teams.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  ),
                ),
              ),
            );
          }

          return Padding(
            padding:
                EdgeInsets.only(bottom: index < teams.length - 1 ? 20.0 : 0.0),
            child: TeamCard(
              team: teams[index],
            ),
          );
        },
      ),
    );
  }
}

class _TeamCardSkeleton extends StatefulWidget {
  const _TeamCardSkeleton();

  @override
  State<_TeamCardSkeleton> createState() => _TeamCardSkeletonState();
}

class _TeamCardSkeletonState extends State<_TeamCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: 220.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.withOpacity(0.1),
                  Colors.grey.withOpacity(0.05),
                ],
              ),
            ),
            child: _buildShimmerOverlay(context),
          ),
        );
      },
    );
  }

  Widget _buildShimmerOverlay(BuildContext context) {
    final shimmerColor = Colors.white.withOpacity(
      0.1 + (_animation.value * 0.15),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1.0 + (_animation.value * 2), 0),
          end: Alignment(1.0 + (_animation.value * 2), 0),
          colors: [
            Colors.transparent,
            shimmerColor,
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row Skeleton
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Team Name Skeleton
                      Container(
                        width: double.infinity,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Badge Skeleton
                      Container(
                        width: 80.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Verified Badge Skeleton (optional)
                Container(
                  width: 60.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Game & Members Info Skeleton
            Row(
              children: [
                // Game Icon Skeleton
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Game Name Skeleton
                      Container(
                        width: 120.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Members Count Skeleton
                      Container(
                        width: 100.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ],
                  ),
                ),
                // Members Avatars Skeleton
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
