class GetUserReservations {
  String? sId;
  String? user;
  String? date;
  String? time;
  List<dynamic>? terms;
  String? status;
  int? price;
  String? paid;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GetUserReservations(
      {this.sId,
      this.user,
      this.date,
      this.time,
      this.terms,
      this.status,
      this.price,
      this.paid,
      this.createdAt,
      this.updatedAt,
      this.iV});

  GetUserReservations.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    date = json['date'];
    time = json['time'];
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
