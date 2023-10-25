import 'dart:convert';
import 'package:assist_decisions_app/model/vote.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class VoteController{
  Vote? votes;
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

  Future getVoteByChoice(String choiceId) async{
    var url = Uri.parse(baseURL + '/votes/votechoice/${choiceId}');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: null
    );  
    String votes = "0";
    final utf8body = utf8.decode(response.bodyBytes); 
    votes = utf8body; 
    return votes;
    }

    Future getIFVoteChoice(String username,String postId) async{
    var url = Uri.parse(baseURL + '/votes/ifvote/${username}/${postId}');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: null
    );  
    String votes = "0";
    final utf8body = utf8.decode(response.bodyBytes); 
    votes = utf8body; 
    return votes;
    }

    Future getVoteChoice(String postId,String username) async{
    var url = Uri.parse(baseURL + '/votes/getvote/${postId}/${username}');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: null
    );  
    String votes = "";
    final utf8body = utf8.decode(response.bodyBytes); 
    votes = utf8body; 
    return votes;
    }
}
