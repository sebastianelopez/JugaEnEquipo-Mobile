import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/presentation/advanced_search/widgets/filter_section_widget.dart';

class TeamFiltersModal extends StatelessWidget {
  final List<String> games;
  final List<String> teamSizes;
  final String? selectedGame;
  final String? selectedTeamSize;
  final bool verifiedTeamsOnly;
  final Function(String?) onGameChanged;
  final Function(String?) onTeamSizeChanged;
  final Function(bool) onVerifiedChanged;

  const TeamFiltersModal({
    super.key,
    required this.games,
    required this.teamSizes,
    required this.selectedGame,
    required this.selectedTeamSize,
    required this.verifiedTeamsOnly,
    required this.onGameChanged,
    required this.onTeamSizeChanged,
    required this.onVerifiedChanged,
  });

  static void show(
    BuildContext context, {
    required List<String> games,
    required List<String> teamSizes,
    required String? selectedGame,
    required String? selectedTeamSize,
    required bool verifiedTeamsOnly,
    required Function(String?) onGameChanged,
    required Function(String?) onTeamSizeChanged,
    required Function(bool) onVerifiedChanged,
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
          builder: (context, scrollController) => TeamFiltersModal(
            games: games,
            teamSizes: teamSizes,
            selectedGame: selectedGame,
            selectedTeamSize: selectedTeamSize,
            verifiedTeamsOnly: verifiedTeamsOnly,
            onGameChanged: (value) {
              onGameChanged(value);
              setModalState(() {});
            },
            onTeamSizeChanged: (value) {
              onTeamSizeChanged(value);
              setModalState(() {});
            },
            onVerifiedChanged: (value) {
              onVerifiedChanged(value);
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
                    title: AppLocalizations.of(context)!.teamSizeFilter,
                    options: teamSizes,
                    selectedValue: selectedTeamSize,
                    onChanged: onTeamSizeChanged,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Checkbox(
                        value: verifiedTeamsOnly,
                        onChanged: (value) => onVerifiedChanged(value ?? false),
                        activeColor: AppTheme.primary,
                      ),
                      Text(
                        AppLocalizations.of(context)!.verifiedTeamsOnly,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
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

