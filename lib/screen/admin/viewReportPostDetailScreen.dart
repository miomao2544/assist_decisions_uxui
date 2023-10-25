import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/classcontroller/choiceController.dart';
import 'package:assist_decisions_app/classcontroller/reportController.dart';
import 'package:assist_decisions_app/model/choice.dart';
import 'package:assist_decisions_app/model/report.dart';
import 'package:assist_decisions_app/screen/admin/ChangeBannedStatusScreen.dart';
import 'package:assist_decisions_app/screen/admin/ListReportPostScreen.dart';
import 'package:assist_decisions_app/screen/admin/listReportScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewReportPostDetail extends StatefulWidget {
  final String reportId;
  final String username;
  const ViewReportPostDetail({required this.reportId, required this.username});

  @override
  State<ViewReportPostDetail> createState() => _ViewReportPostDetailState();
}

class _ViewReportPostDetailState extends State<ViewReportPostDetail> {
  bool isDataLoaded = false;
  Report? reports;
  ReportController reportController = ReportController();
  ChoiceController choiceController = ChoiceController();

  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date.toLocal());
    }
    return '';
  }

  Future<List<Text>> getReportComments(Report report) async {
    List<String> reportComments = await reportController
        .getReportCommentByPost(report.post!.postId.toString());
    List<Text> textComments =
        reportComments.map((comment) => Text(comment)).toList();
    return textComments;
  }

  int? selectedChoiceIndex = 0;
  List<Choice>? choices = [];

  Future fetchReport() async {
    Report? report;
    List<Choice> choiceRequired;
    report = await reportController.doViewReportDetail(widget.reportId.toString());
    choiceRequired = await choiceController.listAllChoicesById(report!.post!.postId.toString());
    setState(() {
      reports = report;
      choices = choiceRequired;
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MainColor,
          title:                   Image.asset(
                    "assets/images/logo.png",
                    width: 60,
                  ),
        ),
        body: isDataLoaded == true
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            width: 600,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          "${formatDate(reports!.post!.dateStart.toString())} - ${formatDate(reports!.post!.dateStop.toString())}"),
                                      Text(
                                        "สั่งห้ามครั้งที่",
                                        style: TextStyle(
                                            color: MainColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "1",
                                        style: TextStyle(
                                            color: MainColor,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 250,
                                            child: Column(
                                              children: [
                                                Text(
                                                    reports!.post!.title
                                                        .toString(),
                                                    style: TextStyle(
                                                      overflow: TextOverflow
                                                              .ellipsis,
                                                        color: MainColor,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Image.network(
                                                  baseURL +
                                                      '/posts/downloadimg/${reports!.post!.postImage}',
                                                  fit: BoxFit.cover,
                                                  width: 180,
                                                  height: 180,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 250,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        reports!.post!.member!
                                                            .nickname
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: MainColor,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold)),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: SecondColor,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      child: ClipOval(
                                                        child: Image.network(
                                                          baseURL +
                                                              '/members/downloadimg/${reports!.post!.member!.image}',
                                                          fit: BoxFit.cover,
                                                          width: 36,
                                                          height: 36,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  reports!.post!.description
                                                      .toString(),
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text("คะแนน",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          reports!.post!.postPoint
                                                              .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text("จำนวนต่ำสุด",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            reports!.post!.qtyMin
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text("จำนวนสูงสุด",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                            reports!.post!.qtyMax
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                                             Container(
              
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: choices?.length ?? 0,
                              itemBuilder: (context, index) {
                                if (choices != null && choices!.isNotEmpty) {
                                  return Card(
                                    elevation: 2,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedChoiceIndex = index;
                                        });
                                      },
                                      child: ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (choices![index].choiceImage != null &&
                                                choices![index].choiceImage != "")
                                              Image.network(
                                                baseURL +
                                                    '/choices/downloadimg/${choices![index].choiceImage}',
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50,
                                              )
                                            else
                                              SizedBox(
                                                height: 50,
                                              ),
                                            Row(
                                              children: [
                                                Text(choices![index].choiceName ?? ""),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox(); // Or display some default content
                                }
                              },
                            ),
                          ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                              Text(
                                                "เหตุผลที่รายงาน",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),

                                            ListReportPostScreen(postId: reports!.post!.postId.toString()),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 150,
                                                  height: 40,
                                                  child: ElevatedButton.icon(
                                                    icon: Icon(Icons.report),
                                                    label: Text(
                                                      "สั่งห้าม",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                        MainColor,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return ChangeBannedStatusScreen(
                                                          reportId: reports!
                                                              .reportId
                                                              .toString(),
                                                          username:
                                                              widget.username,
                                                        );
                                                      }));
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 150,
                                                  height: 40,
                                                  child: ElevatedButton.icon(
                                                    icon: Icon(Icons.cancel),
                                                    label: Text(
                                                      "ยกเลิก",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                        Colors.red,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return ListReportScreen(
                                                          username:
                                                              widget.username,
                                                        );
                                                      }));
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
