import 'package:assist_decisions_app/classcontroller/choiceController.dart';
import 'package:assist_decisions_app/classcontroller/memberController.dart';
import 'package:assist_decisions_app/classcontroller/postController.dart';
import 'package:assist_decisions_app/classcontroller/reportController.dart';
import 'package:assist_decisions_app/controller/VotePostController.dart';
import 'package:assist_decisions_app/controller/viewPostController.dart';
import 'package:assist_decisions_app/classcontroller/voteController.dart';
import 'package:assist_decisions_app/model/choice.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:assist_decisions_app/model/report.dart';
import 'package:assist_decisions_app/screen/vote/CommentPostScreen.dart';
import 'package:assist_decisions_app/screen/vote/ReportPostScreen.dart';
import 'package:assist_decisions_app/screen/vote/homeScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constant/constant_value.dart';
import '../../model/post.dart';
import '../../widgets/PostInfoWidget.dart';
import '../../widgets/divider_box.dart';

class ViewPostScreen extends StatefulWidget {
  final String postId;
  final String username;
  const ViewPostScreen({required this.postId, required this.username});

  @override
  State<ViewPostScreen> createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  Post? post;
  List<Choice>? choices = [];
  Member? member;
  int? selectedChoiceIndex = 0;
  bool? isDataLoaded = false;
  ChoiceController choiceController = ChoiceController();
  PostController postController = PostController();
  ViewPostController viewPostController = ViewPostController();
  MemberController memberController = MemberController();
  VoteController voteController = VoteController();
  VotePostController votePostController =VotePostController();
  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date.toLocal());
    }
    return '';
  }

 String votePost = "";
  int counts = 0;
  String ifvote = "";
  List<String> usernames = [];
  Future<void> fetchPost() async {
    Post? postRequired;
    List<Choice> choiceRequired;
    Member? memberRequired;
    List<String> username = [];
    String voteChoice;

    

    postRequired = await viewPostController.getPostById(widget.postId);
    choiceRequired = await choiceController.listAllChoicesById(widget.postId);
    memberRequired = await memberController.getMemberById(widget.username);
    counts = await postController.getListCountMember(widget.postId);
    ifvote =
        await voteController.getIFVoteChoice(widget.username, widget.postId);
    voteChoice = await voteController.getVoteChoice(widget.postId, widget.username);
    int i;
    for (i = 0; i < choiceRequired.length; i++) {
      if (choiceRequired[i].choiceName == voteChoice) {
        selectedChoiceIndex = i;
      }
    }
    print(
        "---------------${widget.postId.toString()}--------------${ifvote}----------------");
    username = await memberController.getUsernameVotePost(widget.postId);
    print(
        "---------------${widget.postId.toString()}--------------${voteChoice.toString()}----------------");
    setState(() {
      post = postRequired;
      choices = choiceRequired;
      member = memberRequired;
      votePost = voteChoice;
          print(
        "---------------${widget.postId.toString()}--------------${votePost.toString()}----------------");
      usernames = List<String>.from(username);
      calculateScorepoint();
      ifreport();
      isDataLoaded = true;
    });
  }
    bool isResult = true;
