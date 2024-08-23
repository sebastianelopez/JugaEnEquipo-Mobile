import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/tournaments/business_logic/tournaments_provider.dart';
import 'package:provider/provider.dart';

class TournamentsTable extends StatelessWidget {
  const TournamentsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final tournamentsScreen = Provider.of<TournamentsProvider>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Expanded(
              child: Text(
                'Title',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Oficial',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Game',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Jugadores inscriptos',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
        rows: tournamentsScreen.tournamentsMocks.map((tournament) {
          return DataRow(
            cells: <DataCell>[
              DataCell(Text(tournament.title)),
              DataCell(tournament.isOfficial
                  ? const Icon(Icons.verified)
                  : const Text('-')),
              const DataCell(
                Image(
                  height: 20,
                  width: 20,
                  image: AssetImage('assets/overwatchLogo.png'),
                ),
              ),
              DataCell(
                  Text(tournament.registeredPlayers?.length.toString() ?? '0')),
            ],
          );
        }).toList(),
      ),
    );
  }
}
