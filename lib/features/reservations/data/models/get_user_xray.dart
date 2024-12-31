class GetUserXRay {
  String? sId;
  String? userid;
  List<String>? image;
  String? title;
  String? terms;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GetUserXRay({
    this.sId,
    this.userid,
    this.image,
    this.title,
    this.terms,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  GetUserXRay.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userid = json['userid'];
    image = (json['image'] as List<dynamic>?)?.map((e) => e as String).toList();
    title = json['title'];
    terms = json['terms'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userid'] = userid;
    data['image'] = image;
    data['title'] = title;
    data['terms'] = terms;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
