import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_users_by_username_use_case.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

/// Widget that displays text with mentions (@username) highlighted in bold and violet color
/// Mentions are clickable and navigate to the user's profile if the user exists
class MentionText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const MentionText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get default text style from context and ensure it has a color
    final baseStyle = style ?? DefaultTextStyle.of(context).style;
    final theme = Theme.of(context);
    final defaultColor = baseStyle.color ?? 
        theme.textTheme.bodyMedium?.color ?? 
        theme.colorScheme.onSurface;
    final defaultStyle = baseStyle.copyWith(color: defaultColor);

    // Parse the text to find mentions (words starting with @)
    final List<TextSpan> spans = [];
    final RegExp mentionRegex = RegExp(r'@(\S+)');
    int lastIndex = 0;
    bool hasMentions = false;

    for (final match in mentionRegex.allMatches(text)) {
      hasMentions = true;
      // Add text before the mention
      if (match.start > lastIndex) {
        final beforeText = text.substring(lastIndex, match.start);
        if (beforeText.isNotEmpty) {
          spans.add(TextSpan(
            text: beforeText,
            style: defaultStyle.copyWith(
              color: defaultColor, // Explicit color
            ),
          ));
        }
      }

      // Add the mention with special styling and tap recognizer
      final mentionText = match.group(0)!; // Includes the @ symbol
      final username = match.group(1)!; // Username without @
      
      spans.add(TextSpan(
        text: mentionText,
        style: defaultStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.primary,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _handleMentionTap(context, username),
      ));

      lastIndex = match.end;
    }

    // Add remaining text after the last mention
    if (lastIndex < text.length) {
      final afterText = text.substring(lastIndex);
      if (afterText.isNotEmpty) {
        spans.add(TextSpan(
          text: afterText,
          style: defaultStyle.copyWith(
            color: defaultColor, // Explicit color
          ),
        ));
      }
    }

    // If no mentions found, return simple text
    if (!hasMentions) {
      return Text(
        text,
        style: defaultStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    // If we have mentions but no spans (shouldn't happen), return simple text
    if (spans.isEmpty) {
      return Text(
        text,
        style: defaultStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    // Build the final text span with all parts
    // Ensure the root TextSpan has explicit color for inheritance
    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: spans,
      ),
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }

  /// Handles tap on a mention by searching for the user and navigating to their profile
  Future<void> _handleMentionTap(BuildContext context, String username) async {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return;

    try {
      final users = await getUsersByUsername(username);
      if (users != null && users.isNotEmpty) {
        final user = users.first;
        if (context.mounted) {
          Navigator.pushNamed(
            context,
            'profile',
            arguments: {'userId': user.id},
          );
        }
      } else {
        // User not found - show snackbar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('@$username ${localizations.userNotFound.toLowerCase()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // Error loading user - show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.errorLoadingUserProfile),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

