
class PatientHistory {
  String? code;
  String? name;
  String? phone;
  int? age;
  String? aeradShakWa;
  String? shakWaOnTime;
  String? shakWaPastTime;
  String? period;
  String? contraceptives;

  PatientHistory({
    this.code,
    this.name,
    this.age,
    this.phone,
    this.aeradShakWa,
    this.shakWaOnTime,
    this.shakWaPastTime,
    this.period,
    this.contraceptives,
  });

  factory PatientHistory.fromJson(Map<String, dynamic> json) {
    return PatientHistory(
      code: json['code'] as String?,
      name: json['patientId']['fullName'] as String?,
      phone: json['patientId']['phone'] as String?,
      age: json['age'] as int?,
      aeradShakWa: json['aeradShakWa'] as String?,
      shakWaOnTime: json['shakWaOnTime'] as String?,
      shakWaPastTime: json['shakWaPastTime'] as String?,
      period: json['period'] as String?,
      contraceptives: json['contraceptives'] as String?,
    );
  }

  // Convert PatientHistory object to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'age': age,
      'aeradShakWa': aeradShakWa,
      'shakWaOnTime': shakWaOnTime,
      'shakWaPastTime': shakWaPastTime,
      'period': period,
      'contraceptives': contraceptives,
    };
  }
}
