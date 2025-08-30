import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Game filter
          _buildFilterSection(AppLocalizations.of(context)!.advancedSearchGame,
              _games, _selectedGame, (value) {
            setState(() {
              _selectedGame = value;
            });
          }),

          SizedBox(height: 16.h),

          // Role filter
          _buildFilterSection(AppLocalizations.of(context)!.advancedSearchRole,
              _roles, _selectedRole, (value) {
            setState(() {
              _selectedRole = value;
            });
          }),

          SizedBox(height: 16.h),

          // Rank filter
          _buildFilterSection(
              AppLocalizations.of(context)!.advancedSearchRanking,
              _ranks,
              _selectedRank, (value) {
            setState(() {
              _selectedRank = value;
            });
          }),

          SizedBox(height: 32.h),

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
              child: Text(
                AppLocalizations.of(context)!.advancedSearchPlayersButton,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Game filter
          _buildFilterSection(AppLocalizations.of(context)!.advancedSearchGame,
              _games, _selectedTeamGame, (value) {
            setState(() {
              _selectedTeamGame = value;
            });
          }),

          SizedBox(height: 16.h),

          // Team size filter
          _buildFilterSection(AppLocalizations.of(context)!.teamSizeFilter,
              _teamSizes, _selectedTeamSize, (value) {
            setState(() {
              _selectedTeamSize = value;
            });
          }),

          SizedBox(height: 16.h),

          // Verified teams only
          Row(
            children: [
              Checkbox(
                value: _verifiedTeamsOnly,
                onChanged: (value) {
                  setState(() {
                    _verifiedTeamsOnly = value ?? false;
                  });
                },
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

          SizedBox(height: 32.h),

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
              child: Text(
                AppLocalizations.of(context)!.advancedSearchTeamsButton,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options,
      String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(isSelected ? null : option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20.h),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontSize: 14.sp,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _performUserSearch() {
    // TODO: Implement user search with filters
    final filters = {
      'query': _searchController.text,
      'game': _selectedGame,
      'role': _selectedRole,
      'rank': _selectedRank,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${AppLocalizations.of(context)!.playersSearchResult}: $filters'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _performTeamSearch() {
    // TODO: Implement team search with filters
    final filters = {
      'query': _searchController.text,
      'game': _selectedTeamGame,
      'size': _selectedTeamSize,
      'verified': _verifiedTeamsOnly,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${AppLocalizations.of(context)!.teamsSearchResult}: $filters'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }
}
