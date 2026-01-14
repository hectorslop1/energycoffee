import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback? onComplete;

  const SplashPage({super.key, this.onComplete});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/images/SplashVideo.mp4');

    try {
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });

        _controller.setVolume(0.0);
        _controller.play();

        _controller.addListener(_videoListener);
      }
    } catch (e) {
      if (mounted) {
        await Future.delayed(const Duration(seconds: 2));
        widget.onComplete?.call();
      }
    }
  }

  void _videoListener() {
    if (!_hasCompleted) {
      final position = _controller.value.position;
      final duration = _controller.value.duration;

      if (duration.inMilliseconds > 0 && position >= duration) {
        _hasCompleted = true;
        _controller.removeListener(_videoListener);

        if (mounted) {
          widget.onComplete?.call();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isVideoInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }
}
