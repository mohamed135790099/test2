class GetOneXRay {
  String? sId;
  Userid? userid;
  String? title;
  List<String>? image;
  List<String>? pdfUrl;
  String? special;
  String? terms;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GetOneXRay({
    this.sId,
    this.userid,
    this.image,
    this.pdfUrl,
    this.special,
    this.title,
    this.terms,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  GetOneXRay.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userid = json['userid'] != null ? Userid.fromJson(json['userid']) : null;
    image = (json['image'] as List<dynamic>?)?.map((e) => e as String).toList();
    pdfUrl = (json['pdf'] as List<dynamic>?)?.map((e) => e as String).toList();
    special = json['special'];
    title = json['title'];
    terms = json['terms'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (userid != null) {
      data['userid'] = userid!.toJson();
    }
    data['image'] = image;
    data['pdf'] = pdfUrl;
    data['special'] = special;
    data['terms'] = terms;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Userid {
  String? sId;
  String? fullName;
  String? phone;
  String? role;
  List<String>? tahalil;
  List<String>? roshta;
  List<String>? asheaa;
  List<String>? medicin;
  List<String>? reservs;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? otp;
  String? otpExpires;

  Userid({
    this.sId,
    this.fullName,
    this.phone,
    this.role,
    this.tahalil,
    this.roshta,
    this.asheaa,
    this.medicin,
    this.reservs,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.otp,
    this.otpExpires,
  });

  Userid.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    phone = json['phone'];
    role = json['role'];
    tahalil =
        (json['tahalil'] as List<dynamic>?)?.map((e) => e as String).toList();
    roshta =
        (json['roshta'] as List<dynamic>?)?.map((e) => e as String).toList();
    asheaa =
        (json['asheaa'] as List<dynamic>?)?.map((e) => e as String).toList();
    medicin =
        (json['medicin'] as List<dynamic>?)?.map((e) => e as String).toList();
    reservs =
        (json['reservs'] as List<dynamic>?)?.map((e) => e as String).toList();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    otp = json['otp'];
    otpExpires = json['otpExpires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['fullName'] = fullName;
    data['phone'] = phone;
    data['role'] = role;
    data['tahalil'] = tahalil;
    data['roshta'] = roshta;
    data['asheaa'] = asheaa;
    data['medicin'] = medicin;
    data['reservs'] = reservs;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['otp'] = otp;
    data['otpExpires'] = otpExpires;
    return data;
  }
}
