import 'package:flutter/material.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.h),
        child: const MainNavbar(),
      ),
      body: const Text("Teams"),
      bottomNavigationBar: BottomNavigationBarCustom(),
    );
  }
}
