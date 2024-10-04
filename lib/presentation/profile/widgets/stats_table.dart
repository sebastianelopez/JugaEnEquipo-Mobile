import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsTable extends StatelessWidget {
  const StatsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: <DataColumn>[
          DataColumn(
            label: Expanded(
              child: Text(
                'Game',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5.h),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'User name',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5.h),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Rank',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5.h),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'DPS',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5.h),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Tank',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5.h),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Support',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5.h),
              ),
            ),
          ),
        ],
        rows: <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(
                Image(
                  height: 20.h,
                  width: 20.h,
                  image: const AssetImage('assets/overwatchLogo.png'),
                ),
              ),
              DataCell(Text(
                'Barry',
                style: TextStyle(fontSize: 13.h),
              )),
              DataCell(
                Image(
                  height: 20.h,
                  width: 20.h,
                  image: const AssetImage('assets/overwatchDiamond.png'),
                ),
              ),
              DataCell(
                Image(
                  height: 20.h,
                  width: 20.h,
                  image: const AssetImage('assets/overwatchDiamond.png'),
                ),
              ),
              DataCell(
                Image(
                  height: 20.h,
                  width: 20.h,
                  image: const AssetImage('assets/overwatchDiamond.png'),
                ),
              ),
              DataCell(
                Image(
                  height: 20.h,
                  width: 20.h,
                  image: const AssetImage('assets/overwatchDiamond.png'),
                ),
              ),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(
                Image(
                  height: 20.h,
                  width: 20.h,
                  image: const AssetImage('assets/cSLogo.png'),
                ),
              ),
              DataCell(Text('BarryAllen', style: TextStyle(fontSize: 13.h))),
              DataCell(
                Image(
                  height: 20.h,
                  width: 20.h,
                  image: const AssetImage('assets/cSRank.png'),
                ),
              ),
              DataCell(
                Image(
                  height: 20.h,
                  width: 20.h,
                  image: const AssetImage('assets/cSRank.png'),
                ),
              ),
              DataCell(
                Image(
                  height: 20.h,
                  width: 20.h,
                  image: const AssetImage('assets/cSRank.png'),
                ),
              ),
              DataCell(
                Image(
                  height: 20.h,
                  width: 20.h,
                  image: const AssetImage('assets/cSRank.png'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
