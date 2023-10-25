import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class VotePostController{
    Future doVotePost(String username,String choiceId) async {
    Map data = {
      "username": username,
      "choiceId": choiceId,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/votes/add');
    http.Response response = await http.post(url, headers: headers, body: body);
    print(response.body);
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
}