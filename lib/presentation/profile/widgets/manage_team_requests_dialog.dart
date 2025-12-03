import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/profile/business_logic/team_profile_provider.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class ManageTeamRequestsDialog extends StatelessWidget {
  final List<TeamRequestModel> requests;
  final TeamProfileProvider provider;

  const ManageTeamRequestsDialog({
    super.key,
    required this.requests,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.person_add, color: Colors.white, size: 24.h),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Team Requests',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Flexible(
              child: requests.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox,
                                size: 64.h, color: Colors.grey[400]),
                            SizedBox(height: 16.h),
                            Text(
                              'No pending requests',
                              style: TextStyle(
                                fontSize: 16.h,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(16.w),
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        final user = request.user;

                        if (user == null) {
                          return const SizedBox.shrink();
                        }

                        return Card(
                          margin: EdgeInsets.only(bottom: 12.h),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 24.h,
                              backgroundImage: user.profileImage != null
                                  ? (user.profileImage!.startsWith('http://') ||
                                          user.profileImage!
                                              .startsWith('https://')
                                      ? NetworkImage(user.profileImage!)
                                      : AssetImage(user.profileImage!)
                                          as ImageProvider)
                                  : const AssetImage('assets/user_image.jpg'),
                            ),
                            title: Text(
                              '${user.firstName} ${user.lastName}',
                              style: TextStyle(
                                fontSize: 16.h,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('@${user.userName}'),
                                SizedBox(height: 4.h),
                                Text(
                                  'Requested ${_formatDate(request.createdAt)}',
                                  style: TextStyle(
                                    fontSize: 12.h,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check_circle,
                                      color: Colors.green, size: 28.h),
                                  onPressed: provider.isPerformingAction
                                      ? null
                                      : () async {
                                          final success = await provider
                                              .acceptRequest(request.id);
                                          if (context.mounted) {
                                            if (success) {
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text('Request accepted')),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text('Error accepting request')),
                                              );
                                            }
                                          }
                                        },
                                ),
                                SizedBox(width: 8.w),
                                IconButton(
                                  icon: Icon(Icons.cancel,
                                      color: Colors.red, size: 28.h),
                                  onPressed: provider.isPerformingAction
                                      ? null
                                      : () async {
                                          final success = await provider
                                              .declineRequest(request.id);
                                          if (context.mounted) {
                                            if (success) {
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text('Request declined')),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text('Error declining request')),
                                              );
                                            }
                                          }
                                        },
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    userId: user.id,
                                    profileType: ProfileType.user,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

