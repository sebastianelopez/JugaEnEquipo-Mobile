import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/tournament_model.dart';
import 'package:jugaenequipo/datasources/models/user_model.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_users_by_username_use_case.dart';
import 'package:jugaenequipo/presentation/tournaments/business_logic/tournament_management_provider.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/utils/game_image_helper.dart';
import 'package:provider/provider.dart';

class TournamentFormScreen extends StatefulWidget {
  final TournamentModel? tournament;

  const TournamentFormScreen({
    super.key,
    this.tournament,
  });

  @override
  State<TournamentFormScreen> createState() => _TournamentFormScreenState();
}

class _TournamentFormScreenState extends State<TournamentFormScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _sectionAnimations;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _sectionAnimations = List.generate(5, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.5 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedSection({
    required int index,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: _sectionAnimations[index],
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _sectionAnimations[index].value)),
          child: Opacity(
            opacity: _sectionAnimations[index].value,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          TournamentManagementProvider(tournament: widget.tournament),
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
                  _buildAnimatedSection(
                    index: 0,
                    child: _buildBasicInfoSection(context, provider, l10n),
                  ),
                  SizedBox(height: 24.h),
                  _buildAnimatedSection(
                    index: 1,
                    child: _buildGameAndTypeSection(context, provider, l10n),
                  ),
                  SizedBox(height: 24.h),
                  _buildAnimatedSection(
                    index: 2,
                    child: _buildDateSection(context, provider, l10n),
                  ),
                  SizedBox(height: 24.h),
                  _buildAnimatedSection(
                    index: 3,
                    child: _buildSettingsSection(context, provider, l10n),
                  ),
                  SizedBox(height: 24.h),
                  _buildAnimatedSection(
                    index: 4,
                    child: _buildActionButtons(context, provider, l10n),
                  ),
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
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
              color: Theme.of(context).colorScheme.onSurface,
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
          SizedBox(height: 16.h),
          _buildRulesEditor(context, provider, l10n),
          SizedBox(height: 16.h),
          _buildImageSelector(context, provider, l10n),
        ],
      ),
    );
  }

  Widget _buildImageSelector(
    BuildContext context,
    TournamentManagementProvider provider,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tournamentFormImage,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        if (provider.selectedImage != null || provider.selectedImageUrl != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: provider.selectedImage != null
                    ? Image.file(
                        File(provider.selectedImage!.path),
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        provider.selectedImageUrl!,
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200.h,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            child: const Icon(Icons.error),
                          );
                        },
                      ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.7)
                          : Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20.w,
                    ),
                  ),
                  onPressed: () {
                    provider.clearImage();
                  },
                ),
              ),
            ],
          )
        else
          InkWell(
            onTap: () => provider.selectImage(),
            child: Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 48.w,
                    color: AppTheme.primary,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    l10n.tournamentFormSelectImage,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    l10n.optional,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGameAndTypeSection(BuildContext context,
      TournamentManagementProvider provider, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
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
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          _buildGameSelector(context, provider, l10n),
          if (provider.selectedGameId != null) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Flexible(
                  child: _buildRankSelector(
                    context,
                    provider,
                    l10n,
                    isMinRank: true,
                  ),
                ),
                SizedBox(width: 12.w),
                Flexible(
                  child: _buildRankSelector(
                    context,
                    provider,
                    l10n,
                    isMinRank: false,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 16.h),
          _buildTextField(
            controller: provider.regionController,
            label: l10n.tournamentFormRegion,
            hint: l10n.tournamentFormRegionHint,
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(BuildContext context,
      TournamentManagementProvider provider, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
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
              color: Theme.of(context).colorScheme.onSurface,
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
          _buildResponsibleSelector(context, provider, l10n),
        ],
      ),
    );
  }

  Widget _buildResponsibleSelector(BuildContext context,
      TournamentManagementProvider provider, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tournamentResponsible,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        if (provider.selectedResponsible != null)
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.w,
                  backgroundImage:
                      provider.selectedResponsible!.profileImage != null
                          ? NetworkImage(
                              provider.selectedResponsible!.profileImage!)
                          : null,
                  child: provider.selectedResponsible!.profileImage == null
                      ? Icon(Icons.person, size: 20.w)
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${provider.selectedResponsible!.firstName} ${provider.selectedResponsible!.lastName}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '@${provider.selectedResponsible!.userName}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 20.w),
                  onPressed: () {
                    provider.clearResponsible();
                  },
                ),
              ],
            ),
          )
        else
          ElevatedButton.icon(
            onPressed: () async {
              final selectedUser = await _showUserSearchDialog(context);
              if (selectedUser != null) {
                provider.setResponsible(selectedUser);
              }
            },
            icon: Icon(Icons.person_search, size: 20.w),
            label: Text(l10n.tournamentFormSearchResponsible),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        if (provider.responsibleError != null) ...[
          SizedBox(height: 8.h),
          Text(
            provider.responsibleError!,
            style: TextStyle(
              color: AppTheme.error,
              fontSize: 12.sp,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context,
      TournamentManagementProvider provider, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
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
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          _buildMaxTeamsSelector(context, provider, l10n),
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
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        AnimatedFormField(
          controller: controller,
          hintText: hint,
          keyboardType: keyboardType ?? TextInputType.text,
          textColor: Theme.of(context).colorScheme.onSurface,
          hintTextColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          errorText: error,
          onChanged: onChanged,
          validator: error != null ? (value) => error : null,
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
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: provider.gameError != null
                  ? AppTheme.error
                  : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: provider.selectedGameId != null &&
                    provider.availableGames
                        .any((game) => game.id == provider.selectedGameId)
                ? provider.selectedGameId
                : null,
            dropdownColor: Theme.of(context).colorScheme.surface,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
            hint: Text(
              l10n.tournamentFormSelectGame,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
            items: provider.availableGames.map((game) {
              return DropdownMenuItem(
                value: game.id,
                child: Row(
                  children: [
                    GameImageHelper.buildGameImage(
                      gameName: game.name,
                      width: 24.w,
                      height: 24.w,
                      defaultIcon: Icons.sports_esports,
                      defaultIconColor: AppTheme.accent,
                      defaultIconSize: 24.w,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      game.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
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

  Widget _buildMaxTeamsSelector(BuildContext context,
      TournamentManagementProvider provider, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tournamentFormMaxTeams,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<int>(
            value: provider.maxTeams,
            dropdownColor: Theme.of(context).colorScheme.surface,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
            hint: Text(
              l10n.tournamentFormSelectMaxTeams,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
            items: provider.getAvailableTeamSizes().map((size) {
              return DropdownMenuItem(
                value: size,
                child: Text(
                  '$size equipos',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                provider.setMaxTeams(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRankSelector(
    BuildContext context,
    TournamentManagementProvider provider,
    AppLocalizations l10n, {
    required bool isMinRank,
  }) {
    final selectedValue =
        isMinRank ? provider.selectedMinRankId : provider.selectedMaxRankId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isMinRank ? l10n.tournamentFormMinRank : l10n.tournamentFormMaxRank,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: provider.isLoadingRanks
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center(
                    child: SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : DropdownButtonFormField<String>(
                  value: selectedValue != null &&
                          provider.availableRanks
                              .any((rank) => rank.id == selectedValue)
                      ? selectedValue
                      : null,
                  isExpanded: true,
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    isDense: true,
                  ),
                  hint: Text(
                    l10n.optional,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                      fontSize: 14.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  items: provider.availableRanks.map((rank) {
                    return DropdownMenuItem(
                      value: rank.id,
                      child: Text(
                        rank.rankName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (isMinRank) {
                      provider.setMinRank(value);
                    } else {
                      provider.setMaxRank(value);
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
    final isEditing = provider.isEditing;
    final now = DateTime.now();
    final initialDate = date ?? now.add(const Duration(days: 1));

    // When editing, allow past dates if the tournament already has a past date
    // When creating, only allow future dates
    final firstDate = isEditing && date != null && date.isBefore(now)
        ? date.subtract(
            const Duration(days: 365)) // Allow 1 year before the existing date
        : now; // For new tournaments, only allow future dates

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: firstDate,
              lastDate: now.add(const Duration(days: 365)),
            );
            if (selectedDate != null) {
              onDateSelected(selectedDate);
              provider.validateDates(l10n);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
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
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
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

  Future<void> _handleSubmit(
      BuildContext context, TournamentManagementProvider provider) async {
    final l10n = AppLocalizations.of(context)!;

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

    debugPrint(
        'FORM: About to ${provider.isEditing ? "update" : "create"} tournament');
    final success = provider.isEditing
        ? await provider.updateTournament()
        : await provider.createTournament();

    debugPrint('FORM: Operation result: $success');

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

  Future<void> _showDeleteConfirmation(BuildContext context,
      TournamentManagementProvider provider, AppLocalizations l10n) async {
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

  Widget _buildRulesEditor(
    BuildContext context,
    TournamentManagementProvider provider,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tournamentFormRules,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        // Formatting toolbar
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Wrap(
            spacing: 8.w,
            children: [
              _buildFormatButton(
                icon: Icons.format_list_bulleted,
                tooltip: l10n.tournamentFormRulesList,
                onPressed: () =>
                    _insertFormat(provider.rulesController, '- ', ''),
              ),
              _buildFormatButton(
                icon: Icons.format_list_numbered,
                tooltip: l10n.tournamentFormRulesNumberedList,
                onPressed: () =>
                    _insertFormat(provider.rulesController, '1. ', ''),
              ),
              _buildFormatButton(
                icon: Icons.format_bold,
                tooltip: l10n.tournamentFormRulesBold,
                onPressed: () =>
                    _insertFormat(provider.rulesController, '**', '**'),
              ),
              _buildFormatButton(
                icon: Icons.format_italic,
                tooltip: l10n.tournamentFormRulesItalic,
                onPressed: () =>
                    _insertFormat(provider.rulesController, '*', '*'),
              ),
              _buildFormatButton(
                icon: Icons.title,
                tooltip: l10n.tournamentFormRulesTitle,
                onPressed: () =>
                    _insertFormat(provider.rulesController, '# ', ''),
              ),
            ],
          ),
        ),
        // Text field
        TextField(
          controller: provider.rulesController,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: l10n.tournamentFormRulesHint,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              borderSide: BorderSide(color: AppTheme.primary),
            ),
            contentPadding: EdgeInsets.all(16.w),
          ),
          style: TextStyle(
            fontSize: 14.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          l10n.tournamentFormRulesHelp,
          style: TextStyle(
            fontSize: 11.sp,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildFormatButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Icon(
            icon,
            size: 20.w,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  void _insertFormat(
      TextEditingController controller, String prefix, String suffix) {
    final text = controller.text;
    final selection = controller.selection;

    if (selection.baseOffset == -1) {
      // No selection, insert at end
      controller.text = text + prefix + suffix;
      controller.selection = TextSelection.collapsed(
        offset: text.length + prefix.length,
      );
    } else {
      // Insert around selection
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        prefix + selection.textInside(text) + suffix,
      );
      controller.text = newText;
      controller.selection = TextSelection.collapsed(
        offset:
            selection.start + prefix.length + selection.textInside(text).length,
      );
    }
  }

  Future<UserModel?> _showUserSearchDialog(BuildContext context) async {
    return showDialog<UserModel>(
      context: context,
      builder: (context) => _UserSearchDialog(),
    );
  }
}

class _UserSearchDialog extends StatefulWidget {
  @override
  State<_UserSearchDialog> createState() => _UserSearchDialogState();
}

class _UserSearchDialogState extends State<_UserSearchDialog> {
  final searchController = TextEditingController();
  List<UserModel>? searchResults;
  bool isSearching = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String value) async {
    if (value.length < 3) {
      setState(() {
        searchResults = null;
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    try {
      final results = await getUsersByUsername(value, limit: 10);
      if (mounted) {
        setState(() {
          searchResults = results;
          isSearching = false;
        });
      }
    } catch (e) {
      debugPrint('Error searching users: $e');
      if (mounted) {
        setState(() {
          searchResults = [];
          isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: 400.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.tournamentFormSearchResponsibleTitle,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Search field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: l10n.username,
                  hintText: l10n.tournamentFormSearchUsernameHint,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: _performSearch,
              ),
            ),
            SizedBox(height: 16.h),
            // Results area - scrollable
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: _buildResultsContent(context, l10n),
                ),
              ),
            ),
            // Actions
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsContent(BuildContext context, AppLocalizations l10n) {
    if (isSearching) {
      return Padding(
        padding: EdgeInsets.all(16.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    } else if (searchResults != null && searchResults!.isNotEmpty) {
      return Column(
        children: searchResults!.map((user) {
          return ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 0.w, vertical: 4.h),
            leading: CircleAvatar(
              backgroundImage: user.profileImage != null
                  ? NetworkImage(user.profileImage!)
                  : null,
              child:
                  user.profileImage == null ? const Icon(Icons.person) : null,
            ),
            title: Text(
              '${user.firstName} ${user.lastName}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text('@${user.userName}'),
            onTap: () {
              Navigator.pop(context, user);
            },
          );
        }).toList(),
      );
    } else if (searchResults != null && searchResults!.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.h),
        child: Text(
          l10n.tournamentFormNoUsersFound,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(16.h),
        child: Text(
          l10n.tournamentFormSearchMinChars,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      );
    }
  }
}
