import 'package:assist_decisions_app/classcontroller/postController.dart';
import 'package:assist_decisions_app/controller/ListPostController.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/post/ViewPostDetailScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';
import '../../constant/constant_value.dart';
import 'package:intl/intl.dart';

class ListPostScreen extends StatefulWidget {
  final String username;
  const ListPostScreen({required this.username});

  @override
  State<ListPostScreen> createState() => _ListPostScreenState();
}

class _ListPostScreenState extends State<ListPostScreen> {
  List<Post>? posts;
  List<int>? counts;
  bool? isDataLoaded = false;
  PostController postController = PostController();
  ListPostController listPostController = ListPostController();
  Future fetchPost() async {
    posts = await listPostController.getListPostByMember(widget.username.toString());
    counts = List<int>.filled(posts!.length, 0);
    for (int i = 0; i < posts!.length; i++) {
      int count =
          await postController.getListCountMember(posts![i].postId.toString());
      counts![i] = count;
      print(
          "---------------${posts![i].postId.toString()}--------------${count}----------------");
    }
    setState(() {
      isDataLoaded = true;
    });
  }
DateTime now = DateTime.now();
late Color circleColor;

Color getCircleColor(Post post) {
  DateTime Now = DateTime.now();
  var oneDay = Duration(days: 1);
  print('now is $Now    > ${convertToDate(post.dateStop.toString()).add(oneDay)}');
  if (post.result == 'r' && Now.isAfter(convertToDate(post.dateStop.toString()).add(oneDay))) {
    return Colors.red;
  } else if (post.result == 'r' && Now.isBefore(convertToDate(post.dateStop.toString()).add(oneDay))) {
    return Colors.yellow;
  } else {
    return Colors.green;
  }
  
}

DateTime convertToDate(String input) {
  try {
   var d = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(input);
    var localDateTime = d.toLocal();
    var oneDay = Duration(days: 1);
    var newDateTime = localDateTime.add(oneDay);
    return newDateTime;
  } catch (e) {
    throw FormatException('Invalid date format');
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

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isDataLoaded == true
            ? posts != null && posts!.isNotEmpty
                ? Container(
                    padding: EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: posts!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(10.0),
                                leading: Container(
                                  width: 100,
                                  height: 400,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
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
                                                '/posts/downloadimg/${posts![index].postImage}',
                                            fit: BoxFit.cover,
                                            width: 34,
                                            height: 34,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        " ${counts![index]} คน",
                                        style: TextStyle(
                                            fontSize: 12, fontFamily: 'Light'),
                                      ),
                                    ],
                                  ),
                                ),
                                title: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "สิ้นสุด : ${formatDate(posts![index].dateStop)}",
                                      style: const TextStyle(
                                        fontFamily: 'Light',
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      "${posts![index].title}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Light',
                                          fontSize: 20,
                                          color: MainColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "คะแนน : ${posts![index].postPoint?.toInt()}",
                                      style: TextStyle(
                                          fontFamily: 'Light',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${posts![index].description}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontFamily: 'Light', fontSize: 16),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewPostDetailScreen(
                                        postId: posts![index].postId.toString(),
                                        username: widget.username.toString(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: getCircleColor(posts![index]),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text(
                    "ไม่มีโพสต์ของคุณ",
                    style: TextStyle(fontFamily: 'Light'),
                  ))
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
