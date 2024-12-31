class GetUserPrescription {
  String? sId;
  String? userid;
  List<String>? image; // Changed from List<String>? to List<String>?
  String? title;
  String? terms; // Changed from List<String>? to String?
  String? createdAt;
  String? updatedAt;
  int? iV;

  GetUserPrescription({
    this.sId,
    this.userid,
    this.image,
    this.title,
    this.terms,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  GetUserPrescription.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userid = json['userid'];
    image = (json['image'] as List<dynamic>?)?.map((e) => e as String).toList();
    title = json['title'];
    terms = json['terms']; // Changed to handle String?
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
    data['terms'] = terms; // Changed to handle String?
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
