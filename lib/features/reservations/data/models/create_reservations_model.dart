class CreateReservationsResponse {
  String? user;
  String? date;
  String? time;
  List<dynamic>? terms;
  String? status;
  int? price;
  String? paid;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CreateReservationsResponse(
      {this.user,
      this.date,
      this.time,
      this.terms,
      this.status,
      this.price,
      this.paid,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CreateReservationsResponse.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    date = json['date'];
    time = json['time'];
    terms = json['terms'];
    status = json['status'];
    price = json['price'];
    paid = json['paid'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['date'] = date;
    data['time'] = time;
    data['terms'] = terms;
    data['status'] = status;
    data['price'] = price;
    data['paid'] = paid;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
