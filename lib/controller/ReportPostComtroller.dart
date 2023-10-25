import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class ReportPostController{
    Future doReportPost(
      String reportComment, String postId, String username) async {
    Map data = {
      "reportComment": reportComment,
      "postId": postId,
      "username": username,
    };

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/reports/add');

    http.Response response = await http.post(url, headers: headers, body: body);
    print(response.body);
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
}