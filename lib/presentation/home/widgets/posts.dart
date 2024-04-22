import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';
import 'package:jugaenequipo/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Posts extends StatelessWidget {
  const Posts({super.key});

  @override
  Widget build(BuildContext context) {
    final homeScreen = Provider.of<HomeScreenProvider>(context);
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: homeScreen.onRefresh,
          child: ListView.builder(
            controller: homeScreen.scrollController,
            itemCount: homeScreen.postsmocks.length,
            itemBuilder: (BuildContext context, int index) {
              return PostCard(
                post: homeScreen.postsmocks[index],
              );
            },
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
