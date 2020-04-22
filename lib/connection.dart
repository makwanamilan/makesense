import 'package:http/http.dart' as http;

class Connection {

  Future<http.Response> events(eventsUrl) async {
    print(eventsUrl);
    return http.get(eventsUrl);
  }

  Future<http.Response> updateToken(request) async{
    print(request);
    return http.get(request);
  }
  Future<http.Response> views(request) async{
    print(request);
    return http.get(request);
  }





}