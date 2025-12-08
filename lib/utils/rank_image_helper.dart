import 'package:flutter/foundation.dart';

class RankImageHelper {
  /// Maps game name and rank name to asset image path
  /// Returns null if no image is available
  static String? getRankImageAsset(String gameName, String rankName) {
    if (gameName.isEmpty || rankName.isEmpty) {
      if (kDebugMode) {
        debugPrint('RankImageHelper: Empty game name or rank name provided');
      }
      return null;
    }

    if (kDebugMode) {
      debugPrint('RankImageHelper: ==========================================');
      debugPrint('RankImageHelper: Looking for rank image');
      debugPrint('RankImageHelper: Game name: "$gameName"');
      debugPrint('RankImageHelper: Rank name: "$rankName"');
    }

    // Normalize game name
    final normalizedGameName = gameName.toLowerCase().trim();
    // Normalize rank name - keep original for better matching
    final normalizedRankName = rankName.toLowerCase().trim();
    final normalizedRankNameWithDashes = normalizedRankName.replaceAll(' ', '-');

    // Map game names to their rank folder names
    String? gameFolder;
    if (normalizedGameName.contains('valorant')) {
      gameFolder = 'valorant';
    } else if (normalizedGameName.contains('league') || normalizedGameName.contains('lol')) {
      gameFolder = 'league-of-legends';
    } else if (normalizedGameName.contains('dota')) {
      gameFolder = 'dota-2';
    } else if (normalizedGameName.contains('counter') || normalizedGameName.contains('strike') || normalizedGameName.contains('cs')) {
      gameFolder = 'counter-strike-2';
    }

    if (gameFolder == null) {
      if (kDebugMode) {
        debugPrint('RankImageHelper: No game folder found for: $gameName');
        debugPrint('RankImageHelper: ==========================================');
      }
      return null;
    }

    if (kDebugMode) {
      debugPrint('RankImageHelper: Game folder: $gameFolder');
      debugPrint('RankImageHelper: Normalized rank name: "$normalizedRankName"');
      debugPrint('RankImageHelper: Normalized rank name with dashes: "$normalizedRankNameWithDashes"');
    }

    // Map rank names to their asset file names
    // Try both normalized versions
    String rankFileName = _getRankFileName(normalizedRankName, gameFolder);
    if (rankFileName.isEmpty) {
      rankFileName = _getRankFileName(normalizedRankNameWithDashes, gameFolder);
    }

    if (rankFileName.isEmpty) {
      if (kDebugMode) {
        debugPrint('RankImageHelper: No rank file found for: $rankName in game: $gameName');
        debugPrint('RankImageHelper: ==========================================');
      }
      return null;
    }

    final assetPath = 'assets/ranks/$gameFolder/$rankFileName';
    if (kDebugMode) {
      debugPrint('RankImageHelper: ✓ Found rank image: $assetPath');
      debugPrint('RankImageHelper: ==========================================');
    }
    return assetPath;
  }

