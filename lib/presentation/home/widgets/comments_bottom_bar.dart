import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/home/business_logic/home_screen_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CommentsBottomBar extends StatefulWidget {
  const CommentsBottomBar({
    super.key,
    required this.autofocus,
    required this.postId,
    this.onCommentAdded,
  });

  final bool autofocus;
  final String postId;
  final VoidCallback? onCommentAdded;

  @override
  State<CommentsBottomBar> createState() => _CommentsBottomBarState();
}

class _CommentsBottomBarState extends State<CommentsBottomBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    if (_controller.text.trim().isEmpty || _isSending) return;

    final homeProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final commentText = _controller.text.trim();

    // Create optimistic comment
    final optimisticComment = CommentModel(
      id: const Uuid().v4(), // Temporary ID
      userId: userProvider.user?.id,
      username: userProvider.user?.userName,
      profileImage: userProvider.user?.profileImage,
      comment: commentText,
      createdAt: DateTime.now().toUtc().toString(),
    );

    // Add optimistic comment immediately
    postProvider.addOptimisticComment(optimisticComment);

    // Clear input and hide keyboard
    _controller.clear();
    homeProvider.setFocus(false);
    FocusScope.of(context).unfocus();

    setState(() {
      _isSending = true;
    });

    try {
      debugPrint(
          'CommentsBottomBar - Sending comment for postId: ${widget.postId}');
      final success = await postProvider.addComment(widget.postId, commentText);
      debugPrint('CommentsBottomBar - Add comment result: $success');

      if (!success) {
        // If failed, remove the optimistic comment and show error
        postProvider.removeComment(optimisticComment);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al enviar el comentario'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Notify that a comment was added to update the post counter
        widget.onCommentAdded?.call();

        debugPrint(
            'CommentsBottomBar - Comment sent successfully (optimistic update)');
      }
    } catch (e) {
      debugPrint('CommentsBottomBar - Error: $e');

      // Remove optimistic comment on error
      postProvider.removeComment(optimisticComment);

      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al enviar el comentario'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeScreenProvider>(context);

    return Row(children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: AppTheme.black.withOpacity(0.5),
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
            autofocus: widget.autofocus,
            enabled: !_isSending,
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
              color: AppTheme.black.withOpacity(0.5),
              spreadRadius: 2.h,
              blurRadius: 5.h,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.only(left: 5),
        child: FloatingActionButton(
          onPressed: _isSending ? null : _sendComment,
          backgroundColor:
              _isSending ? AppTheme.primary.withOpacity(0.5) : AppTheme.primary,
          elevation: 0,
          child: _isSending
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                ),
        ),
      ),
    ]);
  }
}
