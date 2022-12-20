import 'package:flutter/material.dart';
import 'package:o_health/screens/video_call/api.dart';
import 'package:o_health/screens/video_call/join_screen.dart';
import 'package:o_health/screens/video_call/meeting_screen.dart';

class VideoSDKQuickStart extends StatefulWidget {
  const VideoSDKQuickStart({Key? key}) : super(key: key);

  @override
  State<VideoSDKQuickStart> createState() => _VideoSDKQuickStartState();
}

class _VideoSDKQuickStartState extends State<VideoSDKQuickStart> {
  String meetingId = "";
  bool isMeetingActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VideoSDK QuickStart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isMeetingActive
            ? MeetingScreen(
                meetingId: meetingId,
                token: token,
                leaveMeeting: () {
                  setState(() => isMeetingActive = false);
                },
              )
            : JoinScreen(
                onMeetingIdChanged: (value) => meetingId = value,
                onCreateMeetingButtonPressed: () async {
                  meetingId = await createMeeting();
                  setState(() => isMeetingActive = true);
                },
                onJoinMeetingButtonPressed: () {
                  setState(() => isMeetingActive = true);
                },
              ),
      ),
    );
  }
}
