import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/post_use_cases/create_post_use_case.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatelessWidget {
  CreatePost({super.key});
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
                      'Create post',
                      style: TextStyle(fontSize: 13.h),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    if (postId != null) {
                      final Result result = await createPost(
                          _controller.text.toString(), mediaIds, postId);
                      if (result == Result.success) {
                        postProvider.clearPostId();
                      }
                    }
                    if (kDebugMode) {
                      debugPrint('TextField value: ${_controller.text}');
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
            const PhotoOrVideoButton(),
          ],
        ),
      ),
    );
  }
}
