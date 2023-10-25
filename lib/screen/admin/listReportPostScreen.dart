import 'package:assist_decisions_app/classcontroller/reportController.dart';
import 'package:assist_decisions_app/constant/constant_value.dart';

import 'package:assist_decisions_app/model/report.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../widgets/colors.dart';

class ListReportPostScreen extends StatefulWidget {
  final String postId;
  const ListReportPostScreen({required this.postId});

  @override
  State<ListReportPostScreen> createState() => _ListReportPostScreenState();
}

class _ListReportPostScreenState extends State<ListReportPostScreen> {
  List<Report>? reportList;
  bool isDataLoaded = false;
  ReportController listReportPostsController = ReportController();

  Future fetchReport() async {
    List<Report> reports;
    reports =
        await listReportPostsController.getListReport(widget.postId.toString());
    setState(() {
      reportList = reports;
      isDataLoaded = true;
    });
  }

  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date.toLocal());
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    fetchReport();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          isDataLoaded
              ? reportList!.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reportList!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(
                                    16), // Padding inside the ListTile.
                                leading: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: SecondColor,
                                      width: 4.0,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      baseURL +
                                          '/members/downloadimg/${reportList![index].member!.image.toString()}',
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "${reportList![index].member!.nickname.toString()}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                subtitle: Text(
                                  reportList![index].reportComment == null ||
                                          reportList![index]
                                              .reportComment
                                              .toString()
                                              .isEmpty
                                      ? "ไม่มีเหตุผลที่รายงาน"
                                      : reportList![index]
                                          .reportComment
                                          .toString(),
                                  style: TextStyle(fontSize: 16),
                                ),
                                isThreeLine:
                                    true, // Makes the subtitle take up the full width.
                                trailing: Text(
                                  formatDate(reportList![index].reportDate),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    )
                  : Text("ไม่มีรายงาน")
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
