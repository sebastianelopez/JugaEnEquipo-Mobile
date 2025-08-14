import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/share_preferences/preferences.dart';
import 'package:jugaenequipo/utils/utils.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        Navigator.of(context).pushNamed('chat', arguments: user);
      },
      child: Container(
        padding:
            EdgeInsets.only(left: 16.h, right: 16.h, top: 10.h, bottom: 10.h),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: user.profileImage != null
                        ? Image.network(
                            user.profileImage!,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/error.png',
                            ),
                          ).image
                        : const AssetImage('assets/user_image.jpg')
                            as ImageProvider,
                    maxRadius: 20.h,
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
                                color: Preferences.isDarkmode
                                    ? Colors.grey.shade100
                                    : Colors.grey.shade900,
                                fontSize: FontSize(13.h)),
                            'body': Style(
                              color: Preferences.isDarkmode
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700,
                              fontSize: FontSize(13.h),
                            ),
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
                  fontSize: 12.h,
                  fontWeight:
                      isNotificationRead ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
