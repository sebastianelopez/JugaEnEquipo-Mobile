import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/post_use_cases/create_post_use_case.dart';
import 'package:jugaenequipo/datasources/post_use_cases/share_post_use_case.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatelessWidget {
  CreatePost({super.key, this.sharedPost});
  final PostModel? sharedPost;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final mediaIds = Provider.of<ImagePickerProvider>(context).mediaFileListIds;
    final postId = postProvider.postId;
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, size: 22.h),
                    ),
                    Text(
                      sharedPost != null ? 'Share post' : 'Create post',
                      style: TextStyle(fontSize: 13.h),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    if (postId != null) {
                      final Result result = sharedPost != null
                          ? await sharePost(_controller.text.toString(),
                              mediaIds, postId, sharedPost!.id)
                          : await createPost(
                              _controller.text.toString(), mediaIds, postId);
                      if (result == Result.success) {
                        postProvider.clearPostId();
                      }

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        const WidgetStatePropertyAll(AppTheme.primary),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 8.h),
                    ),
                  ),
                  child: Text('Post',
                      style: TextStyle(fontSize: 13.h, color: Colors.white)),
                ),
              ],
            ),
            Expanded(
              child: TextFormField(
                controller: _controller,
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            if (sharedPost != null)
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                margin: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: SharedPost(post: sharedPost!),
              ),
            const PhotoOrVideoButton(),
          ],
        ),
      ),
    );
  }
}
