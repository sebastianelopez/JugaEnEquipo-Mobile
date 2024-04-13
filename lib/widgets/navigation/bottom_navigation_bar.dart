import 'package:flutter/material.dart';
import 'package:jugaenequipo/router/app_routes.dart';

class BottomNavigationBarCustom extends StatefulWidget {
  const BottomNavigationBarCustom({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarCustom> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBarCustom> {
  int _selectedIndex = 0;

  final mainNavigationOptions = AppRoutes.mainNavigationOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (mainNavigationOptions[index].route != "notifications") {
      print('a');
      Navigator.pushReplacementNamed(
          context, mainNavigationOptions[index].route);
    } else {
      print('b');
      FocusScope.of(context).unfocus();
      Navigator.pushNamed(context, mainNavigationOptions[index].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.red[900],
      onTap: _onItemTapped,
      items: mainNavigationOptions.map((option) {
        return BottomNavigationBarItem(
          icon: Icon(
            option.icon,
            color: const Color.fromARGB(255, 1, 15, 36),
          ),
          label: '',
        );
      }).toList(),
    );
  }
}
