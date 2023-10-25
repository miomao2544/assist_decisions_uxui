
import 'package:assist_decisions_app/model/historyBan.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class HistoryBanController {
Future<HistoryBan> getHistoryUser(String username) async {
  var url = Uri.parse(baseURL + '/historys/get/${username}');

  http.Response response = await http.post(url, headers: headers, body: null);

  print("-------------------------------${response}-----------------");
  
  final utf8Body = utf8.decode(response.bodyBytes);
  Map<String, dynamic> jsonMap = json.decode(utf8Body);

  HistoryBan historyBan = HistoryBan.fromJsonToHistoryBan(jsonMap);

  return historyBan;
}
}
