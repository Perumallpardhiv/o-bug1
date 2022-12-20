import 'dart:convert';
import 'package:http/http.dart' as http;

String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiJjMjBmYWVlNS0yZTdiLTQxZTAtYTNmNy01ZTFkZmUzMTBkZjIiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY3MTQ3OTY5MywiZXhwIjoxODI5MjY3NjkzfQ.dODfJStE8fZZ7hMUqForQXWEoR8aM8AxLtem9oIqlcc";

Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse("https://api.videosdk.live/v2/rooms"),
    headers: {'Authorization': token},
  );
  print(httpResponse.body);
  return json.decode(httpResponse.body)['roomId'];
}
