import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class GameImageHelper {
  /// Maps game name to asset image path
  /// Returns null if no image is available for the game
  static String? getGameImageAsset(String gameName) {
    if (gameName.isEmpty) {
      if (kDebugMode) {
        debugPrint('GameImageHelper: Empty game name provided');
      }
      return null;
    }

    // Normalize: lowercase, trim, remove special characters
    final normalizedName =
        gameName.toLowerCase().trim().replaceAll(RegExp(r'[^\w\s]'), '');
    final originalLower = gameName.toLowerCase().trim();

    if (kDebugMode) {
      debugPrint('GameImageHelper: ==========================================');
      debugPrint('GameImageHelper: Original name: "$gameName"');
      debugPrint('GameImageHelper: Lowercase: "$originalLower"');
      debugPrint('GameImageHelper: Normalized: "$normalizedName"');
    }

    // Map game names to their asset paths
    // Check for Valorant (various spellings) - be very permissive
    // Check multiple variations to catch any possible spelling
    final isValorant = normalizedName.contains('valorant') ||
        originalLower.contains('valorant') ||
        normalizedName == 'valorant' ||
        originalLower == 'valorant' ||
        gameName.toLowerCase() == 'valorant' ||
        normalizedName.startsWith('valorant') ||
        originalLower.startsWith('valorant');

    if (isValorant) {
      if (kDebugMode) {
        debugPrint('GameImageHelper: ✓ MATCHED Valorant!');
        debugPrint('GameImageHelper: Returning: assets/games/valorant.png');
        debugPrint(
            'GameImageHelper: ==========================================');
      }
      return 'assets/games/valorant.png';
    }

    if (kDebugMode) {
      debugPrint('GameImageHelper: ✗ No match for Valorant');
    }
    // Check for League of Legends
    else if (normalizedName.contains('league') &&
        normalizedName.contains('legends')) {
      return 'assets/games/lol.jpg';
    }
    // Check for LoL abbreviation
    else if (normalizedName == 'lol' ||
        normalizedName == 'league of legends' ||
        normalizedName.startsWith('lol ')) {
      return 'assets/games/lol.jpg';
    }
    // Check for Counter-Strike variations
    else if (normalizedName.contains('counter') &&
        normalizedName.contains('strike')) {
      return 'assets/games/counterstrike.webp';
    } else if (normalizedName.contains('csgo') ||
        normalizedName.contains('cs go') ||
        normalizedName.contains('cs2') ||
        normalizedName == 'cs' ||
        normalizedName.startsWith('cs ')) {
      return 'assets/games/counterstrike.webp';
    }
    // Check for Dota
    else if (normalizedName.contains('dota')) {
      return 'assets/games/dotalogo.jpg';
    }

    return null;
  }

  /// Builds a widget that displays the game image or a default icon
  ///
  /// Parameters:
  /// - [gameName]: The name of the game
  /// - [width]: Width of the image widget
  /// - [height]: Height of the image widget
  /// - [defaultIcon]: Icon to show if no image is available (default: Icons.sports_esports)
  /// - [defaultIconColor]: Color for the default icon
  /// - [defaultIconSize]: Size for the default icon
  /// - [fit]: How the image should be fitted (default: BoxFit.cover)
  static Widget buildGameImage({
    required String gameName,
    required double width,
    required double height,
    IconData defaultIcon = Icons.sports_esports,
    Color? defaultIconColor,
    double? defaultIconSize,
    BoxFit fit = BoxFit.cover,
  }) {
    final imageAsset = getGameImageAsset(gameName);

    if (imageAsset != null) {
      if (kDebugMode) {
        debugPrint(
            'GameImageHelper: Building image widget for asset: $imageAsset');
        debugPrint('GameImageHelper: Game name was: "$gameName"');
      }

      // Try to load the asset directly first to verify it exists
      try {
        return Image.asset(
          imageAsset,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            if (kDebugMode) {
              debugPrint(
                  'GameImageHelper: Error loading image $imageAsset: $error');
              debugPrint('GameImageHelper: Error type: ${error.runtimeType}');
              debugPrint('GameImageHelper: StackTrace: $stackTrace');
            }
            return _buildDefaultIcon(
              width: width,
              height: height,
              icon: defaultIcon,
              color: defaultIconColor,
              size: defaultIconSize,
            );
          },
        );
      } catch (e) {
        if (kDebugMode) {
          debugPrint('GameImageHelper: Exception loading asset: $e');
        }
        return _buildDefaultIcon(
          width: width,
          height: height,
          icon: defaultIcon,
          color: defaultIconColor,
          size: defaultIconSize,
        );
      }
    }

    if (kDebugMode) {
      debugPrint('GameImageHelper: No image asset found for game: $gameName');
    }

    return _buildDefaultIcon(
      width: width,
      height: height,
      icon: defaultIcon,
      color: defaultIconColor,
      size: defaultIconSize,
    );
  }

  static Widget _buildDefaultIcon({
    required double width,
    required double height,
    required IconData icon,
    Color? color,
    double? size,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: (color ?? Colors.grey).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color ?? Colors.grey,
        size: size ?? (width * 0.5),
      ),
    );
  }
}
