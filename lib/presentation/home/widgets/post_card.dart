import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/post_model.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';
import 'package:jugaenequipo/presentation/imageDetail/screens/image_detail_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/utils/utils.dart';
import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeScreenProvider>(context);
    return Center(
      child: Card(
        margin: EdgeInsets.only(
          top: 8.0.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: SizedBox(
                height: 50.h,
                width: 50.h,
                child: CircleAvatar(
                  maxRadius: 15.h,
                  backgroundImage: const NetworkImage(
                    'https://elcomercio.pe/resizer/xvcflv5nZ6qztMCIojBYfROeCmo=/1200x800/smart/filters:format(jpeg):quality(75)/cloudfront-us-east-1.images.arcpublishing.com/elcomercio/J5TZJL65YBB2JN5TCPZBJVNJTQ.webp',
                  ),
                ),
              ),
              title: Text(post.user?.userName ?? 'user',
                  style:
                      TextStyle(fontWeight: FontWeight.w900, fontSize: 15.h)),
              subtitle: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO: getTeamById()
                    /*  
                      if (post.user.teamId != null)
                      Text(
                        post.user.team!.name,
                        style: const TextStyle(fontSize: 13),
                      ), */
                    Text(
                        formatTimeElapsed(
                            DateTime.parse(post.createdAt), context),
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 13.h)),
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                if (post.copy != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    width: double.infinity,
                    child: Text(
                      post.copy!,
                      style: TextStyle(fontSize: 13.h),
                    ),
                  ),
                const SizedBox(height: 8),
                if (post.images != null) ImageGrid(images: post.images!),
                const SizedBox(height: 8),
              ],
            ),
            if (post.likes != null || post.comments != null)
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                    foregroundColor: WidgetStatePropertyAll(Colors.grey)),
                onPressed: () {
                  // Add your button action here
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (post.likes! > 0)
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 15.0.h,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            post.likes.toString(),
                            style: TextStyle(fontSize: 14.h),
                          ),
                        ],
                      ),
                    if (post.comments! > 0)
                      TextButton(
                        onPressed: () {
                          homeProvider.openCommentsModal(context);
                        },
                        child: Text(
                          post.comments! > 0
                              ? "${post.comments} comentarios"
                              : '',
                          style: TextStyle(fontSize: 14.h),
                        ),
                      ),
                  ],
                ),
              ),
            Divider(
              color: Colors.grey[300],
              height: 5,
              indent: 10,
              endIndent: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  color: Colors.grey,
                  icon: const Icon(Icons.favorite),
                  iconSize: 24.h,
                  onPressed: () {
                    // Handle the message icon press here.
                  },
                ),
                IconButton(
                  color: Colors.grey,
                  icon: const Icon(Icons.message),
                  iconSize: 24.h,
                  onPressed: () {
                    homeProvider.openCommentsModal(context, autofocus: true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
