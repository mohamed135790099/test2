class NewReservationModel {
  String? message;
  int? count;
  List<Reservations>? reservations;

  NewReservationModel({this.message, this.count, this.reservations});

  NewReservationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    count = json['count'];
    if (json['reservations'] != null) {
      reservations = <Reservations>[];
      json['reservations'].forEach((v) {
        reservations!.add(new Reservations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['count'] = this.count;
    if (this.reservations != null) {
      data['reservations'] = this.reservations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reservations {
  String? sId;
  User? user;
  String? date;
  String? time;
  String? status;
  String? reservType;
  int? price;
  String? paid;
  String? paidType;
  String? eventCreater;
  int? number;
  String? schadual;
  String? createdAt;
  String? updatedAt;

  Reservations(
      {this.sId,
        this.user,
        this.date,
        this.time,
        this.status,
        this.reservType,
        this.price,
        this.paid,
        this.paidType,
        this.eventCreater,
        this.number,
        this.schadual,
        this.createdAt,
        this.updatedAt});

  Reservations.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    date = json['date'];
    time = json['time'];
    status = json['status'];
    reservType = json['reserv_type'];
    price = json['price'];
    paid = json['paid'];
    paidType = json['paidType'];
    eventCreater = json['eventCreater'];
    number = json['number'];
    schadual = json['schadual'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['reserv_type'] = this.reservType;
    data['price'] = this.price;
    data['paid'] = this.paid;
    data['paidType'] = this.paidType;
    data['eventCreater'] = this.eventCreater;
    data['number'] = this.number;
    data['schadual'] = this.schadual;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class User {
  String? sId;
  String? fullName;
  String? phoneNumber;

  User({this.sId, this.fullName});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    phoneNumber = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['fullName'] =fullName;
    data['phone'] = phoneNumber;
    return data;
  }
}
