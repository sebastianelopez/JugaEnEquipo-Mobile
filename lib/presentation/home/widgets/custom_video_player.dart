import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final double? width;
  final double? height;

  const CustomVideoPlayer({
    super.key,
    required this.videoUrl,
    this.width,
    this.height,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _showControls = false;
  bool _hasInitializationError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  void _initializeVideoController() {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      _initializeVideoPlayerFuture = _controller.initialize().catchError((error) {
        debugPrint('Error initializing video: $error');
        if (mounted) {
          setState(() {
            _hasInitializationError = true;
          });
        }
        throw error;
      });
    } catch (e) {
      debugPrint('Error creating video controller: $e');
      if (mounted) {
        setState(() {
          _hasInitializationError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _retryInitialization() {
    setState(() {
      _hasInitializationError = false;
    });
    _controller.dispose();
    _initializeVideoController();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    
    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final videoWidth = widget.width ?? size.width;
    final videoHeight = widget.height ?? (videoWidth * 9 / 16);

    return Container(
      width: videoWidth,
      height: videoHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: _hasInitializationError 
            ? GestureDetector(
                onTap: _retryInitialization,
                child: _buildErrorWidget(),
              )
            : FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return _buildErrorWidget();
                    }
                    return _buildVideoPlayer(videoWidth, videoHeight);
                  } else {
                    return _buildLoadingWidget();
                  }
                },
              ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.videocam_off,
          size: 48.w,
          color: Colors.grey[600],
        ),
        SizedBox(height: 8.h),
        Text(
          'Video unavailable',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Tap to retry',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer(double videoWidth, double videoHeight) {
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          if (_showControls || !_controller.value.isPlaying)
            Container(
              width: videoWidth,
              height: videoHeight,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 32.w,
                    ),
                  ),
                ),
              ),
            ),
          if (_showControls)
            Positioned(
              bottom: 8.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  _formatDuration(_controller.value.duration),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 8.h,
            left: 8.w,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(
                Icons.videocam,
                color: Colors.white,
                size: 16.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}