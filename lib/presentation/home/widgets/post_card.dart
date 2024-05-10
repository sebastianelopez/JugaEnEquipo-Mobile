import 'package:flutter/material.dart';
import 'package:jugaenequipo/models/post.dart';
import 'package:jugaenequipo/utils/utils.dart';

class PostCard extends StatelessWidget {
  final Post post;

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
              leading: const Icon(Icons.album),
              title: Text(post.user.name),
              subtitle: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (post.user.team != null)
                      Text(
                        post.user.team!.name,
                      ),
                    Text(
                      formatTimeElapsed(DateTime.parse(post.postDate), context),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                if (post.copy != null)
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      post.copy!,
                    ),
                  ),
                const SizedBox(height: 8),
                const FadeInImage(
                  placeholder: AssetImage('assets/placeholder.png'),
                  image: NetworkImage(
                      'https://static.wikia.nocookie.net/onepiece/images/a/af/Monkey_D._Luffy_Anime_Dos_A%C3%B1os_Despu%C3%A9s_Infobox.png/revision/latest?cb=20200616015904&path-prefix=es'),
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
              ],
            ),
            if (post.peopleWhoLikeIt.isNotEmpty || post.comments.isNotEmpty)
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
                        Text(post.peopleWhoLikeIt.length.toString()),
                      ],
                    ),
                    Text(post.comments.isNotEmpty
                        ? "${post.comments.length} comentarios"
                        : ''),
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
