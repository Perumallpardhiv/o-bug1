import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:o_health/theme_config/theme_config.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../auth/login.dart';

class InitialIntroVideo extends StatefulWidget {
  const InitialIntroVideo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InitialIntroVideoState createState() => _InitialIntroVideoState();
}

class _InitialIntroVideoState extends State<InitialIntroVideo> {
  final introKey = GlobalKey<IntroductionScreenState>();
  Box box = Hive.box('data');

  late Future<void> _initalizeVideoPlayer;

  late VideoPlayerController _playerController;
  @override
  void initState() {
    _playerController = VideoPlayerController.asset('assets/intro/4.mkv');
    _initalizeVideoPlayer = _playerController.initialize();
    _playerController.setLooping(true);
    _playerController.setVolume(1.0);
    // _playerController.initialize().then((value) {
    //   setState(() {});
    // });
    // _playerController.addListener(routeToLoginOnEnd);
    _playerController.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          FutureBuilder(
              future: _initalizeVideoPlayer,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: MediaQuery.of(context).size.width /
                        MediaQuery.of(context).size.height,
                    child: VisibilityDetector(
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction == 0) {
                          _playerController.dispose();
                        }
                      },
                      key: UniqueKey(),
                      child: VideoPlayer(
                        _playerController,
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          Positioned(
            bottom: 10,
            right: 8,
            child: GestureDetector(
              onTap: () {
                box.put('isIntroSeen', true);
                _playerController.removeListener(routeToLoginOnEnd);
                _playerController.pause();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (Route<dynamic> route) => false);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.red,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Skip',
                        style: ThemeConfig.textStyle,
                      ),
                      const Icon(
                        Icons.arrow_right_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _playerController.pause();
    _playerController.dispose();
  }

  routeToLoginOnEnd() {
    if (_playerController.value.isInitialized &&
        (_playerController.value.position ==
            _playerController.value.duration)) {
      _playerController.removeListener(routeToLoginOnEnd);
      _playerController.pause();
      box.put('isIntroSeen', true);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (Route<dynamic> route) => false);
    }
  }
}
