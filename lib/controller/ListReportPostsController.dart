
import 'dart:convert';
import 'package:assist_decisions_app/model/report.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';
class ListReportPostsController{
  Future getListReport() async {
    var url = Uri.parse(baseURL + '/reports/list');

    http.Response response = await http.post(url, headers: headers, body: null);
    List<Report>? list;
    print(response.body);
    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((e) => Report.fromJsonToReport(e)).toList();
    print(
        "--------------------------${list[0].reportId}----------------------------------");
    return list;
  }
}