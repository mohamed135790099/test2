class OneReservation {
  String? sId;
  User? user;
  String? date;
  String? time;
  int? totalPrice;
  List<dynamic>? terms;
  String? status;
  int? price;
  String? paid;
  String? paidType;
  String? eventCreater;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<AdditionalService>? additionalServices;
  int? discount;
  int? examinationPrice;
  int? amountPaid;
  int? remainingAmount;
  String? reservType;
  int? number;
  String? schadual;

  OneReservation({
    this.sId,
    this.user,
    this.date,
    this.time,
    this.terms,
    this.status,
    this.price,
    this.paid,
    this.totalPrice,
    this.paidType,
    this.eventCreater,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.additionalServices,
    this.discount,
    this.examinationPrice,
    this.amountPaid,
    this.remainingAmount,
    this.reservType,
    this.number,
    this.schadual,
  });

  factory OneReservation.fromJson(Map<String, dynamic> json) {
    var additionalServicesJson = json['addtionalServices'] as List?;
    List<AdditionalService>? additionalServicesList = additionalServicesJson
        ?.map((serviceJson) => AdditionalService.fromJson(serviceJson))
        .toList();

    return OneReservation(
      sId: json['_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      date: json['date'],
      time: json['time'],
      terms: json['terms'],
      status: json['status'],
      totalPrice: json['totalPrice'],
      price: json['price'],
      paid: json['paid'],
      paidType: json['paidType'],
      eventCreater: json['eventCreater'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
      additionalServices: additionalServicesList,
      discount: json['discount'],
      examinationPrice: json['examinationPrice'],
      amountPaid: json['amountPaid'],
      remainingAmount: json['remainingAmount'],
      reservType: json['reserv_type'],
      number: json['number'],
      schadual: json['schadual'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'user': user?.toJson(),
      'date': date,
      'time': time,
      'terms': terms,
      'status': status,
      'price': price,
      'totalPrice': totalPrice,
      'paid': paid,
      'paidType': paidType,
      'eventCreater': eventCreater,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
      'addtionalServices':
      additionalServices?.map((service) => service.toJson()).toList(),
      'discount': discount,
      'examinationPrice': examinationPrice,
      'amountPaid': amountPaid,
      'remainingAmount': remainingAmount,
      'reserv_type': reservType,
      'number': number,
      'schadual': schadual,
    };
  }
}

class AdditionalService {
  String? id;
  String? name;
  int? price;

  AdditionalService({this.id, this.name, this.price});

  factory AdditionalService.fromJson(Map<String, dynamic> json) {
    return AdditionalService(
      id: json['_id'],
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'price': price,
    };
  }
}

class User {
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

  User({
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      sId: json['_id'],
      fullName: json['fullName'],
      phone: json['phone'],
      role: json['role'],
      tahalil: json['tahalil'],
      roshta: json['roshta'],
      asheaa: json['asheaa'],
      medicin: json['medicin'],
      reservs: json['reservs'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
      otp: json['otp'],
      otpExpires: json['otpExpires'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'fullName': fullName,
      'phone': phone,
      'role': role,
      'tahalil': tahalil,
      'roshta': roshta,
      'asheaa': asheaa,
      'medicin': medicin,
      'reservs': reservs,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
      'otp': otp,
      'otpExpires': otpExpires,
    };
  }
}