ReportController reportController = ReportController();
  Future ifreport() async {
    List<Report> reports =await reportController.getListReport(widget.postId.toString());

    print("-------------${isResult}-----------");
    setState(() {
          for(int i = 0;i<reports.length;i++){
      if(reports[i].member!.username.toString() == widget.username.toString()){
        isResult = false;
        break;
      }
    }
    });
  }

  Future calculateScorepoint() async {
  if ((post!.qtyMax == counts) ||
      (post!.qtyMin != null &&
          post!.qtyMin! >= counts &&
          post!.dateStop != null &&
          DateTime.parse(post!.dateStop!).isBefore(DateTime.now()))) {
    double score = double.parse(post!.postPoint.toString());
    int qtyMax = counts;
      int scorepoint = (score / qtyMax).toInt();
      print("----------point--${scorepoint}-------");
      await postController.doUpdateResult("1", post!.postId.toString());
      for (int i = 0; i < usernames.length; i++) {
        print(
            "---------------${scorepoint.toString()}-------Vote<<<-------------");
        await memberController.doUpdatePointVote(
            usernames[i].toString(), post!.avgPoint.toString());
      }
      

  }
}

  Future ShowVoteDrialog() => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: 290,
              height: 500,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 180,
                  ),
                  Text(
                    "ยืนยันการโหวต",
                    style: TextStyle(fontSize: 25.0, fontFamily: 'Light'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "คุณต้องการเลือกตัวเลือกที่",
                    style: TextStyle(fontFamily: 'Light'),
                  ),
                  Text(
                    "${selectedChoiceIndex! + 1}",
                    style: TextStyle(fontSize: 35, fontFamily: 'Light'),
                  ),
                  Text(
                    "ใช่หรือไม่",
                    style: TextStyle(fontFamily: 'Light'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "เมื่อกดยืนกันแล้วจะไม่เปลี่ยนแปลง\nคำตอบภายหลังได้",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Light',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await votePostController.doVotePost(
                          widget.username.toString(),
                          choices![selectedChoiceIndex!].choiceId.toString());
                      await voteController.getIFVoteChoice(
                          widget.username, widget.postId);
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ViewPostScreen(
                          username: widget.username,
                          postId: post!.postId.toString(),
                        );
                      }));
                    },
                    child: Text(
                      "ตกลง",
                      style: TextStyle(fontFamily: 'Light'),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: MainColor,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child:
                        Text("ยกเลิก", style: TextStyle(fontFamily: 'Light')),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
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
          title: Text("สิ้นสุดการโหวตวันที่ ${formatDate(post?.dateStop)}",
              style: TextStyle(fontFamily: 'Light')),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HomeScreen(
                      username: widget.username,
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
          ),
          actions: [
            
            isResult  == true? IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ReportPostScreen(
                      postId: post!.postId.toString(),
                      username: widget.username.toString());
                }));
              },
              icon: Icon(
                Icons.report,
                size: 35,
              ),
            ):IconButton(
              onPressed: () {
              },
              icon: Icon(
                Icons.report_off,
                size: 35,
              ),
            ),
          ],
        ),
        body: isDataLoaded == true
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: double.infinity,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text('${post?.title ?? ""}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: MainColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Light')),
                              SizedBox(
                                height: 25,
                              ),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      15), // แก้ไขค่าตรงนี้เพื่อปรับรูปแบบการโค้งตามที่คุณต้องการ
                                  child: Image.network(
                                    baseURL +
                                        '/posts/downloadimg/${post?.postImage}',
                                    fit: BoxFit.cover,
                                    width: 250,
                                    height: 250,
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                ' ${post?.description ?? ""}',
                                style: TextStyle(fontFamily: 'Light'),
                              ),
                              SizedBox(
                                height: 15,
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
                                  return AbsorbPointer(
                                    absorbing: votePost == ""
                                  ? false:true,
                                    child: Card(
                                      elevation: 2,
                                      shape: Border.all(
                                        color: selectedChoiceIndex == index
                                            ? SecondColor
                                            : Color.fromARGB(
                                                255, 255, 249, 196),
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
                                                : SizedBox(
                                                    width: 2, height: 50),
                                            Text(
                                              choices![index].choiceName ?? "",
                                              style: TextStyle(
                                                  fontFamily: 'Light'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              votePost == ""
                                  ? Container(
                                      width: 120,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ShowVoteDrialog();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary:
                                              MainColor, // Change this to your desired color
                                        ),
                                        child: Text(
                                          "ยืนยันคำตอบ",
                                          style: TextStyle(fontFamily: 'Light'),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 10,
                                    ),
                              SizedBox(height: 16.0),
                              CommentPostScreen(
                                member: member,
                                postId: post!.postId.toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
