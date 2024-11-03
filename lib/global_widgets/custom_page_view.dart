import 'package:flutter/material.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';

class CustomPageView extends StatelessWidget {
  final List<Widget> children;

  const CustomPageView({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationProvider>(context);
    return PageView(
      controller: navigation.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}
