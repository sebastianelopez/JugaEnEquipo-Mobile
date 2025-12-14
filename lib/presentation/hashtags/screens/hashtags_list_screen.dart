import 'package:flutter/material.dart';
import 'package:jugaenequipo/presentation/hashtags/business_logic/hashtags_list_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/presentation/hashtags/widgets/hashtag_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HashtagsListScreen extends StatefulWidget {
  const HashtagsListScreen({super.key});

  @override
  State<HashtagsListScreen> createState() => _HashtagsListScreenState();
}

class _HashtagsListScreenState extends State<HashtagsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HashtagsListProvider>().fetchHashtags();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Hashtags',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<HashtagsListProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.hashtags.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
              ),
            );
          }

          if (provider.hashtags.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.tag,
                    size: 64.h,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No hashtags available',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: provider.refresh,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: provider.hashtags.length,
              itemBuilder: (context, index) {
                return HashtagItem(hashtag: provider.hashtags[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

