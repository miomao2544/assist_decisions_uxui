import 'dart:convert';
import 'package:assist_decisions_app/model/report.dart';
import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';

class ReportController {
  Report? report;


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

  Future doViewReportDetail(String reportId) async {
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

  Future getReportCommentByPost(String postId) async {
    var url = Uri.parse(baseURL + '/reports/comments/$postId');
    http.Response response = await http.post(url, headers: headers, body: null);
    List<String>? list;
    final utf8body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonList = json.decode(utf8body);
    list = jsonList.map((item) => item.toString()).toList();
    return list;
  }

  Future getListReportByPost(String postId) async {
    var url = Uri.parse(baseURL + '/reports/list/${postId}');

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


Future<String> getReportCountByPost(String postId) async {
  var url = Uri.parse(baseURL + '/reports/count/$postId');
http.Response response = await http.post(
      url,
      headers: headers,
      body: null
    );  
    String counts = "1";
    final utf8body = utf8.decode(response.bodyBytes); 
    counts = utf8body; 
    return counts;
}
}
