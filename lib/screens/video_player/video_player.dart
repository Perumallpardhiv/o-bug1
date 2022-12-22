import 'package:flutter/material.dart';
import 'package:o_health/screens/video_call/video_call.dart';
import 'package:video_player/video_player.dart';

import '../../methods/methods.dart';

// ignore: must_be_immutable
class VideoScreen extends StatefulWidget {
  final String videoURL;
  final bool redirect;
  String? docID;
  VideoScreen({
    super.key,
    required this.videoURL,
    this.docID,
    required this.redirect,
  });

  @override
  // ignore: library_private_types_in_public_api
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
    _controller.play();
    _controller.addListener(navigateToCallOnEnd);
  }

  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
            child: IconButton(
              icon: Icon(isPaused ? Icons.play_arrow_rounded : Icons.pause),
              onPressed: () {
                setState(() {
                  isPaused ? _controller.play() : _controller.pause();
                  isPaused = !isPaused;
                });
              },
            ),
          ),
          isPaused ? const Text('Play') : const Text('Pause'),
        ],
      ),
    );
  }

  navigateToCallOnEnd() async {
    if (_controller.value.isInitialized &&
        (_controller.value.position == _controller.value.duration)) {
      if (widget.redirect) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return CallInvitationScreen(docID: widget.docID!);
            },
          ),
        );
      } else {
        showSnackBar(context, true, 'No doctor available at the moment');
      }
      _controller.removeListener(navigateToCallOnEnd);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
