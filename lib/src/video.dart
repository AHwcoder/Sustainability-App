import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late final VideoPlayerController _video;
  ChewieController? _chewie;

  @override
  void initState() {
    super.initState();
    _video = VideoPlayerController.asset('assets/111.mp4');
    _video.initialize().then((_) {
      _chewie = ChewieController(
        videoPlayerController: _video,
        autoPlay: false,
        looping: false,
        allowPlaybackSpeedChanging: true,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _chewie?.dispose();
    _video.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ready = _chewie != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sustainability Video'),
      ),
      body: Center(
        child: ready
            ? AspectRatio(
                aspectRatio: _video.value.aspectRatio,
                child: Chewie(controller: _chewie!),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
