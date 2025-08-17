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

  void onPageChanged(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void resetToTab(int tab) {
    _currentPage = tab;
    if (_pageController.hasClients) {
      _pageController.jumpToPage(tab);
    }
    notifyListeners();
  }

  PageController get pageController => _pageController;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
