import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TournamentBackgroundImage extends StatelessWidget {
  final String? imageUrl;

  const TournamentBackgroundImage({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 280.h,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? _buildImageBackground(imageUrl!)
          : _buildGradientBackground(),
    );
  }

  Widget _buildImageBackground(String imageUrl) {
    final isNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: isNetworkImage
                  ? NetworkImage(imageUrl)
                  : const AssetImage('assets/login.png') as ImageProvider,
              fit: BoxFit.cover,
              onError: (exception, stackTrace) {
                if (kDebugMode) {
                  debugPrint('Error loading background image: $exception');
                }
              },
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.7),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary,
            AppTheme.primary.withOpacity(0.8),
            AppTheme.accent.withOpacity(0.6),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

