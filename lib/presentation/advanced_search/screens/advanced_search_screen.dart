import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_users_by_username_use_case.dart';
import 'package:jugaenequipo/datasources/teams_use_cases/search_teams_use_case.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/presentation/advanced_search/widgets/widgets.dart';

class AdvancedSearchScreen extends StatefulWidget {
  final String? initialQuery;

  const AdvancedSearchScreen({
    super.key,
    this.initialQuery,
  });

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // User filters
  String? _selectedGame;
  String? _selectedRole;
  String? _selectedRank;

  // Team filters
  String? _selectedTeamGame;
  String? _selectedTeamSize;
  bool _verifiedTeamsOnly = false;

  // Search results
  List<UserModel> _userResults = [];
  List<TeamModel> _teamResults = [];
  bool _isSearchingUsers = false;
  bool _isSearchingTeams = false;

  final List<String> _games = [
    'League of Legends',
    'Valorant',
    'CS:GO',
    'Dota 2',
    'Overwatch'
  ];
  final List<String> _roles = [
    'ADC',
    'Support',
    'Mid',
    'Top',
    'Jungle',
    'Rifler',
    'AWP',
    'Entry'
  ];
  final List<String> _ranks = [
    'Bronze',
    'Silver',
    'Gold',
    'Platinum',
    'Diamond',
    'Master',
    'Challenger'
  ];
  final List<String> _teamSizes = ['2-3', '4-5', '6+'];

  int get _activeUserFiltersCount {
    int count = 0;
    if (_selectedGame != null) count++;
    if (_selectedRole != null) count++;
    if (_selectedRank != null) count++;
    return count;
  }

  int get _activeTeamFiltersCount {
    int count = 0;
    if (_selectedTeamGame != null) count++;
    if (_selectedTeamSize != null) count++;
    if (_verifiedTeamsOnly) count++;
    return count;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Set initial query if provided
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;

      // Perform search automatically after the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performUserSearch();
        _performTeamSearch();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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
        title: Text(
          AppLocalizations.of(context)!.advancedSearchTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.advancedSearchPlayers),
            Tab(text: AppLocalizations.of(context)!.advancedSearchTeams),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0.h),
            topRight: Radius.circular(20.0.h),
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildUsersTab(),
            _buildTeamsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.0.h),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchPlayersHint,
                prefixIcon: Icon(Icons.search),
                suffixIcon: FilterIconWidget(
                  activeFiltersCount: _activeUserFiltersCount,
                  onTap: _showUserFiltersModal,
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Search button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _performUserSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0.h),
                ),
              ),
              child: _isSearchingUsers
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.advancedSearchPlayersButton,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          // Results section
          SearchResultsSection(
            isLoading: _isSearchingUsers,
            hasResults: _userResults.isNotEmpty,
            sectionTitle: AppLocalizations.of(context)!.playersSection,
            sectionIcon: Icons.person,
            resultsBuilder: () => Column(
              children: _userResults
                  .map((user) => UserResultCard(user: user))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.0.h),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchTeamsHint,
                prefixIcon: Icon(Icons.search),
                suffixIcon: FilterIconWidget(
                  activeFiltersCount: _activeTeamFiltersCount,
                  onTap: _showTeamFiltersModal,
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Search button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _performTeamSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0.h),
                ),
              ),
              child: _isSearchingTeams
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.advancedSearchTeamsButton,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          // Results section
          SearchResultsSection(
            isLoading: _isSearchingTeams,
            hasResults: _teamResults.isNotEmpty,
            sectionTitle: AppLocalizations.of(context)!.teamsSection,
            sectionIcon: Icons.group,
            resultsBuilder: () => Column(
              children: _teamResults
                  .map((team) => TeamResultCard(team: team))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserFiltersModal() {
    UserFiltersModal.show(
      context,
      games: _games,
      roles: _roles,
      ranks: _ranks,
      selectedGame: _selectedGame,
      selectedRole: _selectedRole,
      selectedRank: _selectedRank,
      onGameChanged: (value) => setState(() => _selectedGame = value),
      onRoleChanged: (value) => setState(() => _selectedRole = value),
      onRankChanged: (value) => setState(() => _selectedRank = value),
    );
  }

  void _showTeamFiltersModal() {
    TeamFiltersModal.show(
      context,
      games: _games,
      teamSizes: _teamSizes,
      selectedGame: _selectedTeamGame,
      selectedTeamSize: _selectedTeamSize,
      verifiedTeamsOnly: _verifiedTeamsOnly,
      onGameChanged: (value) => setState(() => _selectedTeamGame = value),
      onTeamSizeChanged: (value) => setState(() => _selectedTeamSize = value),
      onVerifiedChanged: (value) => setState(() => _verifiedTeamsOnly = value),
    );
  }

  Future<void> _performUserSearch() async {
    setState(() {
      _isSearchingUsers = true;
      _userResults = [];
    });

    try {
      final query = _searchController.text.trim();
      if (query.isEmpty) {
        setState(() {
          _isSearchingUsers = false;
        });
        return;
      }

      final users = await getUsersByUsername(query);
      setState(() {
        _userResults = users ?? [];
        _isSearchingUsers = false;
      });
    } catch (e) {
      setState(() {
        _isSearchingUsers = false;
        _userResults = [];
      });
    }
  }

  Future<void> _performTeamSearch() async {
    setState(() {
      _isSearchingTeams = true;
      _teamResults = [];
    });

    try {
      final query = _searchController.text.trim();

      final teams = await searchTeams(
        name: query.isNotEmpty ? query : null,
        gameId: _selectedTeamGame,
        limit: 20,
      );

      // Apply additional filters
      var filteredTeams = teams ?? [];

      if (_verifiedTeamsOnly) {
        filteredTeams =
            filteredTeams.where((team) => team.verified == true).toList();
      }

      setState(() {
        _teamResults = filteredTeams;
        _isSearchingTeams = false;
      });
    } catch (e) {
      setState(() {
        _isSearchingTeams = false;
        _teamResults = [];
      });
    }
  }
}
