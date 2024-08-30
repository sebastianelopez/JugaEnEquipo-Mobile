import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/utils/utils.dart';
import 'package:flutter_html/flutter_html.dart';

class NotificationsListItem extends StatelessWidget {
  final UserModel user;
  final String notificationContent;
  final String date;
  final bool isNotificationRead;

  const NotificationsListItem(
      {super.key,
      required this.user,
      required this.notificationContent,
      required this.date,
      required this.isNotificationRead});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //hide keyboard
        FocusScope.of(context).unfocus();
        Navigator.pushNamed(context, 'chat');
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImage!),
                    maxRadius: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Html(
                          data: notificationContent,
                          style: {
                            'b': Style(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900),
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              formatTimeElapsed(DateTime.parse(date), context),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isNotificationRead ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
