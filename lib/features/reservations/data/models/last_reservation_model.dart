class LastReservationModel {
  String? message;
  List<Reservation>? reservations;

  LastReservationModel({this.message, this.reservations});

  LastReservationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['reservations'] != null) {
      reservations = <Reservation>[];
      json['reservations'].forEach((v) {
        reservations!.add(Reservation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (reservations != null) {
      data['reservations'] = reservations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reservation {
  String? id;
  String? user;
  String? date;
  String? time;
  String? status;
  String? reservType;
  int? price;
  String? paid;
  String? paidType;
  String? eventCreator;
  int? number;
  String? schadual;
  String? createdAt;
  String? updatedAt;

  Reservation({
    this.id,
    this.user,
    this.date,
    this.time,
    this.status,
    this.reservType,
    this.price,
    this.paid,
    this.paidType,
    this.eventCreator,
    this.number,
    this.schadual,
    this.createdAt,
    this.updatedAt,
  });

  Reservation.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    user = json['user'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    reservType = json['reserv_type'];
    price = json['price'] is int ? json['price'] : int.tryParse(json['price'].toString());
    paid = json['paid'];
    paidType = json['paidType'];
    eventCreator = json['eventCreater'];
    number = json['number'] is int ? json['number'] : int.tryParse(json['number'].toString());
    schadual = json['schadual'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['user'] = user;
    data['date'] = date;
    data['time'] = time;
    data['status'] = status;
    data['reserv_type'] = reservType;
    data['price'] = price;
    data['paid'] = paid;
    data['paidType'] = paidType;
    data['eventCreater'] = eventCreator;
    data['number'] = number;
    data['schadual'] = schadual;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
