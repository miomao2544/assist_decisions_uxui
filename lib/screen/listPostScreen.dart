import 'package:assist_decisions_app/controller/post_controller.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/postDetailScreen.dart';
import 'package:flutter/material.dart';
import '../constant/constant_value.dart';
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
  final PostController postController = PostController();

Future fetchPost() async {
    posts = await postController.listPostsMember(widget.username.toString());
    counts = List<int>.filled(posts!.length, 0);
    for (int i = 0; i < posts!.length; i++) {
      int count = await postController.getListCountMember(posts![i].postId.toString());
      counts![i] = count;
      print("---------------${posts![i].postId.toString()}--------------${count}----------------");
    }
    setState(() {
      isDataLoaded = true;
    });
  }


  String formatDate(String? inputDate) {
    if (inputDate != null) {
      final DateTime date = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(date);
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
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10.0),
                            // ตรงนี้คือส่วนที่แสดงข้อมูลของโพสต์
                            leading: Container(
                              width: 100,
                              height: 100,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      baseURL +
                                          '/posts/downloadimg/${posts![index].postImage}',
                                      fit: BoxFit.cover,
                                      width: 36,
                                      height: 36,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    " ${counts![index]} คน",
                                  ),
                                ],
                              ),
                            ),
                            title: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "สิ้นสุดการโหวต ${formatDate(posts![index].dateStop)}",
                                  style: const TextStyle(
                                    fontFamily: 'Itim',
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  "${posts![index].title}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: 'Itim', fontSize: 20),
                                ),
                                Text(
                                  "คะแนน : ${posts![index].postPoint?.toInt()}",
                                  style: const TextStyle(
                                      fontFamily: 'Itim', fontSize: 16),
                                ),
                                Text(
                                  "${posts![index].description}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: 'Itim', fontSize: 16),
                                ),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.chevron_right_sharp),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetailScreen(
                                    postId: posts![index].postId.toString(),username: widget.username.toString(),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                : Center(child: Text("ไม่มีโพสต์ของคุณ"))
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
