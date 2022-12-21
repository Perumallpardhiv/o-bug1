class AudioResponse {
  final String videoURL;
  final bool redirectToVideoCall;
  String? doctorName;
  String? doctorID;

  AudioResponse({
    required this.redirectToVideoCall,
    required this.videoURL,
    this.doctorID,
    this.doctorName,
  });

  factory AudioResponse.fromJson(json) {
    return AudioResponse(
      redirectToVideoCall: json['redirectToVideoCall'],
      videoURL: json['videoURL'],
      doctorID: json['doctorID'],
      doctorName: json['doctorName'],
    );
  }
}
