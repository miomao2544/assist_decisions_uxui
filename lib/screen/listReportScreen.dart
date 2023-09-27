import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/controller/member_controller.dart';
import 'package:assist_decisions_app/controller/post_controller.dart';
import 'package:assist_decisions_app/controller/report_controller.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/model/report.dart';
import 'package:assist_decisions_app/screen/viewReportPostDetailScreen.dart';
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
      return formatter.format(date);
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



  Future fetchReport() async {
    List<Report> report;
    report = await reportController.getListReport();
        Member? member;
    member = await memberController.getMemberById(widget.username.toString());
    print(
        "object-----------------${report[0].reportComment.toString()}---------------------");
        
    print("-----------------${member!.nickname}---------------------");
    setState(() {
      member = member;
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
              title: Text("Logo ${widget.username}"),
              actions: [
                Row(
                  children: [
                    // ClipOval(
                    //     child: Image.network(
                    //   baseURL + '/members/downloadimg/${member!.image}',
                    //   fit: BoxFit.cover,
                    //   width: 36,
                    //   height: 36,
                    // )), // ไอคอนผู้ใช้ (หรือแสดงไอคอนของผู้ใช้ที่คุณต้องการ)
                    SizedBox(width: 4), // ระยะห่างระหว่างไอคอนกับข้อความผู้ใช้
                    Column(
                      children: [
                        Text("ชื่อบัญชี"),
                        Text(widget.username),
                      ],
                    ), // แสดงชื่อผู้ใช้ (หรือข้อมูลผู้ใช้ที่คุณต้องการ)
                    SizedBox(
                        width:
                            16), // ระยะห่างระหว่างข้อมูลผู้ใช้และข้อมูลอื่น ๆ ใน AppBar
                  ],
                ),
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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 160,
                                  height: 50,
                                  child: TextFormField(
                                    controller: postDateStopController,
                                    readOnly: true,
                                    onTap: () async {
                                      await _selectDateStop(context);
                                      String selectedDate =
                                          postDateStopController.text;
                                      postDateStopController.text =
                                          selectedDate; // อัปเดต TextField ด้วยวันที่ที่เลือก
                                      searchReportsByDate(selectedDate);
                                    },
                                    decoration: InputDecoration(
                                      counterText: "",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      prefixIcon: Icon(Icons.calendar_today),
                                      prefixIconColor: Colors.black,
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'Itim',
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 1270,
                      color: Colors.blue,
                      child: Center(
                        child: Stack(
                          alignment: Alignment
                              .center, // Center the Stack within the Container
                          children: [
                            Wrap(
                              children: reports?.map((report) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            10), // ปรับค่าตามที่คุณต้องการ
                                        child: Container(
                                          width: 300,
                                          height: 400,
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        '${formatDate(report.reportDate)}'),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    ClipOval(
                                                      child: Image.network(
                                                        baseURL +
                                                            '/members/downloadimg/${report.member!.image}',
                                                        fit: BoxFit.cover,
                                                        width: 36,
                                                        height: 36,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text('${report.post!.title}'),
                                                SizedBox(height: 10),
                                                Image.network(
                                                  baseURL +
                                                      '/posts/downloadimg/${report.post!.postImage}',
                                                  fit: BoxFit.cover,
                                                  width: 180,
                                                  height: 180,
                                                ),
                                                Text("เหตุผลที่รายงาน"),
                                                SizedBox(height: 10),
                                                Text(report.reportComment
                                                        .toString()
                                                        .isNotEmpty
                                                    ? report.reportComment
                                                        .toString()
                                                    : "ไม่มีข้อมูล"),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 150,
                                                    height: 40,
                                                    child: ElevatedButton.icon(
                                                      icon: Icon(
                                                          Icons.other_houses),
                                                      label: Text(
                                                        "เพิ่มเติม >",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                          Color(0xFF479f76),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                                     Navigator.push(context,
                                                            MaterialPageRoute(builder: (context) {
                                                          return ViewReportPostDetail(reportId:  report.reportId.toString(),username: widget.username,);
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
                    ),
                  ],
                ),
              ),
            ))
        : CircularProgressIndicator();
  }
}
