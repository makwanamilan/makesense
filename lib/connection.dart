import 'package:http/http.dart' as http;

class Connection {

  Future<http.Response> events(eventsUrl) async {
    print(eventsUrl);
    return http.get(eventsUrl);
  }




}