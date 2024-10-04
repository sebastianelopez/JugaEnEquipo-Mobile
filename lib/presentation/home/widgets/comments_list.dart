import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeScreenProvider>(context);
    final user = Provider.of<UserProvider>(context).user;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Column(
        children: List.generate(homeProvider.commentsMocks.length, (index) {
          final isLoggedUser =
              homeProvider.commentsMocks[index].userId == user?.id;
          return Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Align(
              alignment:
                  (!isLoggedUser ? Alignment.topLeft : Alignment.topRight),
              child: Column(
                crossAxisAlignment:
                    homeProvider.commentsMocks[index].userId != user?.id
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                children: [
                  Text(
                      (user?.firstName != null && user?.lastName != null)
                          ? '${user!.firstName} ${user.lastName}'
                          : '',
                      style: TextStyle(
                          fontSize: 15.h, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: !isLoggedUser
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (!isLoggedUser)
                        CircleAvatar(
                          backgroundImage: const AssetImage(
                              'assets/login.png'), // Replace with your profile image path
                          radius: 16.w,
                          backgroundColor: Colors.white,
                        ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (!isLoggedUser
                              ? Colors.grey.shade300
                              : Colors.blue[200]),
                        ),
                        margin: EdgeInsets.only(
                            left: isLoggedUser ? 0 : 10,
                            right: isLoggedUser ? 10 : 0,
                            top: 7),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: Text(
                          homeProvider.commentsMocks[index].copy ?? '',
                          style: TextStyle(fontSize: 15.h),
                        ),
                      ),
                      if (isLoggedUser)
                        CircleAvatar(
                          backgroundImage: const AssetImage(
                              'assets/login.png'), // Replace with your profile image path
                          radius: 16.w,
                          backgroundColor: Colors.white,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
