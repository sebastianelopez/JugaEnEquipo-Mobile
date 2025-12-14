import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/tournament_request_model.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/accept_tournament_request_use_case.dart';
import 'package:jugaenequipo/datasources/tournaments_use_cases/decline_tournament_request_use_case.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TournamentPendingRequestsSection extends StatelessWidget {
  final List<TournamentRequestModel> requests;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRefresh;
  final VoidCallback? onRequestProcessed;

  const TournamentPendingRequestsSection({
    super.key,
    required this.requests,
    this.isLoading = false,
    this.error,
    this.onRefresh,
    this.onRequestProcessed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pendingRequests =
        requests.where((r) => r.status == 'pending').toList();

    if (isLoading) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: AppTheme.primary,
          ),
        ),
      );
    }

    if (error != null) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppTheme.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppTheme.error.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: AppTheme.error,
              size: 32.w,
            ),
            SizedBox(height: 8.h),
            Text(
              error!,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              SizedBox(height: 12.h),
              TextButton(
                onPressed: onRefresh,
                child: Text(l10n.tryAgain),
              ),
            ],
          ],
        ),
      );
    }

    if (pendingRequests.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: AppTheme.primary,
              size: 24.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                l10n.tournamentNoPendingRequests,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.warning.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.pending_actions,
                    color: AppTheme.warning,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.tournamentPendingRequests,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${pendingRequests.length} ${pendingRequests.length == 1 ? 'solicitud' : 'solicitudes'}',
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
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: AppTheme.warning.withOpacity(0.2),
          ),
          ...pendingRequests.map((request) => _buildRequestItem(
                context,
                request,
                l10n,
              )),
        ],
      ),
    );
  }

  Widget _buildRequestItem(
    BuildContext context,
    TournamentRequestModel request,
    AppLocalizations l10n,
  ) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.warning.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.teamName ??
                          'Equipo ${request.teamId.substring(0, 8)}...',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${l10n.tournamentRequestRequested}: ${dateFormat.format(request.createdAt)}',
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
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _handleDecline(context, request, l10n),
                  icon: Icon(Icons.close, size: 18.w),
                  label: Text(l10n.tournamentDeclineRequest),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.error,
                    side: BorderSide(color: AppTheme.error),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _handleAccept(context, request, l10n),
                  icon: Icon(Icons.check, size: 18.w),
                  label: Text(l10n.tournamentAcceptRequest),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleAccept(
    BuildContext context,
    TournamentRequestModel request,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.tournamentAcceptRequestTitle),
        content: Text(
          l10n.tournamentAcceptRequestMessage(
              request.teamName ?? 'este equipo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.tournamentAcceptRequest),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final result = await acceptTournamentRequest(requestId: request.id);
    final success = result['success'] as bool;
    final errorMessage = result['errorMessage'] as String?;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? l10n.tournamentRequestAccepted
                : (errorMessage ?? l10n.tournamentErrorAcceptingRequest),
          ),
          backgroundColor: success ? AppTheme.success : AppTheme.error,
          duration: Duration(seconds: success ? 2 : 4),
        ),
      );

      if (success && onRequestProcessed != null) {
        onRequestProcessed!();
      }
    }
  }

  Future<void> _handleDecline(
    BuildContext context,
    TournamentRequestModel request,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.tournamentDeclineRequestTitle),
        content: Text(
          l10n.tournamentDeclineRequestMessage(
              request.teamName ?? 'este equipo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.tournamentDeclineRequest),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await declineTournamentRequest(requestId: request.id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? l10n.tournamentRequestDeclined
                : l10n.tournamentErrorDecliningRequest,
          ),
          backgroundColor: success ? AppTheme.success : AppTheme.error,
        ),
      );

      if (success && onRequestProcessed != null) {
        onRequestProcessed!();
      }
    }
  }
}
