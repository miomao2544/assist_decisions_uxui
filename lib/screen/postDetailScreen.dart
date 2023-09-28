import 'package:assist_decisions_app/controller/memberController.dart';
import 'package:assist_decisions_app/controller/postController.dart';
import 'package:assist_decisions_app/controller/voteController.dart';
import 'package:assist_decisions_app/screen/chackDeletePostScreen.dart';
import 'package:assist_decisions_app/screen/editPostScreen.dart';
import 'package:assist_decisions_app/screen/homeScreen.dart';
import 'package:assist_decisions_app/screen/listCommentScreen.dart';
import 'package:flutter/material.dart';
import 'package:assist_decisions_app/model/choice.dart';
import 'package:assist_decisions_app/model/member.dart';
import '../constant/constant_value.dart';
import '../controller/choiceController.dart';
import '../model/post.dart';
import 'package:intl/intl.dart';

import '../widgets/PostInfoWidget.dart';
import '../widgets/divider_box.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  final String username;
  const PostDetailScreen({required this.postId, required this.username});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post? post;
  List<Choice>? choices = [];
  int counts = 0;
  List<String> votes = [];
  Member? member;
  int? selectedChoiceIndex = 0;
  bool? isDataLoaded = false;
  ChoiceController choiceController = ChoiceController();
  PostController postController = PostController();
  MemberController memberController = MemberController();
  VoteController voteController = VoteController();
  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date);
    }
    return '';
  }

  Future<void> fetchPost() async {
    Post? postRequired;
    List<Choice> choiceRequired;
    Member? memberRequired;
    int count;
    List<String> vote = [];
    postRequired = await postController.getPostById(widget.postId);
    choiceRequired = await choiceController.listAllChoicesById(widget.postId);
    memberRequired = await memberController.getMemberById(widget.username);
    count = await postController.getListCountMember(widget.postId);
    vote = List<String>.filled(choiceRequired.length, "");
    for (int i = 0; i < choiceRequired.length; i++) {
      vote[i] = await voteController
          .getVoteByChoice(choiceRequired[i].choiceId.toString());
    }

    setState(() {
      post = postRequired;
      choices = choiceRequired;
      member = memberRequired;
      counts = count;
      votes = vote;
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
        title: Text(
            "${formatDate(post?.dateStart)} - ${formatDate(post?.dateStop)}"),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomeScreen(
                username: widget.username.toString(),
              );
            }));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: isDataLoaded == true
          ? Container(
              height: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                      ? Colors.green
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedChoiceIndex = index;
                                    });
                                  },
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("${index + 1}"),
                                        Image.network(
                                          baseURL +
                                              '/choices/downloadimg/${choices![index].choiceImage}',
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                        ),
                                        Text(choices![index].choiceName ?? ""),
                                        Text("${votes[index]}",style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Text(
                            "จำนวนผู้โหวต : ${counts} ",
                            style: TextStyle(fontSize: 18),
                          ),
                          Container(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditPostScreen(username: widget.username,postId: post!.postId.toString(),)),
                                      );
                                    },
                                    child: Text("แก้ไข"),
                                  ),
                                  SizedBox(width: 20),
                                  ChackDeletePostScreen(
                                      postId: post!.postId.toString(),username: widget.username,),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            "ความคิดเห็น",
                            style: TextStyle(fontSize: 18),
                          ),
                          ListCommentScreen(postId: post!.postId.toString())
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : CircularProgressIndicator(),
    ));
  }
}
