import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/post_model.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:provider/provider.dart';

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
          child: Skeletonizer(
            enabled: homeScreen.isLoading,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              controller: homeScreen.scrollController,
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                return PostCard(
                  post: posts[index],
                );
              },
            ),
          ),
        ),
        if (homeScreen.isLoading)
          Positioned(
              bottom: 40,
              left: size.width * 0.5 - 30,
              child: const LoadingIcon())
      ],
    );
  }
}
