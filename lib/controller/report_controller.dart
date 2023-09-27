import 'dart:convert';
import 'package:assist_decisions_app/model/report.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class ReportController{
  Report? report;
  Future doReportPost(String reportComment,String postId,String username) async {
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

  Future getListReport() async {
    var url = Uri.parse(baseURL + '/reports/list');

    http.Response response = await http.post(url, headers: headers, body: null);
    List<Report>? list;
    print(response.body);
    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((e) => Report.fromJsonToReport(e)).toList();
    print("--------------------------${list[0].reportId}----------------------------------");
    return list;
  }

    Future<Report?> doViewReportDetail(String reportId) async {
    try {
      var url = Uri.parse(baseURL + '/reports/getReportById/$reportId');
      http.Response response =
          await http.post(url, headers: headers, body: null);
      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonMap = json.decode(utf8Body);
        Report? report = Report.fromJsonToReport(jsonMap);
        return report;
      }
    } catch (error) {
      print("เกิดข้อผิดพลาดในการเชื่อมต่อ: $error");
      return null;
    }
  }
}
