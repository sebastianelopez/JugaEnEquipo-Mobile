import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jugaenequipo/datasources/models/resource_model.dart';
import 'package:jugaenequipo/presentation/imageDetail/screens/image_detail_screen.dart';
import 'package:jugaenequipo/presentation/home/widgets/custom_video_player.dart';

class MediaGrid extends StatelessWidget {
  final List<ResourceModel> resources;
  final String? heroTagPrefix;
  final String? contextId;

  const MediaGrid({
    super.key,
    required this.resources,
    this.heroTagPrefix,
    this.contextId,
  });

  @override
  Widget build(BuildContext context) {
    final int mediaCount = resources.length;
    final double mediaSize = MediaQuery.of(context).size.width;

    if (mediaCount == 1) {
      // Single media - occupy full size
      return _buildSingleMedia(context, resources[0], mediaSize);
    } else if (mediaCount <= 2) {
      // Two media items - share width
      return Row(
        children: [
          Expanded(
            child: _buildMedia(
                context, resources[0], mediaSize / 2, mediaSize / 2, 0),
          ),
          Expanded(
            child: _buildMedia(
                context, resources[1], mediaSize / 2, mediaSize / 2, 1),
          ),
        ],
      );
    } else if (mediaCount <= 4) {
      // Three or four media items - two rows
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        children: List.generate(
          mediaCount,
          (index) => _buildMedia(context, resources[index], null, null, index),
        ),
      );
    } else {
      // Five or more media items - complex layout
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMedia(
                    context, resources[0], mediaSize / 2, mediaSize / 2, 0),
              ),
              Expanded(
                child: _buildMedia(
                    context, resources[1], mediaSize / 2, mediaSize / 2, 1),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildMedia(
                    context, resources[2], mediaSize / 3, mediaSize / 3, 2),
              ),
              Expanded(
                child: _buildMedia(
                    context, resources[3], mediaSize / 3, mediaSize / 3, 3),
              ),
              mediaCount > 5
                  ? Expanded(
                      child: _buildMoreOverlay(context, resources[4],
                          mediaSize / 3, mediaCount - 4, 4),
                    )
                  : Expanded(
                      child: _buildMedia(context, resources[4], mediaSize / 3,
                          mediaSize / 3, 4),
                    ),
            ],
          ),
        ],
      );
    }
  }

  String _getHeroTag(String url, int index) {
    final prefix = heroTagPrefix ?? 'media';
    final context = contextId ?? 'default';
    // Create a unique tag that includes context to avoid conflicts
    // when same post appears in different screens
    return '$context-$prefix-$index-$url';
  }

  Widget _buildSingleMedia(
      BuildContext context, ResourceModel resource, double size) {
    if (_isVideo(resource)) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomVideoPlayer(
          videoUrl: resource.url,
          width: size,
          height: size,
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => _openImageDetail(context, 0),
        child: Hero(
          tag: _getHeroTag(resource.url, 0),
          child: FadeInImage(
            placeholder: const AssetImage('assets/placeholder.png'),
            image: _getImageProvider(resource.url),
            width: size,
            height: size,
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) =>
                _buildErrorWidget(context, size),
          ),
        ),
      );
    }
  }

  Widget _buildMedia(BuildContext context, ResourceModel resource,
      double? width, double? height, int index) {
    if (_isVideo(resource)) {
      return SizedBox(
        width: width,
        height: height,
        child: CustomVideoPlayer(
          videoUrl: resource.url,
          width: width,
          height: height,
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => _openImageDetail(context, index),
        child: Hero(
          tag: _getHeroTag(resource.url, index),
          child: FadeInImage(
            placeholder: const AssetImage('assets/placeholder.png'),
            image: _getImageProvider(resource.url),
            width: width,
            height: height,
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) =>
                _buildErrorWidget(context, width ?? height),
          ),
        ),
      );
    }
  }

  Widget _buildMoreOverlay(BuildContext context, ResourceModel resource,
      double size, int remainingCount, int index) {
    Widget mediaWidget;

    if (_isVideo(resource)) {
      mediaWidget = SizedBox(
        width: size,
        height: size,
        child: CustomVideoPlayer(
          videoUrl: resource.url,
          width: size,
          height: size,
        ),
      );
    } else {
      mediaWidget = FadeInImage(
        placeholder: const AssetImage('assets/placeholder.png'),
        image: _getImageProvider(resource.url),
        width: size,
        height: size,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) =>
            _buildErrorWidget(context, size),
      );
    }

    return GestureDetector(
      onTap: () => _openImageDetail(context, index),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.3,
            child: Hero(
              tag: _getHeroTag(resource.url, index),
              child: mediaWidget,
            ),
          ),
          Center(
            child: Text(
              "+ $remainingCount",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 40,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, double? size) {
    return Image.asset(
      'assets/error.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }

  ImageProvider _getImageProvider(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return NetworkImage(url);
    } else if (url.startsWith('/') ||
        url.contains('\\') ||
        url.contains('/storage/') ||
        url.contains('/data/')) {
      // Local file path - use FileImage
      try {
        final file = File(url);
        if (file.existsSync()) {
          return FileImage(file);
        }
      } catch (e) {
        // If file doesn't exist or can't be accessed, fall back to error image
      }
      return const AssetImage('assets/error.png');
    } else {
      return const AssetImage('assets/error.png');
    }
  }

  bool _isVideo(ResourceModel resource) {
    // Check if the resource type indicates it's a video
    final type = resource.type.toLowerCase();
    if (type.contains('video') ||
        type == 'mp4' ||
        type == 'mov' ||
        type == 'avi' ||
        type == 'mkv') {
      return true;
    }

    // Alternatively, check by URL extension
    final url = resource.url.toLowerCase();
    return url.endsWith('.mp4') ||
        url.endsWith('.mov') ||
        url.endsWith('.avi') ||
        url.endsWith('.mkv') ||
        url.endsWith('.webm') ||
        url.endsWith('.m4v');
  }

  void _openImageDetail(BuildContext context, int index) {
    // Filter only images for the image detail screen
    final imageUrls = resources
        .where((resource) => !_isVideo(resource))
        .map((resource) => resource.url)
        .toList();

    if (imageUrls.isNotEmpty) {
      // Find the correct index in the filtered list
      int imageIndex = 0;
      for (int i = 0; i < index && i < resources.length; i++) {
        if (!_isVideo(resources[i])) {
          imageIndex++;
        }
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageDetailScreen(
            imageUrls: imageUrls,
            currentIndex: imageIndex.clamp(0, imageUrls.length - 1),
            heroTagPrefix: heroTagPrefix,
            contextId: contextId,
          ),
        ),
      );
    }
  }
}
