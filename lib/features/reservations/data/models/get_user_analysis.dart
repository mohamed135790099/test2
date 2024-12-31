class GetUserAnalysis {
  String? sId;
  String? userid;
  List<String>? image; // Changed from String? to List<String>?
  String? terms;
  String? title;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GetUserAnalysis({
    this.sId,
    this.userid,
    this.image,
    this.title,
    this.terms,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  GetUserAnalysis.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userid = json['userid'];
    title = json['title'];
    image = (json['image'] as List<dynamic>?)?.map((e) => e as String).toList();
    terms = json['terms']; // Changed to handle String?
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userid'] = userid;
    data['title'] = title;
    data['image'] = image;
    data['terms'] = terms; // Changed to handle String?
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
