class Interest{
  String? interestId;
  String? interestName;

  Interest({
    required this.interestId,
    required this.interestName
  });

  factory Interest.fromJsonToInterest(Map<String,dynamic> json) => Interest(
    interestId: json["interestId"],
    interestName: json["interestName"]
  );

  Map<String,dynamic> fromInterestToJson(){
    return<String,dynamic>{
      'interestId' : interestId,
      'interestName' : interestName,
    };
  }
}