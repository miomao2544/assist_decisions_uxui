import 'dart:io';

import 'package:assist_decisions_app/controller/choiceController.dart';
import 'package:assist_decisions_app/controller/postController.dart';
import 'package:assist_decisions_app/screen/homeScreen.dart';
// import 'package:assist_decisions_app/screen/postDetailScreen.dart';
import 'package:assist_decisions_app/widgets/custom_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/interestController.dart';
import '../model/choice.dart';
import '../model/interest.dart';
import '../model/post.dart';


class EditPostScreen extends StatefulWidget {
  final String username;
  final String postId;
  const EditPostScreen({required this.username,required this.postId});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final PostController postController = PostController();
  final ChoiceController choiceController = ChoiceController();
  InterestController interestController = InterestController();

    Post? post;
  List<Interest> interests = [];
  String? selectedInterest;
  FilePickerResult? filePickerResult;
  String? fileName;
  List<String>? fileImageName = [];
  String? dateStarts;
  String? dateStops;
  PlatformFile? pickedFile;
  File? fileToDisplay;
  List<File>? fileImagesToDisplay = [];
  bool isLoadingPicture = true;
  List<bool>? isLoadingImagePicture;
  List<Choice> choices = [];
  List<String>? Images = [];
  bool isDataLoaded = false;
  TextEditingController postImageTextController = TextEditingController();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController postPointTextController = TextEditingController();
  TextEditingController resultTextController = TextEditingController();
  TextEditingController qtyMaxTextController = TextEditingController();
  TextEditingController qtyMinTextController = TextEditingController();
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController interestIdTextController = TextEditingController();
  TextEditingController postDateStartController = TextEditingController();
  TextEditingController postDateStopController = TextEditingController();
  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  void _pickFile() async {
    try {
      setState(() {
        isLoadingPicture = true;
      });
      filePickerResult = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);
      if (filePickerResult != null) {
        fileName = filePickerResult!.files.first.name;
        pickedFile = filePickerResult!.files.first;
        fileToDisplay = File(pickedFile!.path.toString());
        postImageTextController.text = fileName.toString();
        print("File is ${fileName}");
      }
      setState(() {
        isLoadingPicture = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _pickFileChoices() async {
    try {
      setState(() {
        isLoadingPicture = true;
      });

      filePickerResult = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);
      if (filePickerResult != null) {
        fileImageName?.add(filePickerResult!.files.first.name);
        pickedFile = filePickerResult!.files.first;
        fileImagesToDisplay?.add(File(pickedFile!.path.toString()));
      }
      print("File is ${fileImageName![0]}");
      setState(() {
        isLoadingPicture = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _removeChoice(int index) {
    setState(() {
      choices.removeAt(index);
      fileImagesToDisplay?.removeAt(index);
      fileImageName?.removeAt(index);
    });
  }

  Future<void> _selectDateStart(BuildContext context) async {
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

      postDateStartController.text = formattedDate;
      String formattedDate2 =
          "${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')} ${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}:${selectedDate.second.toString().padLeft(2, '0')}";
      dateStarts = formattedDate2;
    }
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

  @override
  void initState() {
    super.initState();
    loadInterests();
    for (int i = 0; i < 2; i++) {
      choices.add(Choice(choiceName: ''));
    }
    initializeData();
  }

  @override
  void dispose() {
    postPointTextController.dispose();
    super.dispose();
  }

  Future<void> loadInterests() async {
    List<Interest> interestList = await interestController.listAllInterests();
    setState(() {
      interests = interestList;
    });
  }

  Future<void> initializeData() async {

    post = await postController.getPostById(widget.postId.toString());
    if (post != null) {
      //  = post!.dateStart.toString();
      // interestSelect = member!.interests!
      //     .map((interest) => interest.interestId.toString())
      //     .toList();
      // formattedInterestSelect =
      //     interestSelect.where((item) => item != null).join(',');
      // print("object>>>>> ${formattedInterestSelect}");
    }
    setState(() {
      isDataLoaded = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text("Add post"),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return  HomeScreen(
                        username: widget.username.toString(),
                      );
                    },
                  ),
                );
              },
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
            )),
        body: SingleChildScrollView(
          child: Column(children: [
            Form(
              key: fromKey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Text("แก้ไขโพสต์")),
                  ),
                  CustomTextFormField(
         
                    controller: titleTextController,
                    hintText: "หัวข้อ",
                    maxLength: 50,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return "หัวข้อ";
                      }
                    },
                    icon: const Icon(Icons.account_circle),
                  ),
                  Center(
                    child: isLoadingPicture
                        ? Image.asset(
                            "assets/images/${post!.postImage.toString()}",
                            width: 250,
                          ) // Add a loading indicator while loading the picture
                        : fileToDisplay != null
                            ? Image.file(
                                fileToDisplay!,
                                height: 200, // Set the desired image height
                              )
                            : Container(), // Display an empty container if no image is selected
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: postImageTextController,
                            enabled: false,
                            decoration: InputDecoration(
                                labelText: "รูปภาพของโพสต์",
                                counterText: "",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                prefixIcon: const Icon(Icons.image),
                                prefixIconColor: Colors.black),
                            style: const TextStyle(
                                fontFamily: 'Itim', fontSize: 18),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _pickFile();
                              },
                              child: const Text("เลือกรูปภาพ"),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  isLoadingPicture
                                      ? Colors.grey
                                      : Colors
                                          .teal, // Change button color based on loading state
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  CustomTextFormField(
                    controller: descriptionTextController,
                    hintText: "คำอธิบาย",
                    maxLength: 1000,
                    maxLines: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 150.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextFormField(
                          
                            controller: postPointTextController,
                            maxLength: 5,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelText: 'คะแนน',
                              border: OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.account_circle),
                              prefixIconColor: Colors.black,
                            ),
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                return null;
                              } else {
                                return "กรุณากรอกคะแนน";
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: 150.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextFormField(
                            controller: qtyMinTextController,
                            maxLength: 5,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelText: 'ต่ำสุด',
                              border: OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.account_circle),
                              prefixIconColor: Colors.black,
                            ),
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                return null;
                              } else {
                                return "กรุณากรอกจำนวนต่ำสุด";
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: 150.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextFormField(
                            controller: qtyMaxTextController,
                            maxLength: 5,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelText: 'สูงสุด',
                              border: OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.account_circle),
                              prefixIconColor: Colors.black,
                            ),
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                return null;
                              } else {
                                return "กรุณากรอกจำนวนสูงสุด";
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                    child: Text(
                        "ผู้โหวตจะได้คะแนนก็ต่อเมื่อมีผู้โหวตมากกว่าหรือเท่าจำนวนน้อยที่สุด"),
                  ),
                  Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 160,
                            child: TextFormField(
                              controller: postDateStartController,
                              readOnly: true,
                              onTap: () => _selectDateStart(context),
                              decoration: InputDecoration(
                                labelText: "วันที่",
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
                        ),
                        SizedBox(
                          width: 160,
                          child: TextFormField(
                            controller: postDateStopController,
                            readOnly: true,
                            onTap: () => _selectDateStop(context),
                            decoration: InputDecoration(
                              labelText: "วันที่",
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'กรุณาเลือกกลุ่มความสนใจ',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_circle),
                        prefixIconColor: Colors.black,
                      ),
                      value: selectedInterest,
                      onChanged: (newValue) {
                        setState(() {
                          selectedInterest = newValue;
                        });
                      },
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        } else {
                          return "กรุณาเลือกความสนใจ";
                        }
                      },
                      items: interests.map((interest) {
                        return DropdownMenuItem<String>(
                          value: interest.interestId,
                          child: Text(interest.interestName ?? ''),
                        );
                      }).toList(),
                    ),
                  ),
                  for (int i = 0; i < choices.length; i++) ...[
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Center(
                            child: fileImagesToDisplay != null &&
                                    fileImagesToDisplay!.isNotEmpty &&
                                    i < fileImagesToDisplay!.length
                                ? GestureDetector(
                                    child: Image.file(
                                      fileImagesToDisplay![i],
                                      width: 100,
                                      height: 100,
                                    ),
                                    onTap: () {
                                      _pickFileChoices();
                                    },
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      _pickFileChoices();
                                    },
                                    child: Icon(Icons.image,
                                        size: 30, color: Colors.blue),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'ตัวเลือกที่ ${i + 1}',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  choices[i].choiceName = value;
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
                          InkWell(
                            onTap: () => _removeChoice(i),
                            child:
                                Icon(Icons.cancel, size: 30, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 20),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.green,
                      size: 30,
                    ), // ไอคอนและสี
                    onPressed: () {
                      setState(() {
                        choices.add(Choice(choiceName: ''));
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text("ยืนยัน"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      elevation: 0,
                    ),
                    onPressed: () async {
                      print(
                          "------fileToDisplay-------${fileToDisplay!}-----------");
                      if (fromKey.currentState!.validate()) {
                        var response = await postController.doEditPost(
                            widget.postId,
                            titleTextController.text,
                            fileToDisplay!,
                            descriptionTextController.text,
                            postPointTextController.text,
                            dateStarts ?? "",
                            dateStops ?? "",
                            qtyMaxTextController.text,
                            qtyMinTextController.text,
                            widget.username.toString(),
                            selectedInterest ?? '');
                        for (int i = 0; i < choices.length; i++) {
                          Choice choice = choices[i];
                          await choiceController.editChoice(
                            choice.choiceId??"",
                            choice.choiceName ??"",
                            fileImagesToDisplay![i],
                            response["postId"],
                          );
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen(username: widget.username)),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ]),
        ));
  }
}
