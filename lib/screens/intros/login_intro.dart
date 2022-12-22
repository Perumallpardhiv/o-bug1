import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:o_health/screens/home.dart';
import 'package:o_health/theme_config/theme_config.dart';
import 'package:video_player/video_player.dart';

class LoginIntroVideo extends StatefulWidget {
  const LoginIntroVideo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginIntroVideoState createState() => _LoginIntroVideoState();
}

class _LoginIntroVideoState extends State<LoginIntroVideo> {
  final introKey = GlobalKey<IntroductionScreenState>();
  Box box = Hive.box('data');

  late VideoPlayerController _playerController;
  @override
  void initState() {
    _playerController = VideoPlayerController.asset('assets/intro/intro.mp4');
    _playerController.initialize().then((value) {
      setState(() {});
    });
    _playerController.addListener(routeToHome);
    _playerController.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: MediaQuery.of(context).size.width /
                MediaQuery.of(context).size.height,
            child: VideoPlayer(_playerController),
          ),
          Positioned(
            bottom: 10,
            right: 8,
            child: GestureDetector(
              onTap: () {
                box.put('isLoginIntroSeen', true);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Home()),
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

  routeToHome() {
    if (_playerController.value.isInitialized &&
        (_playerController.value.position ==
            _playerController.value.duration)) {
      _playerController.removeListener(routeToHome);
      box.put('isLoginIntroSeen', true);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Home()),
          (Route<dynamic> route) => false);
    }
  }
}
