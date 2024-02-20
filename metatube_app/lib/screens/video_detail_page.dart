import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetailsPage extends StatelessWidget {
  final String videoId;
  final String videoUrl;

  const VideoDetailsPage(
      {Key? key, required this.videoId, required this.videoUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Details'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VideoPlayerWidget(videoUrl: videoUrl),
            Text('Video ID: $videoId'),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late bool _isPlaying;
  late double _volume;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse('https://metatubeapi.onrender.com/${widget.videoUrl}'));

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _isPlaying = false;
    _volume = _controller.value.volume;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.red,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                        _isPlaying = !_isPlaying;
                      });
                    },
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 48,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_controller.value.volume == 0) {
                          _controller.setVolume(_volume);
                        } else {
                          _volume = _controller.value.volume;
                          _controller.setVolume(0);
                        }
                      });
                    },
                    icon: Icon(_controller.value.volume == 0
                        ? Icons.volume_off
                        : Icons.volume_up),
                    iconSize: 48,
                  ),
                ],
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
