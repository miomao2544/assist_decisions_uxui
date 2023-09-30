import 'package:assist_decisions_app/controller/reportController.dart';
import 'package:assist_decisions_app/screen/vote/viewPostScreen.dart';
import 'package:assist_decisions_app/widgets/PostInfoWidget.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:assist_decisions_app/widgets/divider_box.dart';
import 'package:flutter/material.dart';
import 'package:assist_decisions_app/controller/choiceController.dart';
import 'package:assist_decisions_app/controller/memberController.dart';
import 'package:assist_decisions_app/controller/postController.dart';
import 'package:assist_decisions_app/model/choice.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:intl/intl.dart';
import '../../constant/constant_value.dart';
import '../../model/post.dart';

class ReportPostScreen extends StatefulWidget {
  final String postId;
  final String username;
  const ReportPostScreen({required this.postId, required this.username});

  @override
  State<ReportPostScreen> createState() => _ReportPostScreenState();
}

class _ReportPostScreenState extends State<ReportPostScreen> {
  Post? post;
  List<Choice>? choices = [];
  Member? member;
  int? selectedChoiceIndex;
  bool? isDataLoaded = false;
  String? reportComment = "";
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  ChoiceController choiceController = ChoiceController();
  PostController postController = PostController();
  MemberController memberController = MemberController();
  ReportController reportController = ReportController();
  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date.toLocal());
    }
    return '';
  }

  int counts = 0;
  Future<void> fetchPost() async {
    Post? postRequired;
    List<Choice> choiceRequired;
    Member? memberRequired;
    postRequired = await postController.getPostById(widget.postId);
    choiceRequired = await choiceController.listAllChoicesById(widget.postId);
    memberRequired = await memberController.getMemberById(widget.username);
    counts = await postController.getListCountMember(widget.postId);
    print(
        "---------------${widget.postId.toString()}--------------${counts}----------------");
    setState(() {
      post = postRequired;
      choices = choiceRequired;
      member = memberRequired;
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MainColor,
          title: Text(
              "${formatDate(post?.dateStart)} - ${formatDate(post?.dateStop)}"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: isDataLoaded == true
            ? SizedBox(
                child: Container(
                  height: double.infinity,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('${post?.title ?? ""}',
                                style: TextStyle(fontSize: 30)),
                            SizedBox(
                              height: 20,
                            ),
                            Image.network(
                              baseURL + '/posts/downloadimg/${post?.postImage}',
                              fit: BoxFit.cover,
                              width: 250,
                              height: 250,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(' ${post?.description ?? ""}'),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                PostInfoWidget(
                                  title: "คะแนน",
                                  value: "${post?.postPoint?.toInt()}",
                                ),
                                PostInfoWidget(
                                  title: "จำนวนต่ำสุด",
                                  value: "${post?.qtyMin}",
                                ),
                                PostInfoWidget(
                                  title: "จำนวนสูงสุด",
                                  value: "${post?.qtyMax}",
                                ),
                                PostInfoWidget(
                                  title: "จำนวนผู้โหวต",
                                  value: counts.toString(),
                                ),
                              ],
                            ),
                            DividerBoxBlack(),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: choices?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 2,
                                  shape: Border.all(
                                    color: selectedChoiceIndex == index
                                        ? SecondColor
                                        : MainColor,
                                    width: 2,
                                  ),
                                  child: RadioListTile<int>(
                                    value: index,
                                    groupValue: selectedChoiceIndex,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedChoiceIndex = value;
                                      });
                                    },
                                    activeColor: SecondColor,
                                    title: Row(
                                      children: [
                                        choices![index].choiceImage != ""
                                            ? Image.network(
                                                baseURL +
                                                    '/choices/downloadimg/${choices![index].choiceImage}',
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50,
                                              )
                                            : SizedBox(width: 2, height: 50),
                                        Text(choices![index].choiceName ?? ""),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Container(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Form(
                                          key: fromKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
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
                                                        '/members/downloadimg/${post?.member?.image}',
                                                    fit: BoxFit.cover,
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 16.0),
                                              Text(
                                                "รายงานคุณ ${post!.member!.nickname}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              SizedBox(height: 8.0),
                                              Container(
                                                width: 300,
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    labelText: 'รายงาน',
                                                    labelStyle: TextStyle(
                                                        color: MainColor),
                                                  ),
                                                  maxLines: null,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      reportComment = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: 120,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await reportController
                                                        .doReportPost(
                                                      reportComment.toString(),
                                                      widget.postId.toString(),
                                                      widget.username.toString(),
                                                    );
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return ViewPostScreen(
                                                        postId: widget.postId
                                                            .toString(),
                                                        username: widget.username
                                                            .toString(),
                                                      );
                                                    }));
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    primary: MainColor
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                          Icons.report_problem,
                                                          color: Colors.white),
                                                          SizedBox(width: 5,),
                                                          Text("รายงาน",style: TextStyle(fontWeight: FontWeight.bold),)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
