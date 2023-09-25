import 'package:assist_decisions_app/model/post.dart';
import 'package:assist_decisions_app/model/member.dart';

class Comment{
  String? commentId;
  String? comment;
  String? commentDate;
  Member? member;
  Post? post;

  Comment({
    this.commentId,
    this.comment,
    this.commentDate,
    this.member,
    this.post,
  });

  factory Comment.fromJsonToComment(Map<String,dynamic> json) => Comment(
    commentId: json["commentId"],
    comment: json["comment"],
    commentDate: json["commentDate"],
    member: json["member"] == null?null: Member.fromJsonToMember(json["member"]),
    post: json["post"] == null?null: Post.fromJsonToPost(json["post"]),
  );

  Map<String,dynamic> fromCommentToJson(){
    return<String,dynamic>{
      'commentId' : commentId,
      'comment' : comment,
      'commentDate' : commentDate,
      'member' : member?.username,
      'post' : post?.postId
    };
  }
}