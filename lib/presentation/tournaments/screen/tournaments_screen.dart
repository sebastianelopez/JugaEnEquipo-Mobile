import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/tournaments/business_logic/tournaments_provider.dart';
import 'package:jugaenequipo/presentation/tournaments/widgets/tournaments_table.dart';
import 'package:jugaenequipo/presentation/tournaments/screen/tournament_form_screen.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/utils/utils.dart';
import 'package:provider/provider.dart';

class TournamentsScreen extends StatefulWidget {
  const TournamentsScreen({super.key});

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey _fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => TournamentsProvider(),
        child: const TournamentsTable(),
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () async {
          final RenderBox? renderBox =
              _fabKey.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final position = renderBox.localToGlobal(Offset.zero);
            final size = renderBox.size;

            final fabCenter = Offset(
              position.dx + size.width / 2,
              position.dy + size.height / 2,
            );

            final result = await Navigator.push(
              context,
              NavigationUtils.scaleFromPosition(
                const TournamentFormScreen(),
                startPosition: fabCenter,
                duration: 800,
                curve: Curves.easeOutExpo,
              ),
            );
            if (result == true) {
              setState(() {});
            }
          }
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
