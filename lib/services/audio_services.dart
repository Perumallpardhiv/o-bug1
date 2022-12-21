import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:mime/mime.dart';
import 'package:o_health/models/audio_resp.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AudioServices {
  static var rec = Record();

  static getPath() async {
    // todo generate random file name
    var rnd = Random();
    String name = '${rnd.nextInt(100000)}+${DateTime.now()}';
    return '${(await getApplicationDocumentsDirectory()).path}/$name.wav';
  }

  start() async {
    var path = await await getPath();
    await rec.start(path: path, encoder: AudioEncoder.wav);
  }

  stop() async {
    String savePath = (await rec.stop())!;
    return savePath;
  }

  sendAudioFile(File waveFile, String localeCode) async {
    Box box = Hive.box('data');
    String userAadharNumber = box.get('userData')['aadhar'];
    var uri = Uri.parse('https://health-conscious.in/api/voicesearch/data');
    final mimeTypeData =
        lookupMimeType(waveFile.path, headerBytes: [0xFF, 0xD8])!.split('/');

    // Initialize the multipart request
    final audioUploadRequest = http.MultipartRequest('POST', uri);
    audioUploadRequest.fields['directoryName'] =
        waveFile.path.split(Platform.pathSeparator).last;
    audioUploadRequest.fields['user_aadhar_number'] = userAadharNumber;
    audioUploadRequest.fields['language'] = localeCode;

    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('audio-file', waveFile.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    audioUploadRequest.files.add(file);

    // add headers if needed
    //audioUploadRequest.headers.addAll(<some-headers>);

    try {
      final streamedResponse = await audioUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      return jsonDecode(response.body);
    } catch (err) {
      return null;
    }
  }
}
