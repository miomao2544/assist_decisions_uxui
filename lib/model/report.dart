import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/model/member.dart';

class Report{
  String? reportId;
  String? reportDate;
  String? reportComment;
  Post? post;
  Member? member;


  Report({
    this.reportId,
    this.reportDate,
    this.reportComment,
    this.post,
    this.member,

  });

  factory Report.fromJsonToReport(Map<String,dynamic> json) => Report(
    reportId: json["reportId"],
    reportDate: json["reportDate"],
    reportComment: json["reportComment"],
    post: json["post"] == null?null: Post.fromJsonToPost(json["post"]),
    member: json["member"] == null?null: Member.fromJsonToMember(json["member"]),

  );

  Map<String,dynamic> fromReportToJson(){
    return<String,dynamic>{
      'reportId' : reportId,
      'reportDate' : reportDate,
      'reportComment' : reportComment,
      'post' : post?.postId,
      'member' : member?.username,
    };
  }
}