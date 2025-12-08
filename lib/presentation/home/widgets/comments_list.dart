import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final postProvider = Provider.of<PostProvider>(context);

    final comments = postProvider.isLoading
        ? List.filled(
            7,
            CommentModel(
              id: '',
              userId: '',
              username: 'user',
              comment: 'aaaaaaaaaaaaaaaaa',
              createdAt: '2024-04-20 20:18:04Z',
            ))
        : postProvider.comments;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Skeletonizer(
        enabled: postProvider.isLoading,
        child: Column(
          children: List.generate(comments.length, (index) {
            final comment = comments[index];
            final isLoggedUser = comment.userId == user?.id;

            return Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 10),
              child: Align(
                alignment:
                    (!isLoggedUser ? Alignment.topLeft : Alignment.topRight),
                child: Column(
                  crossAxisAlignment: !isLoggedUser
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Text(comment.username ?? '',
                        style: TextStyle(
                            fontSize: 15.h, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: !isLoggedUser
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        if (!isLoggedUser)
                          CircleAvatar(
                            backgroundImage: comment.profileImage != null &&
                                    comment.profileImage!.isNotEmpty
                                ? NetworkImage(comment.profileImage!)
                                : const AssetImage('assets/login.png')
                                    as ImageProvider,
                            radius: 16.w,
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                          ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (!isLoggedUser
                                ? Theme.of(context).colorScheme.surface
                                : Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.2)),
                          ),
                          margin: EdgeInsets.only(
                              left: isLoggedUser ? 0 : 10,
                              right: isLoggedUser ? 10 : 0,
                              top: 7),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          child: Text(
                            comment.comment ?? '',
                            style: TextStyle(fontSize: 15.h),
                          ),
                        ),
                        if (isLoggedUser)
                          CircleAvatar(
                            backgroundImage: comment.profileImage != null &&
                                    comment.profileImage!.isNotEmpty
                                ? NetworkImage(comment.profileImage!)
                                : const AssetImage('assets/login.png')
                                    as ImageProvider,
                            radius: 16.w,
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
