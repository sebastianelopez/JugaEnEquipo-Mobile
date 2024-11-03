import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:jugaenequipo/presentation/home/widgets/posts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => HomeScreenProvider(context: context),
        child: const Posts(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
