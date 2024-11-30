import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/teams/business_logic/teams_screen_provider.dart';
import 'package:jugaenequipo/presentation/teams/widgets/teams.dart';
import 'package:provider/provider.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => TeamsScreenProvider(context: context),
        child: const Teams(),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
