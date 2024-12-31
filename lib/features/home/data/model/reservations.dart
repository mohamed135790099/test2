// class ReservationModel {
//   String? sId;
//   String? user;
//   String? date;
//   String? time;
//   String? status;
//   String? reservType;
//   int? price;
//   int? totalPrice;
//   String? paid;
//   String? paidType;
//   String? eventCreater;
//   int? discount;
//   int? examinationPrice;
//   int? amountPaid;
//   int? remainingAmount;
//   List<AddtionalServices>? addtionalServices;
//   int? number;
//   String? schadual;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;
//
//   ReservationModel(
//       {this.sId,
//         this.user,
//         this.date,
//         this.time,
//         this.status,
//         this.reservType,
//         this.price,
//         this.totalPrice,
//         this.paid,
//         this.paidType,
//         this.eventCreater,
//         this.discount,
//         this.examinationPrice,
//         this.amountPaid,
//         this.remainingAmount,
//         this.addtionalServices,
//         this.number,
//         this.schadual,
//         this.createdAt,
//         this.updatedAt,
//         this.iV});
//
//   ReservationModel.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     user = json['user'];
//     date = json['date'];
//     time = json['time'];
//     status = json['status'];
//     reservType = json['reserv_type'];
//     price = json['price'];
//     totalPrice = json['totalPrice'];
//     paid = json['paid'];
//     paidType = json['paidType'];
//     eventCreater = json['eventCreater'];
//     discount = json['discount'];
//     examinationPrice = json['examinationPrice'];
//     amountPaid = json['amountPaid'];
//     remainingAmount = json['remainingAmount'];
//     if (json['addtionalServices'] != null) {
//       addtionalServices = <AddtionalServices>[];
//       json['addtionalServices'].forEach((v) {
//         addtionalServices!.add(new AddtionalServices.fromJson(v));
//       });
//     }
//     number = json['number'];
//     schadual = json['schadual'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['user'] = this.user;
//     data['date'] = this.date;
//     data['time'] = this.time;
//     data['status'] = this.status;
//     data['reserv_type'] = this.reservType;
//     data['price'] = this.price;
//     data['totalPrice'] = this.totalPrice;
//     data['paid'] = this.paid;
//     data['paidType'] = this.paidType;
//     data['eventCreater'] = this.eventCreater;
//     data['discount'] = this.discount;
//     data['examinationPrice'] = this.examinationPrice;
//     data['amountPaid'] = this.amountPaid;
//     data['remainingAmount'] = this.remainingAmount;
//     if (this.addtionalServices != null) {
//       data['addtionalServices'] =
//           this.addtionalServices!.map((v) => v.toJson()).toList();
//     }
//     data['number'] = this.number;
//     data['schadual'] = this.schadual;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
//
// class AddtionalServices {
//   int? price;
//   String? name;
//
//   AddtionalServices({this.price, this.name});
//
//   AddtionalServices.fromJson(Map<String, dynamic> json) {
//     price = json['price'];
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['price'] = this.price;
//     data['name'] = this.name;
//     return data;
//   }
// }