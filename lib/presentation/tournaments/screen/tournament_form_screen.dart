import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/tournament_model.dart';
import 'package:jugaenequipo/presentation/tournaments/business_logic/tournament_management_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TournamentFormScreen extends StatelessWidget {
  final TournamentModel? tournament;

  const TournamentFormScreen({
    super.key,
    this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TournamentManagementProvider(tournament: tournament),
      child: Consumer<TournamentManagementProvider>(
        builder: (context, provider, child) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              title: Text(provider.getPageTitle(l10n)),
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              actions: [
                if (provider.isEditing)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                                             if (value == 'delete') {
                         _showDeleteConfirmation(context, provider, l10n);
                       }
                    },
                    itemBuilder: (context) => [
                                             PopupMenuItem(
                         value: 'delete',
                         child: Row(
                           children: [
                             Icon(Icons.delete, color: Colors.red),
                             SizedBox(width: 8),
                             Text(l10n.tournamentFormDeleteTitle),
                           ],
                         ),
                       ),
                    ],
                  ),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfoSection(context, provider, l10n),
                  SizedBox(height: 24.h),
                  _buildGameAndTypeSection(context, provider, l10n),
                  SizedBox(height: 24.h),
                  _buildDateSection(context, provider, l10n),
                  SizedBox(height: 24.h),
                  _buildSettingsSection(context, provider, l10n),
                  SizedBox(height: 24.h),
                  _buildActionButtons(context, provider, l10n),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBasicInfoSection(BuildContext context,
      TournamentManagementProvider provider, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tournamentFormTitle,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.secondary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildTextField(
            controller: provider.titleController,
            label: l10n.tournamentFormTitle,
            hint: l10n.tournamentFormTitleHint,
            error: provider.titleError,
            onChanged: (_) => provider.validateTitle(l10n),
          ),
          SizedBox(height: 16.h),
          _buildTextField(
            controller: provider.descriptionController,
            label: l10n.tournamentFormDescription,
            hint: l10n.tournamentFormDescriptionHint,
            error: provider.descriptionError,
            maxLines: 4,
            onChanged: (_) => provider.validateDescription(l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildGameAndTypeSection(BuildContext context,
      TournamentManagementProvider provider, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tournamentFormType,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.secondary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildGameSelector(context, provider, l10n),
          SizedBox(height: 16.h),
          _buildTournamentTypeSelector(context, provider, l10n),
        ],
      ),
    );
  }

  Widget _buildDateSection(BuildContext context,
      TournamentManagementProvider provider, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tournamentFormDates,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.secondary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  context: context,
                  label: l10n.tournamentFormStartDate,
                  date: provider.startDate,
                  onDateSelected: provider.setStartDate,
                  l10n: l10n,
                  provider: provider,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildDateField(
                  context: context,
                  label: l10n.tournamentFormEndDate,
                  date: provider.endDate,
                  onDateSelected: provider.setEndDate,
                  l10n: l10n,
                  provider: provider,
                ),
              ),
            ],
          ),
          if (provider.dateError != null) ...[
            SizedBox(height: 8.h),
            Text(
              provider.dateError!,
              style: TextStyle(
                color: AppTheme.error,
                fontSize: 12.sp,
              ),
            ),
          ],
          SizedBox(height: 16.h),
          _buildRegistrationDeadlineSelector(context, provider, l10n),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
      BuildContext context, TournamentManagementProvider provider, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tournamentFormConfiguration,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.secondary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildSwitchTile(
            title: l10n.tournamentFormOfficial,
            subtitle: l10n.tournamentFormOfficialSubtitle,
            value: provider.isOfficial,
            onChanged: provider.setOfficial,
            icon: Icons.verified,
            iconColor: AppTheme.primary,
          ),
          _buildSwitchTile(
            title: l10n.tournamentFormPrivate,
            subtitle: l10n.tournamentFormPrivateSubtitle,
            value: provider.isPrivate,
            onChanged: provider.setPrivate,
            icon: Icons.lock,
            iconColor: AppTheme.secondary,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                                 child: _buildTextField(
                   controller: provider.maxParticipantsController,
                   label: l10n.tournamentFormMaxParticipants,
                   hint: '32',
                   keyboardType: TextInputType.number,
                 ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                                 child: _buildTextField(
                   controller: provider.prizePoolController,
                   label: l10n.tournamentFormPrizePool,
                   hint: '1000',
                   keyboardType: TextInputType.number,
                 ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context,
      TournamentManagementProvider provider, AppLocalizations l10n) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: provider.isFormValid &&
                    !provider.isCreating &&
                    !provider.isUpdating
                ? () => _handleSubmit(context, provider)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
            ),
            child: provider.isCreating || provider.isUpdating
                ? SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    provider.getActionButtonText(l10n),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        if (provider.isEditing) ...[
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.secondary,
                side: BorderSide(color: AppTheme.secondary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
                             child: Text(
                 l10n.tournamentFormCancelButton,
                 style: TextStyle(
                   fontSize: 16.sp,
                   fontWeight: FontWeight.w600,
                 ),
               ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? error,
    int maxLines = 1,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.secondary,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.withValues(alpha: 0.6),
              fontSize: 14.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error != null
                    ? AppTheme.error
                    : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.error,
              ),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
        ),
        if (error != null) ...[
          SizedBox(height: 8.h),
          Text(
            error,
            style: TextStyle(
              color: AppTheme.error,
              fontSize: 12.sp,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGameSelector(BuildContext context,
      TournamentManagementProvider provider, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tournamentFormGame,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.secondary,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: provider.gameError != null
                  ? AppTheme.error
                  : Colors.grey.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: provider.selectedGameId,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
                         hint: Text(
               l10n.tournamentFormSelectGame,
               style: TextStyle(
                 color: Colors.grey.withValues(alpha: 0.6),
                 fontSize: 14.sp,
               ),
             ),
            items: provider.availableGames.map((game) {
              return DropdownMenuItem(
                value: game.id,
                child: Row(
                  children: [
                    if (game.image.isNotEmpty)
                      Image.asset(
                        game.image,
                        width: 24.w,
                        height: 24.w,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.sports_esports,
                          size: 24.w,
                          color: AppTheme.accent,
                        ),
                      ),
                    SizedBox(width: 12.w),
                    Text(
                      game.name,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                provider.setGame(value);
                provider.validateGame(l10n);
              }
            },
          ),
        ),
        if (provider.gameError != null) ...[
          SizedBox(height: 8.h),
          Text(
            provider.gameError!,
            style: TextStyle(
              color: AppTheme.error,
              fontSize: 12.sp,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTournamentTypeSelector(BuildContext context,
      TournamentManagementProvider provider, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tournamentFormType,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.secondary,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: provider.tournamentType,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
            items: provider.getTournamentTypes(l10n).map((type) {
              return DropdownMenuItem(
                value: type['value'],
                child: Text(
                  type['label']!,
                  style: TextStyle(fontSize: 14.sp),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                provider.setTournamentType(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required Function(DateTime) onDateSelected,
    required AppLocalizations l10n,
    required TournamentManagementProvider provider,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.secondary,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (selectedDate != null) {
              onDateSelected(selectedDate);
              provider.validateDates(l10n);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18.w,
                  color: AppTheme.primary,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    date != null
                        ? '${date.day}/${date.month}/${date.year}'
                        : l10n.tournamentFormSelectDate,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: date != null
                          ? AppTheme.secondary
                          : Colors.grey.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationDeadlineSelector(BuildContext context,
      TournamentManagementProvider provider, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tournamentFormRegistrationDeadline,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.secondary,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: provider.registrationDeadline,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
            items: provider.getRegistrationDeadlines(l10n).map((deadline) {
              return DropdownMenuItem(
                value: deadline['value'],
                child: Text(
                  deadline['label']!,
                  style: TextStyle(fontSize: 14.sp),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                provider.setRegistrationDeadline(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? iconColor.withValues(alpha: 0.3) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.secondary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: iconColor,
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit(
      BuildContext context, TournamentManagementProvider provider) async {
    final l10n = AppLocalizations.of(context)!;

    // Validate all fields before submitting
    provider.validateForm(l10n);

    if (!provider.isFormValid) {
             ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(l10n.tournamentFormPleaseFixErrors),
           backgroundColor: AppTheme.error,
         ),
       );
      return;
    }

    final success = provider.isEditing
        ? await provider.updateTournament()
        : await provider.createTournament();

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
           content: Text(
             provider.isEditing
                 ? l10n.tournamentFormSuccessUpdate
                 : l10n.tournamentFormSuccessCreate,
           ),
           backgroundColor: AppTheme.success,
         ),
      );
      Navigator.pop(context, true);
    } else if (context.mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(
             provider.isEditing
                 ? l10n.tournamentFormErrorUpdate
                 : l10n.tournamentFormErrorCreate,
           ),
           backgroundColor: AppTheme.error,
         ),
       );
    }
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, TournamentManagementProvider provider, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
             builder: (context) => AlertDialog(
         title: Text(l10n.tournamentFormDeleteTitle),
         content: Text(l10n.tournamentFormDeleteMessage),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context, false),
             child: Text(l10n.tournamentFormDeleteCancel),
           ),
           TextButton(
             onPressed: () => Navigator.pop(context, true),
             style: TextButton.styleFrom(foregroundColor: AppTheme.error),
             child: Text(l10n.tournamentFormDeleteConfirm),
           ),
         ],
       ),
    );

    if (confirmed == true && context.mounted) {
      final success = await provider.deleteTournament();
      if (success && context.mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text(l10n.tournamentFormSuccessDelete),
             backgroundColor: AppTheme.success,
           ),
         );
        Navigator.pop(context, true);
      } else if (context.mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text(l10n.tournamentFormErrorDelete),
             backgroundColor: AppTheme.error,
           ),
         );
      }
    }
  }
}
