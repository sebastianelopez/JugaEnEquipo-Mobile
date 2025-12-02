import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/presentation/advanced_search/widgets/filter_section_widget.dart';

class UserFiltersModal extends StatelessWidget {
  final List<String> games;
  final List<String> roles;
  final List<String> ranks;
  final String? selectedGame;
  final String? selectedRole;
  final String? selectedRank;
  final Function(String?) onGameChanged;
  final Function(String?) onRoleChanged;
  final Function(String?) onRankChanged;

  const UserFiltersModal({
    super.key,
    required this.games,
    required this.roles,
    required this.ranks,
    required this.selectedGame,
    required this.selectedRole,
    required this.selectedRank,
    required this.onGameChanged,
    required this.onRoleChanged,
    required this.onRankChanged,
  });

  static void show(
    BuildContext context, {
    required List<String> games,
    required List<String> roles,
    required List<String> ranks,
    required String? selectedGame,
    required String? selectedRole,
    required String? selectedRank,
    required Function(String?) onGameChanged,
    required Function(String?) onRoleChanged,
    required Function(String?) onRankChanged,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => UserFiltersModal(
            games: games,
            roles: roles,
            ranks: ranks,
            selectedGame: selectedGame,
            selectedRole: selectedRole,
            selectedRank: selectedRank,
            onGameChanged: (value) {
              onGameChanged(value);
              setModalState(() {});
            },
            onRoleChanged: (value) {
              onRoleChanged(value);
              setModalState(() {});
            },
            onRankChanged: (value) {
              onRankChanged(value);
              setModalState(() {});
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtros de Búsqueda',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterSectionWidget(
                    title: AppLocalizations.of(context)!.advancedSearchGame,
                    options: games,
                    selectedValue: selectedGame,
                    onChanged: onGameChanged,
                  ),
                  SizedBox(height: 16.h),
                  FilterSectionWidget(
                    title: AppLocalizations.of(context)!.advancedSearchRole,
                    options: roles,
                    selectedValue: selectedRole,
                    onChanged: onRoleChanged,
                  ),
                  SizedBox(height: 16.h),
                  FilterSectionWidget(
                    title: AppLocalizations.of(context)!.advancedSearchRanking,
                    options: ranks,
                    selectedValue: selectedRank,
                    onChanged: onRankChanged,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

