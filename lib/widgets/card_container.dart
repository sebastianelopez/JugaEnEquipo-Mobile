import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final BoxShadow? boxShadow;

  const CardContainer(
      {Key? key, required this.child, this.backgroundColor, this.boxShadow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: _createCardShape(backgroundColor),
        child: child,
      ),
    );
  }

  BoxDecoration _createCardShape(Color? backgroundColor) => BoxDecoration(
      color: backgroundColor ?? Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: boxShadow != null ? [boxShadow!] : null);
}
