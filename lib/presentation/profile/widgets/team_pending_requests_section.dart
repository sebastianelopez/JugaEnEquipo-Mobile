import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/accept_team_request_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/decline_team_request_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_user_use_case.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TeamPendingRequestsSection extends StatefulWidget {
  final List<TeamRequestModel> requests;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRefresh;
  final VoidCallback? onRequestProcessed;

  const TeamPendingRequestsSection({
    super.key,
    required this.requests,
    this.isLoading = false,
    this.error,
    this.onRefresh,
    this.onRequestProcessed,
  });

  @override
  State<TeamPendingRequestsSection> createState() =>
      _TeamPendingRequestsSectionState();
}

class _TeamPendingRequestsSectionState
    extends State<TeamPendingRequestsSection> {
  final Map<String, UserModel> _loadedUsers = {};

  @override
  void initState() {
    super.initState();
    _loadMissingUsers();
  }

  @override
  void didUpdateWidget(TeamPendingRequestsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.requests != widget.requests) {
      _loadMissingUsers();
    }
  }

  Future<void> _loadMissingUsers() async {
    for (final request in widget.requests) {
      if (request.user == null && !_loadedUsers.containsKey(request.userId)) {
        final user = await getUserById(request.userId);
        if (user != null && mounted) {
          setState(() {
            _loadedUsers[request.userId] = user;
          });
        }
      }
    }
  }

  UserModel? _getUser(TeamRequestModel request) {
    return request.user ?? _loadedUsers[request.userId];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pendingRequests =
        widget.requests.where((r) => r.status == 'pending').toList();

    if (widget.isLoading) {
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

    if (widget.error != null) {
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
              widget.error!,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.onRefresh != null) ...[
              SizedBox(height: 12.h),
              TextButton(
                onPressed: widget.onRefresh,
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
                l10n.teamNoPendingRequests,
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
                        l10n.teamPendingRequests,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${pendingRequests.length} ${pendingRequests.length == 1 ? l10n.teamRequestSingular : l10n.teamRequestPlural}',
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
          ...pendingRequests
              .map((request) => _buildRequestItem(
                    context,
                    request,
                    l10n,
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildRequestItem(
    BuildContext context,
    TeamRequestModel request,
    AppLocalizations l10n,
  ) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final user = _getUser(request);
    final dateToShow = request.createdAt;

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
              CircleAvatar(
                radius: 20.h,
                backgroundImage: user?.profileImage != null
                    ? (user!.profileImage!.startsWith('http://') ||
                            user.profileImage!.startsWith('https://')
                        ? NetworkImage(user.profileImage!)
                        : AssetImage(user.profileImage!) as ImageProvider)
                    : const AssetImage('assets/user_image.jpg'),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user != null
                          ? '${user.firstName} ${user.lastName}'
                          : request.userNickname ??
                              'Usuario ${request.userId.substring(0, 8)}...',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      user != null
                          ? '@${user.userName}'
                          : request.userNickname != null
                              ? '@${request.userNickname}'
                              : request.userId.substring(0, 8),
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
          SizedBox(height: 8.h),
          Text(
            '${l10n.teamRequestRequested}: ${dateFormat.format(dateToShow)}',
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _handleDecline(context, request, l10n),
                  icon: Icon(Icons.close, size: 18.w),
                  label: Text(l10n.teamDeclineRequest),
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
                  label: Text(l10n.teamAcceptRequest),
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
    TeamRequestModel request,
    AppLocalizations l10n,
  ) async {
    final userName = _getUser(request) != null
        ? '${_getUser(request)!.firstName} ${_getUser(request)!.lastName}'
        : request.userNickname ?? 'este usuario';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.teamAcceptRequestTitle),
        content: Text(l10n.teamAcceptRequestMessage(userName)),
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
            child: Text(l10n.teamAcceptRequest),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final result = await acceptTeamRequest(request.id);
    final success = result == Result.success;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? l10n.teamRequestAcceptedSuccess
                : l10n.teamErrorAcceptingRequest,
          ),
          backgroundColor: success ? AppTheme.success : AppTheme.error,
        ),
      );

      if (success && widget.onRequestProcessed != null) {
        widget.onRequestProcessed!();
      }
    }
  }

  Future<void> _handleDecline(
    BuildContext context,
    TeamRequestModel request,
    AppLocalizations l10n,
  ) async {
    final userName = _getUser(request) != null
        ? '${_getUser(request)!.firstName} ${_getUser(request)!.lastName}'
        : request.userNickname ?? 'este usuario';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.teamDeclineRequestTitle),
        content: Text(l10n.teamDeclineRequestMessage(userName)),
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
            child: Text(l10n.teamDeclineRequest),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final result = await declineTeamRequest(request.id);
    final success = result == Result.success;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? l10n.teamRequestDeclinedSuccess
                : l10n.teamErrorDecliningRequest,
          ),
          backgroundColor: success ? AppTheme.success : AppTheme.error,
        ),
      );

      if (success && widget.onRequestProcessed != null) {
        widget.onRequestProcessed!();
      }
    }
  }
}
