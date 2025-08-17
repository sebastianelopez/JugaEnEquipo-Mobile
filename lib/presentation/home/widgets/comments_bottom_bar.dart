import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';

class CommentsBottomBar extends StatelessWidget {
  CommentsBottomBar({
    super.key,
    required this.autofocus,
    required this.postId,
  });

  final bool autofocus;
  final String postId;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeScreenProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);

    return Row(children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[200],
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5),
                spreadRadius: 2.h,
                blurRadius: 5.h,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: _controller,
            autocorrect: false,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            autofocus: autofocus,
            onTap: () {
              homeProvider.setFocus(true);
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              hintText: 'Escribe un comentario',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 2.h,
              blurRadius: 5.h,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.only(left: 5),
        child: FloatingActionButton(
          onPressed: () {
            postProvider.addComment(postId, _controller.text.toString());
            postProvider.fetchData(postId);
          },
          backgroundColor: AppTheme.primary,
          elevation: 0,
          child: const Icon(
            Icons.send,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    ]);
  }
}
