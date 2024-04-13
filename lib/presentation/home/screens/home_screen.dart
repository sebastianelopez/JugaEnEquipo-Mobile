import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/home/widgets/posts.dart';
import 'package:jugaenequipo/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: MainNavbar(),
      ),
      body: Posts(),
      bottomNavigationBar: BottomNavigationBarCustom(),
    );
  }
}
