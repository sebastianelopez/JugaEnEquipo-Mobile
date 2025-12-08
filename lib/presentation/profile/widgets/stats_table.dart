import 'package:flutter/material.dart';

class StatsTable extends StatelessWidget {
  const StatsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Column(
          children: [
            Text('Stats'),
          ],
        ),
      ),
    );
  }
}
