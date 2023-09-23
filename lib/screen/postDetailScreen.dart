import 'package:assist_decisions_app/screen/chackDeletePostScreen.dart';
import 'package:assist_decisions_app/screen/editPostScreen.dart';
import 'package:assist_decisions_app/screen/homeScreen.dart';
import 'package:flutter/material.dart';

import '../constant/constant_value.dart';
import '../controller/choice_controller.dart';
import '../model/choice.dart';
import '../model/post.dart';
import 'package:intl/intl.dart';

import '../widgets/PostInfoWidget.dart';
import '../widgets/divider_box.dart';

class PostDetailScreen extends StatefulWidget {
  final Post? post;
  const PostDetailScreen({required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  List<Choice>? choices;
  int? selectedChoiceIndex = 0;
  final ChoiceController choiceController = ChoiceController();

  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date);
    }
    return '';
  }

  Future<void> fetchChoice() async {
    choices =
        await choiceController.listAllChoicesById(widget.post?.postId ?? "");
  }

  Future<void> _refreshChoices() async {
    await fetchChoice();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchChoice();
  }

  @override
  Widget build(BuildContext context) {
    _refreshChoices();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${formatDate(widget.post?.dateStart)} - ${formatDate(widget.post?.dateStop)}"),
        actions: [
          IconButton(
            onPressed: () {
              HomeScreen(username: "maihom2001");
            },
            icon: Icon(Icons.report),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshChoices,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${widget.post?.title ?? ""}',
                      style: TextStyle(fontSize: 30)),
                  SizedBox(
                    height: 20,
                  ),
                  Image.network(
                    baseURL + '/posts/downloadimg/${widget.post?.postImage}',
                    fit: BoxFit.cover,
                    width: 250,
                    height: 250,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('รายละเอียด : ${widget.post?.description ?? ""}'),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      PostInfoWidget(
                        title: "คะแนน",
                        value: "${widget.post?.postPoint?.toInt()}",
                      ),
                      PostInfoWidget(
                        title: "จำนวนต่ำสุด",
                        value: "${widget.post?.qtyMin}",
                      ),
                      PostInfoWidget(
                        title: "จำนวนสูงสุด",
                        value: "${widget.post?.qtyMax}",
                      ),
                      PostInfoWidget(
                        title: "จำนวนผู้โหวต",
                        value: "20",
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${index + 1}",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                choices![index].choiceName ?? "",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "20",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Text("จำนวนผู้โหวต : 100 ",style: TextStyle(fontSize: 18),),
                  Container(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>EditPostScreen(post: widget.post)),);
                            },
                            child: Text("แก้ไข"),
                          ),
                          SizedBox(width: 20),
                         ChackDeletePostScreen(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
