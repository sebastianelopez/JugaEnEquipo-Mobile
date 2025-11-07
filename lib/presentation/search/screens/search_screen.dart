import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/profile/screens/profile_screen.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus on the search field when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24.h,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0.w),
          constraints: BoxConstraints(maxHeight: 36.0.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0.h),
            ),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4.0.h),
              hintText: AppLocalizations.of(context)!.navSearchInputLabel,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              prefixIcon: Icon(Icons.search, size: 20.0.h),
              prefixIconConstraints: BoxConstraints(
                minHeight: 28.0.h,
                minWidth: 36.0.h,
              ),
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onChanged: (value) {
              final searchProvider =
                  Provider.of<SearchProvider>(context, listen: false);
              final teamSearchProvider =
                  Provider.of<TeamSearchProvider>(context, listen: false);

              if (value.trim().isEmpty) {
                searchProvider.clearResults();
                teamSearchProvider.clearResults();
                return;
              }
              searchProvider.onQueryChanged(value);
              teamSearchProvider.onQueryChanged(value);
            },
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          children: [
            Expanded(
              child: _SearchResults(
                onUserTap: (user) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(userId: user.id),
                    ),
                  );
                },
                onTeamTap: (team) {
                  // TODO: Navigate to team profile when implemented
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '${AppLocalizations.of(context)!.teamsSection}: ${team.name}')),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0.h),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'advanced-search');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0.h),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.advancedSearchTitle,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final ValueChanged<UserModel> onUserTap;
  final ValueChanged<TeamModel> onTeamTap;

  const _SearchResults({
    required this.onUserTap,
    required this.onTeamTap,
  });

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final teamSearchProvider = context.watch<TeamSearchProvider>();

    final bool hasUsers = searchProvider.suggestions.isNotEmpty;
    final bool hasTeams = teamSearchProvider.suggestions.isNotEmpty;
    final bool isLoading =
        searchProvider.isLoading || teamSearchProvider.isLoading;

    if (!hasUsers && !hasTeams && !isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.h),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity( 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.accent.withOpacity( 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withOpacity( 0.2),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.search,
                size: 64.h,
                color: AppTheme.accent,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              AppLocalizations.of(context)!.searchUsersTeams,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppTheme.secondary.withOpacity( 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (isLoading) const LinearProgressIndicator(minHeight: 2),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16.0.h),
            children: [
              // Users Section
              if (hasUsers) ...[
                _buildSectionHeader(
                    AppLocalizations.of(context)!.playersSection, Icons.person),
                SizedBox(height: 8.h),
                ...searchProvider.suggestions
                    .map((user) => _buildUserCard(user, onUserTap)),
                SizedBox(height: 16.h),
              ],

              // Teams Section
              if (hasTeams) ...[
                _buildSectionHeader(
                    AppLocalizations.of(context)!.teamsSection, Icons.group),
                SizedBox(height: 8.h),
                ...teamSearchProvider.suggestions
                    .map((team) => _buildTeamCard(context, team, onTeamTap)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20.h, color: Colors.grey[600]),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(UserModel user, ValueChanged<UserModel> onTap) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24.h,
          backgroundImage: (user.profileImage != null &&
                  user.profileImage!.isNotEmpty &&
                  (user.profileImage!.startsWith('http://') ||
                      user.profileImage!.startsWith('https://')))
              ? NetworkImage(user.profileImage!)
              : const AssetImage('assets/user_image.jpg') as ImageProvider,
        ),
        title: Text(
          user.userName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          '${user.firstName} ${user.lastName}',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        onTap: () => onTap(user),
      ),
    );
  }

  Widget _buildTeamCard(
      BuildContext context, TeamModel team, ValueChanged<TeamModel> onTap) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24.h,
          backgroundColor: Colors.blue[100],
          child: Icon(
            Icons.group,
            color: Colors.blue[700],
            size: 24.h,
          ),
        ),
        title: Text(
          team.name,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              team.games.isNotEmpty ? team.games.first.name : 'No games',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            Row(
              children: [
                Icon(
                  team.verified ? Icons.verified : Icons.pending,
                  size: 16.h,
                  color: team.verified ? Colors.green : Colors.orange,
                ),
                SizedBox(width: 8.w),
                Text(
                  team.verified
                      ? AppLocalizations.of(context)!.verifiedStatus
                      : AppLocalizations.of(context)!.pendingStatus,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: team.verified ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => onTap(team),
      ),
    );
  }
}
