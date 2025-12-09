import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/home/widgets/posts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Uses global HomeScreenProvider from main.dart
    return const Scaffold(
      body: Posts(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
