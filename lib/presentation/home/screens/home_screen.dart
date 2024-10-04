import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:jugaenequipo/presentation/home/widgets/posts.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainNavbar(),
      drawer: const DrawerNav(),
      body: ChangeNotifierProvider(
        create: (context) => HomeScreenProvider(),
        child: const Posts(),
      ),
      bottomNavigationBar: const BottomNavigationBarCustom(),
    );
  }
}
