import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_users_by_username_use_case.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class _TextSegment {
  final String text;
  final bool isMention;
  final bool isHashtag;
  final String? value;

  _TextSegment({
    required this.text,
    this.isMention = false,
    this.isHashtag = false,
    this.value,
  });
}

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

    final baseStyle = style ?? DefaultTextStyle.of(context).style;
    final theme = Theme.of(context);
    final defaultColor = baseStyle.color ??
        theme.textTheme.bodyMedium?.color ??
        theme.colorScheme.onSurface;
    final defaultStyle = baseStyle.copyWith(color: defaultColor);

    final segments = _parseText(text);

    if (segments.length == 1 &&
        !segments.first.isMention &&
        !segments.first.isHashtag) {
      return Text(
        text,
        style: defaultStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final List<TextSpan> spans = [];

    for (final segment in segments) {
      if (segment.isMention) {
        spans.add(TextSpan(
          text: segment.text,
          style: defaultStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _handleMentionTap(context, segment.value!),
        ));
      } else if (segment.isHashtag) {
        spans.add(TextSpan(
          text: segment.text,
          style: defaultStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _handleHashtagTap(context, segment.value!),
        ));
      } else {
        spans.add(TextSpan(
          text: segment.text,
          style: defaultStyle.copyWith(color: defaultColor),
        ));
      }
    }

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

  List<_TextSegment> _parseText(String text) {
    final List<_TextSegment> segments = [];
    final RegExp mentionRegex = RegExp(r'@(\S+)');
    final RegExp hashtagRegex = RegExp(r'#(\S+)');

    final List<RegExpMatch> allMatches = [];
    allMatches.addAll(mentionRegex.allMatches(text));
    allMatches.addAll(hashtagRegex.allMatches(text));

    allMatches.sort((a, b) => a.start.compareTo(b.start));

    int lastIndex = 0;

    for (final match in allMatches) {
      if (match.start > lastIndex) {
        final beforeText = text.substring(lastIndex, match.start);
        if (beforeText.isNotEmpty) {
          segments.add(_TextSegment(text: beforeText));
        }
      }

      final matchText = match.group(0)!;
      final value = match.group(1)!;

      if (matchText.startsWith('@')) {
        segments.add(_TextSegment(
          text: matchText,
          isMention: true,
          value: value,
        ));
      } else if (matchText.startsWith('#')) {
        segments.add(_TextSegment(
          text: matchText,
          isHashtag: true,
          value: value,
        ));
      }

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      final afterText = text.substring(lastIndex);
      if (afterText.isNotEmpty) {
        segments.add(_TextSegment(text: afterText));
      }
    }

    return segments;
  }

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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '@$username ${localizations.userNotFound.toLowerCase()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
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

  void _handleHashtagTap(BuildContext context, String hashtag) {
    Navigator.pushNamed(
      context,
      'hashtag-posts',
      arguments: {'hashtag': hashtag},
    );
  }
}
