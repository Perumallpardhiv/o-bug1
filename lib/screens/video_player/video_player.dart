import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String videoURL;
  const VideoScreen({super.key, required this.videoURL});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoURL)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    _controller.play();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          VideoProgressIndicator(_controller, allowScrubbing: true),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    _controller.play();
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.play_circle,
                        // color: Colors.amberAccent,
                        size: 42,
                      ),
                      Text('Play')
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    _controller.pause();
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.pause_circle,
                        // color: Colors.redAccent,
                        size: 42,
                      ),
                      Text('Stop')
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
