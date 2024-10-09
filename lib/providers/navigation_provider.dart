import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  int get currentPage => _currentPage;

  set setCurrentPage(int value) {
    _currentPage = value;

    if (_pageController.hasClients) {
      _pageController.animateToPage(value,
          duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }

    notifyListeners();
  }

  PageController get pageController => _pageController;
}