class GetAllUsers {
  String? sId;
  String? fullName;
  String? phone;
  String? role;
  List<Tahalil>? tahalil;
  List<Roshta>? roshta;
  List<Asheaa>? asheaa;
  List<Medicin>? medicin;
  List<Reservs>? reservs;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? otp;
  String? otpExpires;

  GetAllUsers({
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

  GetAllUsers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    phone = json['phone'];
    role = json['role'];
    if (json['tahalil'] != null) {
      tahalil = <Tahalil>[];
      json['tahalil'].forEach((v) {
        tahalil!.add(Tahalil.fromJson(v));
      });
    }
    if (json['roshta'] != null) {
      roshta = <Roshta>[];
      json['roshta'].forEach((v) {
        roshta!.add(Roshta.fromJson(v));
      });
    }
    if (json['asheaa'] != null) {
      asheaa = <Asheaa>[];
      json['asheaa'].forEach((v) {
        asheaa!.add(Asheaa.fromJson(v));
      });
    }
    if (json['medicin'] != null) {
      medicin = <Medicin>[];
      json['medicin'].forEach((v) {
        medicin!.add(Medicin.fromJson(v));
      });
    }
    if (json['reservs'] != null) {
      reservs = <Reservs>[];
      json['reservs'].forEach((v) {
        reservs!.add(Reservs.fromJson(v));
      });
    }
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
    if (tahalil != null) {
      data['tahalil'] = tahalil!.map((v) => v.toJson()).toList();
    }
    if (roshta != null) {
      data['roshta'] = roshta!.map((v) => v.toJson()).toList();
    }
    if (asheaa != null) {
      data['asheaa'] = asheaa!.map((v) => v.toJson()).toList();
    }
    if (medicin != null) {
      data['medicin'] = medicin!.map((v) => v.toJson()).toList();
    }
    if (reservs != null) {
      data['reservs'] = reservs!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['otp'] = otp;
    data['otpExpires'] = otpExpires;
    return data;
  }
}

class Tahalil {
  String? sId;
  String? userid;
  List<String>? image;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Tahalil({
    this.sId,
    this.userid,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Tahalil.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userid = json['userid'];
    if (json['image'] != null) {
      image = List<String>.from(json['image']);
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userid'] = userid;
    if (image != null) {
      data['image'] = image;
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Roshta {
  String? sId;
  String? userid;
  List<String>? image;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Roshta({
    this.sId,
    this.userid,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Roshta.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userid = json['userid'];
    if (json['image'] != null) {
      image = List<String>.from(json['image']);
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userid'] = userid;
    if (image != null) {
      data['image'] = image;
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Medicin {
  String? sId;
  String? userid;
  List<String>? image;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Medicin({
    this.sId,
    this.userid,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Medicin.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userid = json['userid'];
    if (json['image'] != null) {
      image = List<String>.from(json['image']);
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userid'] = userid;
    if (image != null) {
      data['image'] = image;
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Asheaa {
  String? sId;
  String? userid;
  List<String>? image;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Asheaa({
    this.sId,
    this.userid,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Asheaa.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userid = json['userid'];
    if (json['image'] != null) {
      image = List<String>.from(json['image']);
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userid'] = userid;
    if (image != null) {
      data['image'] = image;
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Reservs {
  String? id;
  String? userid;
  String? date;
  String? time;
  String? createdAt;
  String? updatedAt;
  int? v;

  Reservs({
    this.id,
    this.userid,
    this.date,
    this.time,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Reservs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    date = json['date'];
    time = json['time'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userid'] = userid;
    data['date'] = date;
    data['time'] = time;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}
