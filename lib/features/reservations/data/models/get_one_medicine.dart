class GetOneMedicine {
  String? sId;
  Userid? userid;
  String? title;
  List<String>? image;
  String? special;
  String? terms; // Changed to String
  String? createdAt;
  String? updatedAt;
  int? iV;

  GetOneMedicine({
    this.sId,
    this.userid,
    this.image,
    this.title,
    this.special,
    this.terms,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  GetOneMedicine.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userid = json['userid'] != null ? Userid.fromJson(json['userid']) : null;
    image = (json['image'] as List<dynamic>?)?.map((e) => e as String).toList();
    special = json['special'];
    title = json['title'];
    terms = json['terms']; // Changed to direct assignment
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
    data['special'] = special;
    data['terms'] = terms; // Direct assignment
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
  List<dynamic>? tahalil;
  List<dynamic>? roshta;
  List<dynamic>? asheaa;
  List<dynamic>? medicin;
  List<dynamic>? reservs;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? otp;
  String? otpExpires;

  Userid(
      {this.sId,
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
      this.otpExpires});

  Userid.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    phone = json['phone'];
    role = json['role'];
    tahalil = json['tahalil'].cast<String>();
    roshta = json['roshta'].cast<String>();
    asheaa = json['asheaa'].cast<String>();
    medicin = json['medicin'].cast<String>();
    reservs = json['reservs'].cast<String>();
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
