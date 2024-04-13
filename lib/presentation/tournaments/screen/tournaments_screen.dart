import 'package:flutter/material.dart';
import 'package:jugaenequipo/widgets/widgets.dart';

class TournamentsScreen extends StatelessWidget {
  const TournamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: MainNavbar(),
      ),
      body: Text("Tournaments"),
      bottomNavigationBar: BottomNavigationBarCustom(),
    );
  }
}