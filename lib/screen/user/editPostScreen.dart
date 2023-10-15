import 'dart:io';

import 'package:assist_decisions_app/constant/constant_value.dart';
import 'package:assist_decisions_app/controller/choiceController.dart';
import 'package:assist_decisions_app/controller/memberController.dart';
import 'package:assist_decisions_app/controller/postController.dart';
import 'package:assist_decisions_app/model/member.dart';
import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/screen/vote/homeScreen.dart';
import 'package:assist_decisions_app/widgets/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controller/interestController.dart';
import '../../model/choice.dart';
import '../../model/interest.dart';
import '../validators/validatorPost.dart';
import 'package:intl/intl.dart';

class EditPostScreen extends StatefulWidget {
  final String username;
  final String postId;
  const EditPostScreen({required this.username, required this.postId});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();
  String? title;
  String? image;
  String? description;
  String? point;
  String? min;
  String? max;
  String? avgPoint;
  String? selectedInterest;
  String? dateStart;
  String? dateStop;

  List<String>? images = [];
  ChoiceController choiceController = ChoiceController();
  PostController postController = PostController();
  MemberController memberController = MemberController();
  String? fileName;
  PlatformFile? pickedFile;
  File? fileToDisplay;
  bool isLoadingPicture = true;
  FilePickerResult? filePickerResult;
  List<String?> fileImageName = [];
  List<File?> fileImagesToDisplay = [];
  List<bool>? isLoadingImagePicture = [];

  void _pickFileChoices(int index) async {
    try {
      setState(() {
        isLoadingPicture = true;
      });

      filePickerResult = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);

      print("File is ${fileImageName![0]}");

      setState(() {
        if (filePickerResult != null) {
          fileImageName?[index] = filePickerResult!.files.first.name;
          pickedFile = filePickerResult!.files.first;
          fileImagesToDisplay?[index] = File(pickedFile!.path!);
          isLoadingImagePicture?.add(false);
        }
        isLoadingPicture = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _addNewChoice() {
    setState(() {
      choices.add(Choice(choiceName: "", choiceImage: ""));
      fileImagesToDisplay.add(null);
      fileImageName.add("");
      print("-------A--------- ${choices.length}");
      print("-------B--------- ${fileImagesToDisplay.length}");
      print("-------C--------- ${fileImageName.length}");
      isLoadingImagePicture?.add(true);
    });
  }

  void _removeChoice(int index) {
    setState(() {
      if (index >= 0 && index < choices.length) {
        choices.removeAt(index);
        for (int i = 0; i < choices.length; i++) {
          choices[i].choiceName;
        }
      }
      if (fileImagesToDisplay != null &&
          index >= 0 &&
          index < fileImagesToDisplay!.length) {
        fileImagesToDisplay!.removeAt(index);
      }
      if (fileImageName != null &&
          index >= 0 &&
          index < fileImageName!.length) {
        fileImageName!.removeAt(index);
      }
    });
  }

  TextEditingController postDateStartController = TextEditingController();
  TextEditingController postDateStopController = TextEditingController();

  List<Choice> choices = [];
  List<Interest> interests = [];
  InterestController interestController = InterestController();
  bool? isDataLoaded = false;
  int? pointmember;

  Future loadInterests() async {
    Member? member;
    List<Interest> interestList =
        await interestController.listInterestsByUser(widget.username);
    member = await memberController.getMemberById(widget.username);
    setState(() {
      interests = interestList;
      pointmember = member!.point;
    });
  }

  Post? posts;
  Future<void> setInitialValues() async {
    Post? post = await postController.getPostById(widget.postId);
    List<Choice> choice =
        await choiceController.listAllChoicesById(widget.postId);
    for (int i = 0; i < choice.length; i++) {
      fileImagesToDisplay?.add(null);
      fileImageName?.add("");
    }
    setState(() {
      posts = post;
      choices = choice;
      print("-------A--------- ${choices.length}");
      print("-------B--------- ${fileImagesToDisplay!.length}");
      print("-------C--------- ${fileImageName!.length}");
      selectedInterest = posts!.interest!.interestId;
      postDateStartController.text = posts!.dateStart.toString();
      postDateStopController.text = posts!.dateStop.toString();
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadInterests();
    setInitialValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: MainColor,
          title: Text("แก้ไขโพสต์"),
          centerTitle: true,
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
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: fromKey,
            child: Center(
              child: Column(
                children: [
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: choices.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              choices[index].choiceImage != "" && fileImagesToDisplay[index] == null
                                  ? GestureDetector(
                                      onTap: () {
                                         _pickFileChoices(index);
                                      },
                                      child: fileImagesToDisplay[index] == null? Image.network(
                                        baseURL +
                                            '/choices/downloadimg/${choices[index].choiceImage}',
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height: 50,
                                      ) : Image.file(
                                                  fileImagesToDisplay[index] ??
                                                      File(""),
                                                  width: 50,
                                                  height: 50,
                                                ),
                                    )
                                  :
                                  fileImagesToDisplay[index] != null
                                      ? GestureDetector(
                                          child: fileImagesToDisplay[index] !=
                                                  null
                                              ? Image.file(
                                                  fileImagesToDisplay[index] ??
                                                      File(""),
                                                  width: 50,
                                                  height: 50,
                                                )
                                              : Image.asset(
                                                  'assets/images/logo.png'),
                                          onTap: () {
                                            _pickFileChoices(index);
                                          },
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            _pickFileChoices(index);
                                          },
                                          child: Icon(Icons.image,
                                              size: 30, color: MainColor),
                                        ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  initialValue: choices[index].choiceName,
                                  decoration: InputDecoration(
                                    labelText: 'ตัวเลือกที่ ${index + 1}',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      choices[index].choiceName = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return "กรุณากรอกตัวเลือก";
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              choices[index].choiceId == null
                                  ? InkWell(
                                      onTap: () => _removeChoice(index),
                                      child: Icon(Icons.cancel,
                                          size: 30, color: Colors.red),
                                    )
                                  : SizedBox(
                                      width: 30,
                                    )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.green,
                      size: 30,
                    ), // ไอคอนและสี
                    onPressed: () {
                      _addNewChoice();
                    },
                  ),
                  ElevatedButton(
                      child: Text("ยืนยัน"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MainColor,
                        elevation: 0,
                      ),
                      onPressed: () async {
                        for (int i = 0; i < choices.length; i++) {
                          if (fileImagesToDisplay[i] != null) {
                            var uploadedFile = await choiceController
                                .upload(fileImagesToDisplay[i] ?? File(""));
                            if (uploadedFile != null) {
                              choices[i].choiceImage = uploadedFile;
                            }
                          }
                          print(
                              "----------${choices[i].choiceImage}-----------");
                          print("${choices[i].choiceId}");
                          print("${choices[i].choiceName}");
                          print("${choices[i].choiceImage}");

                          if (fromKey.currentState!.validate()) {
                            await choiceController.editChoice(
                                choices[i].choiceId ?? "",
                                choices[i].choiceName ?? "",
                                choices[i].choiceImage ?? "",
                                posts!.postId ?? "");
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
