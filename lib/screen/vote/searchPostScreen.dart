import 'package:assist_decisions_app/controller/SearchPostController.dart';
import 'package:assist_decisions_app/classcontroller/interestController.dart';
import 'package:assist_decisions_app/classcontroller/postController.dart';
import 'package:assist_decisions_app/model/interest.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/post/ViewPostDetailScreen.dart';
import 'package:assist_decisions_app/screen/vote/viewPostScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:flutter/material.dart';
import '../../constant/constant_value.dart';
import 'package:intl/intl.dart';

class SearchPostScreen extends StatefulWidget {
  final String username;
  const SearchPostScreen({required this.username});

  @override
  State<SearchPostScreen> createState() => _SearchPostScreenState();
}

class _SearchPostScreenState extends State<SearchPostScreen> {
  String? interestListSelect = "";
  List<Interest> interests = [];
  List<String?> interestSelect = [];
  List<bool> isSelected = [false, false, false];
  String? search = "";
  List<Post>? posts;
  bool? isDataLoaded = false;
  String? point = "0";
  List<String> numbers = ["0", "1000", "500", "200", "100", "50"];
  TextEditingController postDateStopController = TextEditingController();
  String? dateStops = "";
  PostController postController = PostController();
  SearchPostController searchPostController =SearchPostController();
  InterestController interestController = InterestController();

  Future fetchPost() async {
    List<Interest>? interest = await interestController
        .listInterestsByUser(widget.username.toString());
    List<String>? interestList = [];
    if(interestListSelect == ''){
    for (int i = 0; i < interest!.length; i++) {
        if (interestListSelect != null) {
        interestList.add(interest[i].interestId.toString());
      }
    }
        interestListSelect = interestList.where((item) => item != true).join(',');
    }

print("---------------------------interests-----is ${interestListSelect}----------------------");
    posts = await searchPostController.doSearchPost(search.toString(),
        interestListSelect.toString(),"", "");
    setState(() {});
  }

  Future loadInterests() async {
    List<Interest> interestList = await interestController.listInterestsByUser(widget.username.toString());
    setState(() {

      interests = interestList;
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

  void updatePoint(String newValue) {
    setState(() {
      point = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    point = numbers[0];
    fetchPost();
    loadInterests();
    isSelected = List<bool>.filled(interests.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0), // ปรับความสูงตามที่คุณต้องการ
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          width: 200.0,
                          height: 50.0,
                          color: Colors.blueGrey[50],
                          child: TextField(
                            onChanged: (value) {
                              search = value;
                            },
                            decoration: InputDecoration(
                              hintText: "ค้นหาโพสต์...",
                              filled: true,
                              hintStyle: TextStyle(
                                fontFamily: 'Light',
                              ),
                              border: InputBorder.none,
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
                          fetchPost();
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
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 30.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: interests.length,
                      itemBuilder: (BuildContext context, int index) {
                        final interest = interests[index];
                        final isSelected =
                            interestSelect.contains(interest.interestId);

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (isSelected) {
                                  interestSelect.remove(interest.interestId);
                                } else {
                                  interestSelect.add(interest.interestId);
                                }
                                interestListSelect = interestSelect
                                    .where((item) => item != null)
                                    .join(',');
                                print(
                                    "interestSelect is ----------------- > = " +
                                        interestListSelect.toString());
                                         fetchPost();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: isSelected ? SecondColor : MainColor,
                            ),
                            child: Text(interest.interestName ?? "",style: TextStyle( fontFamily: 'Light')),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
                            contentPadding: EdgeInsets.all(8.0),
                            // ตรงนี้คือส่วนที่แสดงข้อมูลของโพสต์
                            leading: Container(
                              width: 100,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: SecondColor, // สีเส้นขอบแดง
                                        width: 2.0, // ความหนาของเส้นขอบ 2
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        baseURL +
                                            '/members/downloadimg/${posts?[index].member?.image}',
                                        fit: BoxFit.cover,
                                        width: 34,
                                        height: 34,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${posts?[index].member?.nickname}",
                                    style: TextStyle(
                                      fontFamily: 'Light',
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${posts?[index].title}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Light',
                                      fontSize: 20,
                                      color: MainColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "คะแนน : ${posts?[index].postPoint?.toInt()}",
                                  style: TextStyle(
                                      fontFamily: 'Light',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${posts?[index].description}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: 'Light', fontSize: 15),
                                ),
                                Text(
                                  "สิ้นสุด : ${formatDate(posts?[index].dateStop)}",
                                  style: const TextStyle(
                                    fontFamily: 'Light',
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chevron_right_sharp,
                                  size: 30,
                                  color: MainColor,
                                ),
                              ],
                            ),

                            onTap: () {
                              widget.username == posts?[index].member?.username
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewPostDetailScreen(
                                          postId:
                                              posts![index].postId.toString(),
                                          username: widget.username.toString(),
                                        ),
                                      ),
                                    )
                                  : Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                      return ViewPostScreen(
                                        postId: posts![index].postId.toString(),
                                        username: widget.username.toString(),
                                      );
                                    }));
                            },
                          ),
                        );
                      },
                    ),
                  )
                : Center(child: Text("ไม่มีโพสต์ที่ตรงกับความสนใจของคุณ"))
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
