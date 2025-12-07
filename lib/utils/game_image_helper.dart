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

    // Check for League of Legends (very flexible matching)
    if (normalizedName.contains('league') ||
        normalizedName.contains('lol') ||
        originalLower.contains('league of legends') ||
        originalLower == 'lol') {
      if (kDebugMode) {
        debugPrint('GameImageHelper: ✓ MATCHED League of Legends!');
      }
      return 'assets/games/lol.jpg';
    }

    // Check for Counter-Strike variations (including CS2, CS:GO, etc.)
    if (normalizedName.contains('counter') ||
        normalizedName.contains('strike') ||
        normalizedName.contains('csgo') ||
        normalizedName.contains('cs go') ||
        normalizedName.contains('cs2') ||
        normalizedName.contains('cs 2') ||
        originalLower.contains('counter-strike') ||
        originalLower.contains('counter strike') ||
        originalLower == 'cs' ||
        originalLower == 'csgo' ||
        originalLower == 'cs2' ||
        originalLower == 'cs:go') {
      if (kDebugMode) {
        debugPrint('GameImageHelper: ✓ MATCHED Counter-Strike!');
      }
      return 'assets/games/counterstrike.webp';
    }

    // Check for Dota (including Dota 2)
    if (normalizedName.contains('dota') ||
        originalLower.contains('dota') ||
        originalLower.contains('dota 2') ||
        originalLower == 'dota' ||
        originalLower == 'dota2') {
      if (kDebugMode) {
        debugPrint('GameImageHelper: ✓ MATCHED Dota!');
      }
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
