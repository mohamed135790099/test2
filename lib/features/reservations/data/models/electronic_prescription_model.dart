class RoshtaItem {
  final String id;
  final Medicin medicin;
  final int dosage;
  final String? food; // Optional field
  final String? details; // Optional field

  RoshtaItem({
    required this.id,
    required this.medicin,
    required this.dosage,
    this.food, // Nullable
    this.details, // Nullable
  });

  factory RoshtaItem.fromJson(Map<String, dynamic> json) {
    return RoshtaItem(
      id: json['_id'] ?? '',
      medicin: Medicin.fromJson(json['medicin']),
      dosage: json['dosage'] ?? 1,
      food: json['food'],
      details: json['details'],
    );
  }
}

class Medicin {
  final String title;

  Medicin({
    required this.title,
  });

  factory Medicin.fromJson(Map<String, dynamic> json) {
    return Medicin(
      title: json['title'] ?? '',
    );
  }
}

class ElectronicPrescription {
  final String id;
  final List<RoshtaItem> roshta;
  final String patientId;
  final String createdAt;
  final String updatedAt;

  ElectronicPrescription({
    required this.id,
    required this.roshta,
    required this.patientId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ElectronicPrescription.fromJson(Map<String, dynamic> json) {
    return ElectronicPrescription(
      id: json['_id'] ?? '',
      roshta: (json['roshta'] as List)
          .map((item) => RoshtaItem.fromJson(item))
          .toList(),
      patientId: json['patient'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
