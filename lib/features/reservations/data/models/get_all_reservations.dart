class User {
  final String? id;
  final String? fullName;
  final String? phone;

  User({this.id, this.fullName, this.phone});

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return User(id: null, fullName: null, phone: null);
    }
    return User(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
    );
  }
}

class GetAllReservations {
  final String id;
  final User user;
  final String date;
  int? numberOfReservation;
  final String time;
  final String status;
  final String reservType;
  final int price;
  final int totalPrice;
  final String paid;
  final String paidType;
  final DateTime createdAt;
  final DateTime updatedAt;

  GetAllReservations({
    required this.id,
    this.numberOfReservation,
    required this.user,
    required this.date,
    required this.time,
    required this.totalPrice,
    required this.status,
    required this.reservType,
    required this.price,
    required this.paid,
    required this.paidType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetAllReservations.fromJson(Map<String, dynamic> json) {
    return GetAllReservations(
      id: json['_id'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>?),
      date: json['date'] as String,
      numberOfReservation: json['number'] ?? 0,
      time: json['time'] as String,
      status: json['status'] as String,
      reservType: json['reserv_type'] as String? ?? '',
      price: json['price'] as int,
      totalPrice: json['totalPrice'] as int,
      paid: json['paid'] as String,
      paidType: json['paidType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
