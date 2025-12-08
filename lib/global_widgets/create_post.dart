import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/post_use_cases/create_post_use_case.dart';
import 'package:jugaenequipo/datasources/post_use_cases/share_post_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/get_users_by_username_use_case.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key, this.sharedPost, this.onPostCreated});
  final PostModel? sharedPost;
  final void Function(PostModel)? onPostCreated;

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey _textFieldKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  List<UserModel> _userSuggestions = [];
  bool _isLoadingSuggestions = false;
  bool _showSuggestions = false;
  int _mentionStartIndex = -1;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  List<TextSpan> _buildTextSpans(String text, TextStyle baseStyle) {
    final List<TextSpan> spans = [];
    final RegExp mentionRegex = RegExp(r'@(\S+)');
    int lastIndex = 0;

    for (final match in mentionRegex.allMatches(text)) {
      // Add text before the mention
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: baseStyle,
        ));
      }

      // Add the mention with special styling
      spans.add(TextSpan(
        text: match.group(0), // Includes the @ symbol
        style: baseStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.primary,
        ),
      ));

      lastIndex = match.end;
    }

    // Add remaining text after the last mention
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: baseStyle,
      ));
    }

    // If no mentions found, return simple text span
    if (spans.isEmpty) {
      spans.add(TextSpan(text: text, style: baseStyle));
    }

    return spans;
  }

  void _onTextChanged() {
    final text = _controller.text;
    final selection = _controller.selection;
    final cursorPosition = selection.baseOffset;

    if (cursorPosition == -1 || cursorPosition == 0) {
      setState(() {
        _showSuggestions = false;
        _mentionStartIndex = -1;
      });
      return;
    }

    // Find the @ symbol before the cursor
    int atIndex = -1;
    for (int i = cursorPosition - 1; i >= 0; i--) {
      if (text[i] == '@') {
        // Check if there's a space before @ (meaning it's the start of a mention)
        if (i == 0 || text[i - 1] == ' ' || text[i - 1] == '\n') {
          atIndex = i;
          break;
        }
      } else if (text[i] == ' ' || text[i] == '\n') {
        // Stop if we hit a space or newline before finding @
        break;
      }
    }

    if (atIndex != -1) {
      // Extract the query after @
      final query = text.substring(atIndex + 1, cursorPosition);
      
      // Check if query doesn't contain spaces (valid mention)
      if (!query.contains(' ') && !query.contains('\n')) {
        _mentionStartIndex = atIndex;
        _searchUsers(query);
      } else {
        setState(() {
          _showSuggestions = false;
          _mentionStartIndex = -1;
        });
      }
    } else {
      setState(() {
        _showSuggestions = false;
        _mentionStartIndex = -1;
      });
    }
  }

  void _searchUsers(String query) {
    _debounceTimer?.cancel();
    
    // Search when there's at least one character after @
    if (query.isNotEmpty) {
      setState(() {
        _showSuggestions = true;
        _isLoadingSuggestions = true;
      });
      _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
        await _fetchUsers(query);
      });
    } else {
      // When just @ is typed, show suggestions panel immediately
      setState(() {
        _showSuggestions = true;
        _isLoadingSuggestions = false;
        _userSuggestions = [];
      });
    }
  }

  Future<void> _fetchUsers(String query) async {
    if (!mounted) return;

    try {
      final users = await getUsersByUsername(query, limit: 5);
      if (mounted) {
        setState(() {
          _userSuggestions = users ?? [];
          _isLoadingSuggestions = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSuggestions = false;
        });
      }
    }
  }

  Widget _buildFormattedTextField() {
    final textStyle = TextStyle(
      fontSize: 16.h,
      color: Theme.of(context).colorScheme.onSurface,
      height: 1.5,
    );

    return Stack(
      children: [
        // Formatted text display (behind)
        if (_controller.text.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 16),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  child: RichText(
                    text: TextSpan(
                      children: _buildTextSpans(_controller.text, textStyle),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
          ),
        // Transparent text field (on top)
        TextFormField(
          key: _textFieldKey,
          controller: _controller,
          focusNode: _focusNode,
          autocorrect: false,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: _showSuggestions ? 1 : null,
          textAlignVertical: TextAlignVertical.top,
          style: TextStyle(
            fontSize: 16.h,
            height: 1.5,
            color: Colors.transparent, // Make text transparent so formatted text shows through
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          ),
          cursorColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  void _selectUser(UserModel user) {
    final text = _controller.text;
    final selection = _controller.selection;
    
    if (_mentionStartIndex == -1) return;

    // Replace the mention query with the selected username
    final beforeMention = text.substring(0, _mentionStartIndex + 1);
    final afterMention = text.substring(selection.baseOffset);
    final newText = '$beforeMention${user.userName} $afterMention';
    
    // Calculate new cursor position
    final newCursorPosition = _mentionStartIndex + 1 + user.userName.length + 1;
    
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
    
    setState(() {
      _showSuggestions = false;
      _mentionStartIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    final mediaFiles = imageProvider.mediaFileList;
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
                      widget.sharedPost != null ? 'Share post' : 'Create post',
                      style: TextStyle(fontSize: 13.h),
                    ),
                  ],
                ),
                TextButton(
                      onPressed: () async {
                        if (postId != null) {
                          final postText = _controller.text.toString();
                          final Result result = widget.sharedPost != null
                              ? await sharePost(postText,
                                  mediaFiles, postId, widget.sharedPost!.id)
                              : await createPost(postText, mediaFiles, postId);
                          if (result == Result.success) {
                            // Add optimistic post to the feed
                            final userProvider = Provider.of<UserProvider>(context, listen: false);
                            final currentUser = userProvider.user;
                            if (currentUser != null && widget.onPostCreated != null) {
                              final optimisticPost = PostModel(
                                id: postId,
                                user: currentUser.userName,
                                copy: postText,
                                createdAt: DateTime.now().toIso8601String(),
                                likes: 0,
                                comments: 0,
                                resources: null, // Will be updated when feed refreshes
                                urlProfileImage: currentUser.profileImage,
                                sharedPost: widget.sharedPost,
                              );
                              widget.onPostCreated!(optimisticPost);
                            }
                            
                            postProvider.clearPostId();
                            imageProvider.clearMediaFileList();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_showSuggestions)
                    Expanded(
                      child: _buildFormattedTextField(),
                    )
                  else
                    Flexible(
                      child: _buildFormattedTextField(),
                    ),
                  if (_showSuggestions)
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 200.h,
                        minHeight: 50.h,
                      ),
                      margin: EdgeInsets.only(top: 8.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8.h),
                        border: Border.all(
                          color: AppTheme.primary.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _isLoadingSuggestions
                          ? Padding(
                              padding: EdgeInsets.all(16.h),
                              child: const Center(child: CircularProgressIndicator()),
                            )
                          : _userSuggestions.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.all(16.h),
                                  child: Text(
                                    _mentionStartIndex != -1 && 
                                    _controller.text.length > _mentionStartIndex + 1
                                        ? 'No users found'
                                        : 'Start typing to search users...',
                                    style: TextStyle(fontSize: 14.h),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _userSuggestions.length,
                                  itemBuilder: (context, index) {
                                    final user = _userSuggestions[index];
                                    return ListTile(
                                      dense: true,
                                      leading: CircleAvatar(
                                        radius: 16.h,
                                        backgroundImage: (user.profileImage != null &&
                                                user.profileImage!.isNotEmpty &&
                                                (user.profileImage!.startsWith('http://') ||
                                                    user.profileImage!.startsWith('https://')))
                                            ? NetworkImage(user.profileImage!)
                                            : const AssetImage('assets/user_image.jpg')
                                                as ImageProvider,
                                      ),
                                      title: Text(
                                        user.userName,
                                        style: TextStyle(fontSize: 14.h),
                                      ),
                                      onTap: () => _selectUser(user),
                                    );
                                  },
                                ),
                    ),
                ],
              ),
            ),
            if (widget.sharedPost != null)
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                margin: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: SharedPost(post: widget.sharedPost!),
              ),
            const PhotoOrVideoButton(),
          ],
        ),
      ),
    );
  }
}
