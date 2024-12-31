class UserModel {
  String? sId;
  String? fullName;
  String? phone;
  String? role;
  List<Tahalil>? tahalil;
  List<Roshta>? roshta;
  List<ReservationModel>? reservs;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? otp;
  String? otpExpires;

  UserModel({
    this.sId,
    this.fullName,
    this.phone,
    this.role,
    this.tahalil,
    this.roshta,
    this.reservs,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.otp,
    this.otpExpires,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
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
    if (json['reservs'] != null) {
      reservs = <ReservationModel>[];
      json['reservs'].forEach((v) {
        reservs!.add(ReservationModel.fromJson(v));
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
  List<dynamic>? image;
  String? terms;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Tahalil({
    this.sId,
    this.userid,
    this.image,
    this.terms,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Tahalil.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userid = json['userid'];
    image = json['image'];
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
    data['terms'] = terms;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Roshta {
  String? sId;
  String? userid;
  List<dynamic>? image;
  String? special;
  String? terms;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Roshta({
    this.sId,
    this.userid,
    this.image,
    this.special,
    this.terms,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Roshta.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userid = json['userid'];
    image = json['image'];
    special = json['special'];
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
    data['special'] = special;
    data['terms'] = terms;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Reservs {
  String? sId;
  String? user;
  String? date;
  String? time;
  List<dynamic>? image;
  String? terms;
  String? status;
  int? price;
  String? paid;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Reservs({
    this.sId,
    this.user,
    this.date,
    this.time,
    this.image,
    this.terms,
    this.status,
    this.price,
    this.paid,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Reservs.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    date = json['date'];
    time = json['time'];
    image = json['image'];
    terms = json['terms'];
    status = json['status'];
    price = json['price'];
    paid = json['paid'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['date'] = date;
    data['time'] = time;
    data['image'] = image;
    data['terms'] = terms;
    data['status'] = status;
    data['price'] = price;
    data['paid'] = paid;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ReservationModel {
  String id;
  String user;
  String date;
  String time;
  String status;
  String reservType;
  int price;
  int totalPrice;
  String paid;
  String paidType;
  String eventCreater;
  int discount;
  int examinationPrice;
  int amountPaid;
  int remainingAmount;
  List<AdditionalService> additionalServices;
  int number;
  String schadual;
  String createdAt;
  String updatedAt;
  int v;

  ReservationModel({
    required this.id,
    required this.user,
    required this.date,
    required this.time,
    required this.status,
    required this.reservType,
    required this.price,
    required this.totalPrice,
    required this.paid,
    required this.paidType,
    required this.eventCreater,
    required this.discount,
    required this.examinationPrice,
    required this.amountPaid,
    required this.remainingAmount,
    required this.additionalServices,
    required this.number,
    required this.schadual,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  // تعديل هنا للتعامل مع البيانات القادمة داخل الحقل "reservation"
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    var reservationData = json['reservation'] ?? {}; // الحصول على بيانات الحجز من الحقل "reservation"

    return ReservationModel(
      id: reservationData['_id'],
      user: reservationData['user'],
      date: reservationData['date'],
      time: reservationData['time'],
      status: reservationData['status'],
      reservType: reservationData['reserv_type'],
      price: reservationData['price'],
      totalPrice: reservationData['totalPrice'],
      paid: reservationData['paid'],
      paidType: reservationData['paidType'],
      eventCreater: reservationData['eventCreater'],
      discount: reservationData['discount'],
      examinationPrice: reservationData['examinationPrice'],
      amountPaid: reservationData['amountPaid'],
      remainingAmount: reservationData['remainingAmount'],
      additionalServices: (reservationData['addtionalServices'] as List)
          .map((item) => AdditionalService.fromJson(item))
          .toList(),
      number: reservationData['number'],
      schadual: reservationData['schadual'],
      createdAt: reservationData['createdAt'],
      updatedAt: reservationData['updatedAt'],
      v: reservationData['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'date': date,
      'time': time,
      'status': status,
      'reserv_type': reservType,
      'price': price,
      'totalPrice': totalPrice,
      'paid': paid,
      'paidType': paidType,
      'eventCreater': eventCreater,
      'discount': discount,
      'examinationPrice': examinationPrice,
      'amountPaid': amountPaid,
      'remainingAmount': remainingAmount,
      'addtionalServices':
      additionalServices.map((item) => item.toJson()).toList(),
      'number': number,
      'schadual': schadual,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class AdditionalService {
  int price;
  String name;
  String id;

  AdditionalService({
    required this.price,
    required this.name,
    required this.id,
  });

  factory AdditionalService.fromJson(Map<String, dynamic> json) {
    return AdditionalService(
      price: json['price'],
      name: json['name'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'name': name,
      '_id': id,
    };
  }
}
