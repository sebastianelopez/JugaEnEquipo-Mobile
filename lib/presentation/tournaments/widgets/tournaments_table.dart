import 'package:flutter/material.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/tournaments/business_logic/tournaments_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';

class TournamentsTable extends StatelessWidget {
  const TournamentsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final tournamentsScreen = Provider.of<TournamentsProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: <DataColumn>[
          DataColumn(
            label: Expanded(
              child: Text(
                l10n.tournamentTitleColumn,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                l10n.officialColumn,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                l10n.gameColumn,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                l10n.registeredPlayersColumn,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
        rows: tournamentsScreen.tournamentsMocks.map((tournament) {
          return DataRow(
            cells: <DataCell>[
              DataCell(Text(tournament.title)),
              DataCell(tournament.isOfficial
                  ? Icon(Icons.verified, color: AppTheme.primary)
                  : const Text('-')),
              DataCell(
                tournament.game.image.isNotEmpty
                    ? Image(
                        height: 20,
                        width: 20,
                        image: AssetImage(tournament.game.image),
                        errorBuilder: (context, error, stackTrace) {
                          return Text(tournament.game.name);
                        },
                      )
                    : Text(tournament.game.name),
              ),
              DataCell(
                Text(tournament.registeredPlayersIds?.length.toString() ?? '0'),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
