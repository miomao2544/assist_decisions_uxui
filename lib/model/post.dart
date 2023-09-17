


import 'package:assist_decisions_app/model/interest.dart';
import 'package:assist_decisions_app/model/member.dart';

class Post{
  String? postID;
  String? postImage;
  String? title;
  String? description;
  double? postPoint;
  String? dateStart;
  String? dateStop;
  String? result;
  int? qtyMax;
  int? qtyMin;
  Member? member;
  Interest? interest;

  Post({
    this.postID,
    this.postImage,
    this.title,
    this.description,
    this.postPoint,
    this.dateStart,
    this.dateStop,
    this.result,
    this.qtyMax,
    this.qtyMin,
    this.member,
    this.interest
  });

  factory Post.fromJsonToPost(Map<String,dynamic> json) => Post(
    postID: json["postID"],
    postImage: json["postImage"],
    title: json["title"],
    description: json["description"],
    postPoint: json["postPoint"],
    dateStart: json["dateStart"],
    dateStop: json["dateStop"],
    result: json["result"],
    qtyMax: json["qtyMax"],
    qtyMin: json["qtyMin"],
    member: json["member"] == null?null: Member.fromJsonToMember(json["member"]),
    interest: json["interest"] == null?null: Interest.fromJsonToInterest(json["interest"])
  );
  
  Map<String,dynamic> fromPostToJson(){
    return<String,dynamic>{
      'postID' : postID,
      'postImage' : postImage,
      'title' : title,
      'description' : description,
      'postPoint' : postPoint,
      'dateStart' : dateStart,
      'dateStop' : dateStop,
      'result' : result,
      'qtyMax' : qtyMax,
      'qtyMin' : qtyMin,
      'member' : member?.username,
      'interest': interest?.interestId
    };
  }
}