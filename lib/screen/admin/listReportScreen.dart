import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/classcontroller/memberController.dart';
import 'package:assist_decisions_app/classcontroller/reportController.dart';
import 'package:assist_decisions_app/controller/ListReportPostsController.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:assist_decisions_app/model/report.dart';
import 'package:assist_decisions_app/screen/admin/viewReportPostDetailScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListReportScreen extends StatefulWidget {
  final String username;
  const ListReportScreen({required this.username});

  @override
  State<ListReportScreen> createState() => _ListReportScreenState();
}

class _ListReportScreenState extends State<ListReportScreen> {
  String search = "";
  bool isDataLoaded = false;
  List<Report>? reports = [];
  Member? member;
  ListReportPostsController listReportPostsController =
      ListReportPostsController();
  ReportController reportController = ReportController();
  TextEditingController postDateStopController = TextEditingController();

  MemberController memberController = MemberController();
  String? dateStops = "";
  Future<void> _selectDateStop(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate.subtract(Duration(days: 365)),
      lastDate: currentDate.add(Duration(days: 365)),
    );

    if (selectedDate != null && selectedDate != currentDate) {
      String formattedDate =
          "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString().padLeft(4, '0')}";
      postDateStopController.text = formattedDate;
      print(postDateStopController.text);
      String formattedDate2 =
          "${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')} ${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}:${selectedDate.second.toString().padLeft(2, '0')}";
      dateStops = formattedDate2;
    }
  }

  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date.toLocal());
    }
    return '';
  }

  void searchReportsByDate(String? selectedDate) {
    if (selectedDate == null || selectedDate.isEmpty) {
      fetchReport();
      setState(() {
        reports = reports; // originalReports เป็นรายการรายงานทั้งหมด
      });
    } else {
      // ถ้ามีวันที่ที่เลือกให้กรองรายงานที่มีวันที่ตรงกับที่เลือก
      final filteredReports = reports!.where((report) {
        final reportDate =
            formatDate(report.reportDate); // ปรับรูปแบบวันที่เพื่อเปรียบเทียบ
        return reportDate == selectedDate;
      }).toList();
      setState(() {
        reports = filteredReports;
      });
    }
  }

  Future<List<Text>> getReportComments(Report report) async {
    List<String> reportComments = await reportController
        .getReportCommentByPost(report.post!.postId.toString());
    List<Text> textComments =
        reportComments.map((comment) => Text(comment)).toList();
    return textComments;
  }

  void searchReports(String searchKeyword) {
    if (searchKeyword.isEmpty && searchKeyword == "") {
      fetchReport();
      setState(() {
        reports = reports; // originalReports เป็นรายการรายงานทั้งหมด
      });
    } else {
      // ถ้ามีคำค้นหาให้กรองรายงานที่มี post.title ที่ตรงกับคำค้นหา
      final filteredReports = reports!.where((report) {
        final postTitle = report.post?.title ?? "";
        return postTitle.toLowerCase().contains(searchKeyword.toLowerCase());
      }).toList();
      setState(() {
        reports = filteredReports;
      });
    }
  }

  List<String> counts = [];
  Future fetchReport() async {
    List<Report> report;
    report = await listReportPostsController.getListReport();
    Member? members;
    members = await memberController.getMemberById(widget.username.toString());
    print(
        "object-----------------${report[0].reportComment.toString()}---------------------");

    print("-----------------${members!.nickname}---------------------");
    for (int i = 0; i < report.length; i++) {
      String reportCounts = await reportController
          .getReportCountByPost(report[i].post!.postId.toString());
      counts.add(reportCounts);
      print("object------${reportCounts}");
    }
    setState(() {
      member = members;
      reports = report;
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
    return isDataLoaded
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: MainColor,
              title: Image.asset(
                "assets/images/logo.png",
                width: 60,
              ),
              actions: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // สีพื้นหลังสีขาว
                    borderRadius:
                        BorderRadius.circular(10.0), // การกำหนดมุมโค้ง
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        member != null
                            ? Container(
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
                                        '/members/downloadimg/${member?.image}',
                                    fit: BoxFit.cover,
                                    width: 36,
                                    height: 36,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                            width: 10), // ระยะห่างระหว่างไอคอนกับข้อความผู้ใช้
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // ชิดซ้าย
                          children: [
                            SizedBox(height: 2),
                            Text(
                              "ชื่อบัญชี",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              member!.nickname.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ), // แสดงชื่อผู้ใช้ (หรือข้อมูลผู้ใช้ที่คุณต้องการ)
                        SizedBox(
                          width: 16,
                        ), // ระยะห่างระหว่างข้อมูลผู้ใช้และข้อมูลอื่น ๆ ใน AppBar
                      ],
                    ),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 600,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 200.0,
                                    height: 50.0,
                                    child: TextField(
                                      onChanged: (value) {
                                        search = value;
                                        searchReports(search);
                                      },
                                      decoration: InputDecoration(
                                        hintText: "ค้นหาโพสต์...",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    fetchReport();
                                  },
                                  child: Container(
                                    width: 48.0,
                                    height: 48.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: MainColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 10,
                                ),
                                // SizedBox(
                                //   width: 160,
                                //   height: 50,
                                //   child: TextFormField(
                                //     controller: postDateStopController,
                                //     readOnly: true,
                                //     onTap: () async {
                                //       await _selectDateStop(context);
                                //       String selectedDate =
                                //           postDateStopController.text;
                                //       postDateStopController.text =
                                //           selectedDate;
                                //       searchReportsByDate(selectedDate);
                                //     },
                                //     decoration: InputDecoration(
                                //       counterText: "",
                                //       border: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(10),
                                //       ),
                                //       prefixIcon: Icon(Icons.calendar_today),
                                //       prefixIconColor: MainColor,
                                //     ),
                                //     style: TextStyle(
                                //       fontFamily: 'Itim',
                                //       fontSize: 18,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    reports!.length != 0
                        ? Container(
                            width: 1270,
                            child: Center(
                              child: Stack(
                                alignment: Alignment
                                    .center, // Center the Stack within the Container
                                children: [
                                  Wrap(
                                    children: reports
                                            ?.asMap()
                                            .entries
                                            .map((entry) {
                                          final int index = entry.key;
                                          final Report report = entry.value;
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                  10), // ปรับค่าตามที่คุณต้องการ
                                              child: Container(
                                                width: 300,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: SecondColor
                                                          .withOpacity(0.8),
                                                      spreadRadius: 10,
                                                      blurRadius: 10,
                                                      offset: Offset(10, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 80,
                                                          ),
                                                          Text(
                                                              '${formatDate(report.reportDate)}'),
                                                          SizedBox(
                                                            width: 60,
                                                          ),
                                                          Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  SecondColor, // สีที่ต้องการ
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0), // ความโค้งของวงกลม (15.0 คือความกว้างของ Container และความสูงของ Container หาร 2)
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                "${counts[index]}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Text(
                                                        '${report.post!.title}',
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            color: MainColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Image.network(
                                                        baseURL +
                                                            '/posts/downloadimg/${report.post!.postImage}',
                                                        fit: BoxFit.cover,
                                                        width: 180,
                                                        height: 180,
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        "เหตุผลที่รายงาน",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        report.reportComment !=
                                                                    null &&
                                                                report
                                                                    .reportComment
                                                                    .toString()
                                                                    .isNotEmpty
                                                            ? report
                                                                .reportComment
                                                                .toString()
                                                            : "ไม่มีข้อมูล",
                                                        style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      // Container(
                                                      //   child: FutureBuilder<
                                                      //       List<Text>>(
                                                      //     future:
                                                      //         getReportComments(
                                                      //             report),
                                                      //     // ต้องกำหนด report ให้กับตัวแปรนี้
                                                      //     builder: (context,
                                                      //         snapshot) {
                                                      //       if (snapshot
                                                      //               .connectionState ==
                                                      //           ConnectionState
                                                      //               .waiting) {
                                                      //         return CircularProgressIndicator(); // หรือใดๆ ก็ได้เพื่อแสดงว่าข้อมูลกำลังโหลด
                                                      //       } else if (snapshot
                                                      //           .hasError) {
                                                      //         return Text(
                                                      //             'Error: ${snapshot.error}');
                                                      //       } else if (snapshot
                                                      //           .hasData) {
                                                      //         List<Text>
                                                      //             commentTexts =
                                                      //             snapshot
                                                      //                 .data!;
                                                      //         return ListView
                                                      //             .builder(
                                                      //           shrinkWrap:
                                                      //               true,
                                                      //           itemCount:
                                                      //               commentTexts
                                                      //                   .length,
                                                      //           itemBuilder:
                                                      //               (context,
                                                      //                   index) {
                                                      //             return commentTexts[
                                                      //                 index];
                                                      //           },
                                                      //         );
                                                      //       } else {
                                                      //         return Text(
                                                      //             'No data available');
                                                      //       }
                                                      //     },
                                                      //   ),
                                                      // ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          width: 150,
                                                          height: 40,
                                                          child: ElevatedButton
                                                              .icon(
                                                            icon: Icon(Icons
                                                                .other_houses),
                                                            label: Text(
                                                              "เพิ่มเติม",
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all<
                                                                          Color>(
                                                                SecondColor,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                                return ViewReportPostDetail(
                                                                  reportId: report
                                                                      .reportId
                                                                      .toString(),
                                                                  username: widget
                                                                      .username,
                                                                );
                                                              }));
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList() ??
                                        [],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Text("ยังไม่มีรายงาน"),
                  ],
                ),
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
