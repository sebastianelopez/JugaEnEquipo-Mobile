import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/utils/utils.dart';
import 'package:jugaenequipo/theme/app_theme.dart';

class MessagesListItem extends StatelessWidget {
  final UserModel user;
  final String messageText;
  final String time;
  final bool isMessageRead;
  final String? conversationId;

  const MessagesListItem({
    super.key,
    required this.user,
    required this.messageText,
    required this.time,
    required this.isMessageRead,
    this.conversationId,
  });

  DateTime _parseDateTime(String dateString) {
    try {
      // Try parsing ISO8601 format first
      return DateTime.parse(dateString);
    } catch (e) {
      // If that fails, try parsing "YYYY-MM-DD HH:mm:ss" format
      try {
        final dateTimeParts = dateString.split(' ');
        if (dateTimeParts.length == 2) {
          final dateParts = dateTimeParts[0].split('-');
          final timeParts = dateTimeParts[1].split(':');
          if (dateParts.length == 3 && timeParts.length == 3) {
            return DateTime(
              int.parse(dateParts[0]),
              int.parse(dateParts[1]),
              int.parse(dateParts[2]),
              int.parse(timeParts[0]),
              int.parse(timeParts[1]),
              int.parse(timeParts[2]),
            );
          }
        }
      } catch (_) {}
      // If all parsing fails, return current time
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //hide keyboard
        FocusScope.of(context).unfocus();
        Navigator.of(context).pushNamed(
          'chat',
          arguments: conversationId != null
              ? {
                  'conversationId': conversationId,
                  'otherUserName': user.userName,
                  'otherUserAvatar': user.profileImage,
                }
              : user,
        );
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: isMessageRead
              ? Colors.transparent
              : AppTheme.primary.withOpacity( 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isMessageRead
                ? Colors.transparent
                : Colors.white.withOpacity( 0.2),
            width: 1,
          ),
          boxShadow: isMessageRead
              ? null
              : [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity( 0.1),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: (user.profileImage != null &&
                            user.profileImage!.isNotEmpty &&
                            (user.profileImage!.startsWith('http://') ||
                                user.profileImage!.startsWith('https://')))
                        ? Image.network(
                            user.profileImage!,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/error.png',
                            ),
                          ).image
                        : const AssetImage('assets/user_image.jpg')
                            as ImageProvider,
                    maxRadius: 30,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            user.userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            messageText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                                fontSize: 13,
                                color: isMessageRead
                                    ? AppTheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity( 0.6),
                                fontWeight: isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time.isNotEmpty
                  ? formatTimeElapsed(
                      _parseDateTime(time),
                      context,
                    )
                  : '',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isMessageRead ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
