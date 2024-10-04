import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/tournaments/business_logic/tournaments_provider.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournaments_table.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TournamentsScreen extends StatelessWidget {
  const TournamentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(55.h),
        child: const MainNavbar(),
      ),
      drawer: const DrawerNav(),
      body: ChangeNotifierProvider(
        create: (context) => TournamentsProvider(),
        child: const TournamentsTable(),
      ),
      bottomNavigationBar: const BottomNavigationBarCustom(),
    );
  }
}
