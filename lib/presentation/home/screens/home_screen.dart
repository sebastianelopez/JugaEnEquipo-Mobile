import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:jugaenequipo/presentation/home/widgets/posts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  HomeScreenProvider? _homeScreenProvider;

  @override
  void initState() {
    super.initState();
    // Defer provider creation until after first frame to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _homeScreenProvider = HomeScreenProvider(context: context);
        });
      }
    });
  }

  @override
  void dispose() {
    _homeScreenProvider?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Show loading while provider is being created
    if (_homeScreenProvider == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: _homeScreenProvider!,
        child: const Posts(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