  static String _getRankFileName(String normalizedRankName, String gameFolder) {
    if (kDebugMode) {
      debugPrint('RankImageHelper: _getRankFileName called with rank: "$normalizedRankName", folder: "$gameFolder"');
    }

    // Valorant ranks
    if (gameFolder == 'valorant') {
      // Check for exact matches first, then partial matches
      if (normalizedRankName == 'iron' || normalizedRankName.contains('iron')) {
        // Try to extract tier number
        final tierMatch = RegExp(r'[123]').firstMatch(normalizedRankName);
        if (tierMatch != null) {
          final tier = tierMatch.group(0);
          return 'Iron_${tier}_Rank.png';
        }
        return 'Iron_1_Rank.png';
      } else if (normalizedRankName == 'bronze' || normalizedRankName.contains('bronze')) {
        final tierMatch = RegExp(r'[123]').firstMatch(normalizedRankName);
        if (tierMatch != null) {
          final tier = tierMatch.group(0);
          return 'Bronze_${tier}_Rank.png';
        }
        return 'Bronze_1_Rank.png';
      } else if (normalizedRankName == 'silver' || normalizedRankName.contains('silver')) {
        final tierMatch = RegExp(r'[123]').firstMatch(normalizedRankName);
        if (tierMatch != null) {
          final tier = tierMatch.group(0);
          return 'Silver_${tier}_Rank.png';
        }
        return 'Silver_1_Rank.png';
      } else if (normalizedRankName == 'gold' || normalizedRankName.contains('gold')) {
        final tierMatch = RegExp(r'[123]').firstMatch(normalizedRankName);
        if (tierMatch != null) {
          final tier = tierMatch.group(0);
          return 'Gold_${tier}_Rank.png';
        }
        return 'Gold_1_Rank.png';
      } else if (normalizedRankName == 'platinum' || normalizedRankName.contains('platinum')) {
        final tierMatch = RegExp(r'[123]').firstMatch(normalizedRankName);
        if (tierMatch != null) {
          final tier = tierMatch.group(0);
          return 'Platinum_${tier}_Rank.png';
        }
        return 'Platinum_1_Rank.png';
      } else if (normalizedRankName == 'diamond' || normalizedRankName.contains('diamond')) {
        final tierMatch = RegExp(r'[123]').firstMatch(normalizedRankName);
        if (tierMatch != null) {
          final tier = tierMatch.group(0);
          return 'Diamond_${tier}_Rank.png';
        }
        return 'Diamond_1_Rank.png';
      } else if (normalizedRankName == 'ascendant' || normalizedRankName.contains('ascendant')) {
        final tierMatch = RegExp(r'[123]').firstMatch(normalizedRankName);
        if (tierMatch != null) {
          final tier = tierMatch.group(0);
          return 'Ascendant_${tier}_Rank.png';
        }
        return 'Ascendant_1_Rank.png';
      } else if (normalizedRankName == 'immortal' || normalizedRankName.contains('immortal')) {
        final tierMatch = RegExp(r'[123]').firstMatch(normalizedRankName);
        if (tierMatch != null) {
          final tier = tierMatch.group(0);
          return 'Immortal_${tier}_Rank.png';
        }
        return 'Immortal_1_Rank.png';
      } else if (normalizedRankName == 'radiant' || normalizedRankName.contains('radiant')) {
        return 'Radiant_Rank.png';
      }
    }
    // League of Legends ranks
    else if (gameFolder == 'league-of-legends') {
      // Check for exact matches first, then partial matches
      // Handle cases like "Iron", "Iron IV", "Iron 4", etc.
      if (normalizedRankName == 'iron' || normalizedRankName.startsWith('iron')) {
        return 'iron.png';
      }
      if (normalizedRankName == 'bronze' || normalizedRankName.startsWith('bronze')) {
        return 'bronze.png';
      }
      if (normalizedRankName == 'silver' || normalizedRankName.startsWith('silver')) {
        return 'silver.png';
      }
      if (normalizedRankName == 'gold' || normalizedRankName.startsWith('gold')) {
        return 'gold.png';
      }
      if (normalizedRankName == 'platinum' || normalizedRankName.startsWith('platinum')) {
        return 'platinum.png';
      }
      if (normalizedRankName == 'emerald' || normalizedRankName.startsWith('emerald')) {
        return 'emerald.png';
      }
      if (normalizedRankName == 'diamond' || normalizedRankName.startsWith('diamond')) {
        return 'diamond.png';
      }
      // Check for master/grandmaster/challenger - need to check grandmaster before master
      if (normalizedRankName == 'grandmaster' || normalizedRankName.startsWith('grandmaster')) {
        return 'grandmaster.png';
      }
      if (normalizedRankName == 'master' || normalizedRankName.startsWith('master')) {
        return 'master.png';
      }
      if (normalizedRankName == 'challenger' || normalizedRankName.startsWith('challenger')) {
        return 'challenger.png';
      }
    }
    // Dota 2 ranks - these are more complex with seasonal ranks
    else if (gameFolder == 'dota-2') {
      // Dota 2 uses seasonal ranks like "SeasonalRank1-1", "SeasonalRank1-2", etc.
      // This is a simplified mapping - you may need to adjust based on actual rank structure
      if (normalizedRankName.contains('seasonalrank1')) {
        if (normalizedRankName.contains('-1')) return 'SeasonalRank1-1.webp';
        if (normalizedRankName.contains('-2')) return 'SeasonalRank1-2.webp';
        if (normalizedRankName.contains('-3')) return 'SeasonalRank1-3.webp';
        if (normalizedRankName.contains('-4')) return 'SeasonalRank1-4.webp';
        if (normalizedRankName.contains('-5')) return 'SeasonalRank1-5.webp';
        return 'SeasonalRank1-1.webp';
      }
      // Add more mappings for other seasonal ranks as needed
      // For now, return a default
      return 'SeasonalRank1-1.webp';
    }
    // Counter-Strike ranks
    else if (gameFolder == 'counter-strike-2') {
      // Check longer names first to avoid partial matches
      if (normalizedRankName.contains('silver-elite-master')) return 'silver-elite-master.png';
      if (normalizedRankName.contains('silver-elite')) return 'silver-elite.png';
      if (normalizedRankName.contains('silver-4')) return 'silver-4.png';
      if (normalizedRankName.contains('silver-3')) return 'silver-3.png';
      if (normalizedRankName.contains('silver-2')) return 'silver-2.png';
      if (normalizedRankName.contains('silver-1')) return 'silver-1.png';
      if (normalizedRankName.contains('silver')) return 'silver-1.png';
      
      if (normalizedRankName.contains('gold-nova-4')) return 'gold-nova-4.png';
      if (normalizedRankName.contains('gold-nova-3')) return 'gold-nova-3.png';
      if (normalizedRankName.contains('gold-nova-2')) return 'gold-nova-2.png';
      if (normalizedRankName.contains('gold-nova-1')) return 'gold-nova-1.png';
      if (normalizedRankName.contains('gold-nova')) return 'gold-nova-1.png';
      
      if (normalizedRankName.contains('distinguished-master-guardian')) return 'distinguished-master-guardian.png';
      if (normalizedRankName.contains('master-guardian-elite')) return 'master-guardian-elite.png';
      if (normalizedRankName.contains('master-guardian-2')) return 'master-guardian-2.png';
      if (normalizedRankName.contains('master-guardian-1')) return 'master-guardian-1.png';
      if (normalizedRankName.contains('master-guardian')) return 'master-guardian-1.png';
      
      if (normalizedRankName.contains('legendary-eagle-master')) return 'legendary-eagle-master.png';
      if (normalizedRankName.contains('legendary-eagle')) return 'legendary-eagle.png';
      
      if (normalizedRankName.contains('supreme-master-first-class')) return 'supreme-master-first-class.png';
      if (normalizedRankName.contains('global-elite')) return 'global-elite.png';
    }

    return '';
  }
}

