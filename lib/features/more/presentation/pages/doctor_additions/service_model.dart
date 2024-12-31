class ServiceModel {
  String? message;
  Service? service;

  ServiceModel({this.message, this.service});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    service =
        json['service'] != null ? new Service.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    return data;
  }
}

class Service {
  String? name;
  int? price;
  String? sId;
  int? iV;

  Service({this.name, this.price, this.sId, this.iV});

  Service.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}
