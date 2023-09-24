class Ban_Type{
  String? banTypeId;
  String? typeName;
  String? numberOfDay;

  Ban_Type({
    this.banTypeId,
    this.typeName,
    this.numberOfDay,
  });

  factory Ban_Type.fromJsonToBanType(Map<String,dynamic> json) => Ban_Type(
    banTypeId: json["banTypeId"],
    typeName: json["typeName"],
    numberOfDay: json["numberOfDay"],
  );

  Map<String,dynamic> fromBanTypeToJson(){
    return<String,dynamic>{
      'banTypeId' : banTypeId,
      'typeName' : typeName,
      'numberOfDay' : numberOfDay,
    };
  }
}