import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchResultsSection extends StatelessWidget {
  final bool isLoading;
  final bool hasResults;
  final String sectionTitle;
  final IconData sectionIcon;
  final Widget Function() resultsBuilder;

  const SearchResultsSection({
    super.key,
    required this.isLoading,
    required this.hasResults,
    required this.sectionTitle,
    required this.sectionIcon,
    required this.resultsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading && !hasResults) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (!hasResults)
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0.h),
              child: Text(
                'No se encontraron resultados',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
          )
        else ...[
          _buildSectionHeader(sectionTitle, sectionIcon),
          SizedBox(height: 8.h),
          resultsBuilder(),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20.h, color: Colors.grey[600]),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

