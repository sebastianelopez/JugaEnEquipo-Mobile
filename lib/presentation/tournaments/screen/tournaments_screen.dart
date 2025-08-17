import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/tournaments/business_logic/tournaments_provider.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournaments_table.dart';
import 'package:provider/provider.dart';

class TournamentsScreen extends StatefulWidget {
  const TournamentsScreen({super.key});

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => TournamentsProvider(),
        child: const TournamentsTable(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
