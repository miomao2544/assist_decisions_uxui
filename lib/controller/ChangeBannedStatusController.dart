
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class ChangeBannedStatusController{
    Future doBanStatus(String banComment, String banTypeId, String username) async {
    Map data = {
      "banComment": banComment,
      "banTypeId": banTypeId,
      "username": username,
    };

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/historys/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    print(response.body);
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
}