import 'package:flutter/material.dart';

class StatsTable extends StatelessWidget {
  const StatsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const <DataColumn>[
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
                'User name',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Rank',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'DPS',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Tank',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Support',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
        rows: const <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(
                Image(
                  height: 20,
                  width: 20,
                  image: AssetImage('assets/overwatchLogo.png'),
                ),
              ),
              DataCell(Text('Barry')),
              DataCell(
                Image(
                  height: 20,
                  width: 20,
                  image: AssetImage('assets/overwatchDiamond.png'),
                ),
              ),
              DataCell(
                Image(
                  height: 20,
                  width: 20,
                  image: AssetImage('assets/overwatchDiamond.png'),
                ),
              ),
              DataCell(
                Image(
                  height: 20,
                  width: 20,
                  image: AssetImage('assets/overwatchDiamond.png'),
                ),
              ),
              DataCell(
                Image(
                  height: 20,
                  width: 20,
                  image: AssetImage('assets/overwatchDiamond.png'),
                ),
              ),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(
                Image(
                  height: 20,
                  width: 20,
                  image: AssetImage('assets/cSLogo.png'),
                ),
              ),
              DataCell(Text('BarryAllen')),
              DataCell(
                Image(
                  height: 20,
                  width: 20,
                  image: AssetImage('assets/cSRank.png'),
                ),
              ),
              DataCell(
                Image(
                  height: 20,
                  width: 20,
                  image: AssetImage('assets/cSRank.png'),
                ),
              ),
              DataCell(
                Image(
                  height: 20,
                  width: 20,
                  image: AssetImage('assets/cSRank.png'),
                ),
              ),
              DataCell(
                Image(
                  height: 20,
                  width: 20,
                  image: AssetImage('assets/cSRank.png'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
