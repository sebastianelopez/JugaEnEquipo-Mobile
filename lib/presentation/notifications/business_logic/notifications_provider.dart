import 'package:flutter/material.dart';
import 'package:jugaenequipo/models/models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsProvider extends ChangeNotifier {
  List<NotificationItem> getMockNotifications([BuildContext? context]) {
    return [
      NotificationItem(
          user: User(
              name: "Lautaro Gabriel Rivadeneira Casas",
              mail: "",
              profileImage:
                  "https://scontent.cdninstagram.com/v/t51.2885-19/195780402_1055586888183094_99043525364029635_n.jpg?stp=dst-jpg_s150x150&_nc_ht=scontent.cdninstagram.com&_nc_cat=110&_nc_ohc=XT8Rspy1K-EQ7kNvgGA1T9o&edm=APs17CUBAAAA&ccb=7-5&oh=00_AfD4gI3ZTZvVUa-z2ETq6fOTk6bqrFpoOa8G_hBi8xfz4A&oe=663C6879&_nc_sid=10d13b"),
          notificationContent:
              AppLocalizations.of(context!)!.notificationPostLiked('Lautaro'),
          isNotificationRead: false,
          date: "2024-05-04 15:00:04Z"),
      NotificationItem(
          user: User(
              name: "Ale Minetti",
              mail: "",
              profileImage:
                  "https://scontent.cdninstagram.com/v/t51.2885-19/429985363_704173345123485_6621486499715753530_n.jpg?stp=dst-jpg_s150x150&_nc_ht=scontent.cdninstagram.com&_nc_cat=109&_nc_ohc=K-zt1QFWQX8Q7kNvgGDhGBd&edm=APs17CUBAAAA&ccb=7-5&oh=00_AfCjp7AsUWD1zbcgb-tHrJmlv2wtfymnZ_yap1ebUhVnCQ&oe=663C6418&_nc_sid=10d13b"),
          notificationContent:
              AppLocalizations.of(context)!.notificationInviteToTeam("Ale", "Bosteros"),
          isNotificationRead: true,
          date: "2024-04-21 19:18:04Z"),
      NotificationItem(
          user: User(
              name: "Kru Sports",
              mail: "",
              profileImage:
                  "https://static.wikia.nocookie.net/lolesports_gamepedia_en/images/b/b8/KR%C3%9C_Esportslogo_square.png/revision/latest?cb=20220922072349"),
          notificationContent:
              AppLocalizations.of(context)!.notificationApplicationAccepted('damage', 'Kru Sports'),
          isNotificationRead: true,
          date: "2024-03-21 19:18:04Z"),
    ];
  }

  List<NotificationItem> notificationMocks = [];
}
