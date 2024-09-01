import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/post_model.dart';
import 'package:jugaenequipo/presentation/home/widgets/widgets.dart';
import 'package:jugaenequipo/presentation/imageDetail/screens/image_detail_screen.dart';
import 'package:jugaenequipo/utils/utils.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.only(
          top: 8.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://elcomercio.pe/resizer/xvcflv5nZ6qztMCIojBYfROeCmo=/1200x800/smart/filters:format(jpeg):quality(75)/cloudfront-us-east-1.images.arcpublishing.com/elcomercio/J5TZJL65YBB2JN5TCPZBJVNJTQ.webp'),
                maxRadius: 25,
              ),
              title: Text(post.user.userName,
                  style: const TextStyle(fontWeight: FontWeight.w900)),
              subtitle: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (post.user.teamId != null)
                      // TODO: getTeamById()
                      /*  Text(
                        post.user.team!.name,
                        style: const TextStyle(fontSize: 13),
                      ), */
                      Text(
                          formatTimeElapsed(
                              DateTime.parse(post.postDate), context),
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 13)),
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
                    ),
                  ),
                const SizedBox(height: 8),
                if (post.images!.isNotEmpty) ImageGrid(images: post.images!),
                const SizedBox(height: 8),
              ],
            ),
            if (post.likes > 0 || post.comments > 0)
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent),
                    foregroundColor: MaterialStatePropertyAll(Colors.grey)),
                onPressed: () {
                  // Add your button action here
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          size: 15.0,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(post.likes.toString()),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (BuildContext context) {
                            return const Comments();
                          },
                        );
                      },
                      child: Text(post.comments > 0
                          ? "${post.comments} comentarios"
                          : ''),
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
                  onPressed: () {
                    // Handle the message icon press here.
                  },
                ),
                IconButton(
                  color: Colors.grey,
                  icon: const Icon(Icons.message),
                  onPressed: () {
                    // Handle the message icon press here.
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
