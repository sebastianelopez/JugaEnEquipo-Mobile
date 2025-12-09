import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/post_use_cases/get_post_by_id_use_case.dart';
import 'package:jugaenequipo/presentation/home/widgets/post_card.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen that displays the details of a single post
class PostDetailScreen extends StatefulWidget {
  final String postId;
  final PostModel? initialPost;

  const PostDetailScreen({
    super.key,
    required this.postId,
    this.initialPost,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PostModel? _post;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    if (widget.initialPost != null) {
      _post = widget.initialPost;
    } else {
      _loadPost();
    }
  }

  Future<void> _loadPost() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final post = await getPostById(widget.postId);
      if (mounted) {
        setState(() {
          _post = post;
          _isLoading = false;
          if (post == null) {
            _errorMessage = 'Post not found';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error loading post';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations?.postsLabel ?? 'Post',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(context, localizations),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations? localizations) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
        ),
      );
    }

    if (_errorMessage != null || _post == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.h,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            SizedBox(height: 16.h),
            Text(
              _errorMessage ?? localizations?.errorMessage ?? 'Error',
              style: TextStyle(
                fontSize: 16.sp,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(localizations?.retryButton ?? 'Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: _loadPost,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Post card with full details (uses global HomeScreenProvider)
            PostCard(
              post: _post!,
              contextId: 'post_detail',
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
