import '../model/interest.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';
class InterestController{
  Interest? interests;

    Future listAllInterests() async{
    var url = Uri.parse(baseURL + '/interests/list');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: null
    );
    print(response.body);
    

    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    List<Interest> list = jsonList.map((e) => Interest.fromJsonToInterest(e)).toList();
    return list;
    }


  //   Future listInterestsByUser(String username)async {
  //   var url = Uri.parse(baseURL + '/interests/lists/$username');

  //   http.Response response = await http.post(url, headers: headers, body: null);
  //   List<Interest>? list;

  //   final utf8body = utf8.decode(response.bodyBytes);
  //   List<dynamic> jsonList = json.decode(utf8body);
  //   list = jsonList.map((e) => Interest.fromJsonToInterest(e)).toList();
  //   print("-------------------------------Search Interest user ${list}-----------------");
  //   return list;
  // }
    Future listInterestsByUser(String username) async {
    var url = Uri.parse(baseURL + '/interests/lists/${username}');

    http.Response response = await http.post(url, headers: headers, body: null);

    print("-------------------------------${response}-----------------");
    final utf8body = utf8.decode(response.bodyBytes);
    print("JSON received: $utf8body");
    List<dynamic> jsonList = json.decode(utf8body);
      print("---------------jsonList----------------${jsonList}-----------------");
    List<Interest>? list = await jsonList.map((e) => Interest.fromJsonToInterest(e)).toList();
    print("--------------list-----------------${list[0].interestId}-----------------");
    return list;
  }
}