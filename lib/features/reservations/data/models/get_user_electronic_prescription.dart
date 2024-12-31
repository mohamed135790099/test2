class GetUserElectronicPrescription {
  final String id;
  final List<Roshta> roshta;
  final String patientId;
  final String? createdAt; // Made nullable

  GetUserElectronicPrescription({
    required this.id,
    required this.roshta,
    required this.patientId,
    this.createdAt, // Made optional
  });

  factory GetUserElectronicPrescription.fromJson(Map<String, dynamic> json) {
    return GetUserElectronicPrescription(
      id: json['_id'] ?? '',
      roshta: (json['roshta'] as List)
          .map((roshtaItem) => Roshta.fromJson(roshtaItem))
          .toList(),
      patientId: json['patient'] ?? '',
      createdAt: json['createdAt'],
    );
  }
}

class Roshta {
  final String medicineTitle;
  final int dosage;
  final String? food; // Made nullable
  final String? details; // Made nullable

  Roshta({
    required this.medicineTitle,
    required this.dosage,
    this.food, // Made optional
    this.details, // Made optional
  });

  factory Roshta.fromJson(Map<String, dynamic> json) {
    return Roshta(
      medicineTitle: json['medicin']?['title'] ?? '',
      // Provide a default value if null
      dosage: json['dosage'] ?? 0,
      // Provide a default value if null
      food: json['food'],
      // No default, can remain null
      details: json['details'], // No default, can remain null
    );
  }
}
