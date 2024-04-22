import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class MainNavbar extends StatelessWidget {
  const MainNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primary,
      leadingWidth: 60.0,
      leading: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: const CircleAvatar(
          backgroundImage: AssetImage(
              'assets/login.png'), // Replace with your profile image path
          radius: 16,
          backgroundColor: Colors.white,
        ),
      ),
      shadowColor: Colors.black,
      actions: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                  hintText: 'Search',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  // Handle the search input changes here.
                },
              ),
            ),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.message),
              onPressed: () {
                // Handle the message icon press here.
              },
            ),
          ],
        ),
      ],
    );
  }
}
