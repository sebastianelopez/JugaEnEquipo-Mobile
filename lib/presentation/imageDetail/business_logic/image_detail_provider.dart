import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';

class ImageDetailProvider extends ChangeNotifier {
  List<ChatUserModel> chatsMocks = [
    ChatUserModel(
        user: UserModel(
            id: "asdasd98",
            firstName: "Lautaro",
            lastName: "Rivadeneira",
            userName: "LRGC",
            email: "",
            profileImage:
                "https://scontent.cdninstagram.com/v/t51.2885-19/195780402_1055586888183094_99043525364029635_n.jpg?stp=dst-jpg_s150x150&_nc_ht=scontent.cdninstagram.com&_nc_cat=110&_nc_ohc=XT8Rspy1K-EQ7kNvgGA1T9o&edm=APs17CUBAAAA&ccb=7-5&oh=00_AfD4gI3ZTZvVUa-z2ETq6fOTk6bqrFpoOa8G_hBi8xfz4A&oe=663C6879&_nc_sid=10d13b"),
        messageText: "extraño tu pene",
        isMessageRead: false,
        time: "2024-05-04 15:00:04Z"),
    ChatUserModel(
        user: UserModel(
            id: "asda5sd498",
            firstName: "Alejandro",
            lastName: "Minetti",
            userName: "Alem87",
            email: "",
            profileImage:
                "https://scontent.cdninstagram.com/v/t51.2885-19/429985363_704173345123485_6621486499715753530_n.jpg?stp=dst-jpg_s150x150&_nc_ht=scontent.cdninstagram.com&_nc_cat=109&_nc_ohc=K-zt1QFWQX8Q7kNvgGDhGBd&edm=APs17CUBAAAA&ccb=7-5&oh=00_AfCjp7AsUWD1zbcgb-tHrJmlv2wtfymnZ_yap1ebUhVnCQ&oe=663C6418&_nc_sid=10d13b"),
        messageText: "me pasas tu skincare?",
        isMessageRead: false,
        time: "2024-04-21 19:18:04Z"),
    ChatUserModel(
        user: UserModel(
            id: "asda5sd128",
            firstName: "Matias",
            lastName: "Racing",
            userName: "Matcing",
            email: "",
            profileImage:
                "https://scontent.cdninstagram.com/v/t51.2885-19/57116481_405440056941131_5387659121300340736_n.jpg?stp=dst-jpg_s150x150&_nc_ht=scontent.cdninstagram.com&_nc_cat=111&_nc_ohc=KYEc7Zv7PDsQ7kNvgGxupVR&edm=APs17CUBAAAA&ccb=7-5&oh=00_AfBmMXLt72pxPH3-8a-9qa97FE8T7bzQE7HWYXxNiA_1dA&oe=663C5A24&_nc_sid=10d13b"),
        messageText: "soy bostero, no lo puedo ocultar mas",
        isMessageRead: false,
        time: "2024-03-21 19:18:04Z"),
  ];
}
