import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaSection extends StatelessWidget {
  final Map<String, String> socialLinks;

  const SocialMediaSection({super.key, required this.socialLinks});

  @override
  Widget build(BuildContext context) {
    if (socialLinks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.socialMediaLabel,
            style: TextStyle(
              fontSize: 16.h,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 12.w,
            runSpacing: 12.h,
            children: socialLinks.entries.map((entry) {
              return _buildSocialButton(context, entry.key, entry.value);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, String platform, String url) {
    final iconData = _getIconForPlatform(platform);
    final color = _getColorForPlatform(platform);

    return GestureDetector(
      onTap: () async {
        await _launchUrl(url, context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: color,
              size: 20.h,
            ),
            SizedBox(width: 8.w),
            Text(
              platform,
              style: TextStyle(
                fontSize: 14.h,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForPlatform(String platform) {
    switch (platform.toLowerCase()) {
      case 'twitter':
      case 'x':
        return Icons.alternate_email;
      case 'instagram':
        return Icons.camera_alt;
      case 'discord':
        return Icons.chat_bubble;
      case 'youtube':
        return Icons.play_circle;
      case 'twitch':
        return Icons.videocam;
      case 'tiktok':
        return Icons.music_note;
      case 'facebook':
        return Icons.facebook;
      default:
        return Icons.link;
    }
  }

  Color _getColorForPlatform(String platform) {
    switch (platform.toLowerCase()) {
      case 'twitter':
      case 'x':
        return Colors.blue;
      case 'instagram':
        return Colors.purple;
      case 'discord':
        return Colors.indigo;
      case 'youtube':
        return Colors.red;
      case 'twitch':
        return Colors.purple;
      case 'tiktok':
        return Colors.black;
      case 'facebook':
        return Colors.blue;
      default:
        return AppTheme.primary;
    }
  }

  Future<void> _launchUrl(String urlString, BuildContext context) async {
    try {
      // Asegurar que la URL tenga el protocolo correcto
      Uri uri;
      if (urlString.startsWith('http://') || urlString.startsWith('https://')) {
        uri = Uri.parse(urlString);
      } else {
        uri = Uri.parse('https://$urlString');
      }

      // Intentar abrir la URL directamente
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorMessage),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.errorMessage}: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
