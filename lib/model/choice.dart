import 'package:assist_decisions_app/model/post.dart';

class Choice{
  String? choiceId;
  String? choiceName;
  String? choiceImage;
  Post? post;

  Choice({
    this.choiceId,
    this.choiceName,
    this.choiceImage,
    this.post,
  });

  factory Choice.fromJsonToChoice(Map<String,dynamic> json) => Choice(
    choiceId: json["choiceId"],
    choiceName: json["choiceName"],
    choiceImage: json["choiceImage"],
    post: json["post"] == null?null: Post.fromJsonToPost(json["post"]),
  );

  Map<String,dynamic> fromChoiceToJson(){
    return<String,dynamic>{
      'choiceID' : choiceId,
      'choiceName' : choiceName,
      'choiceImage' : choiceImage,
      'post' : post?.postId
    };
  }
}