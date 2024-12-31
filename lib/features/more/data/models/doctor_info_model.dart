class DoctorInfoModel {
  final String id;
  final String name;
  final String dateOfBirth;
  final String country;
  final String title;
  final String study;
  final String branches;
  final List<String> images;
  final String? facebookLink;
  final String? instagramLink;
  final String? twitterLink;
  final String? youtubeLink;
  final String doctorId;
  final String createdAt;
  final String updatedAt;
  final int v;

  DoctorInfoModel({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.country,
    required this.title,
    required this.study,
    required this.branches,
    required this.images,
    this.facebookLink,
    this.instagramLink,
    this.youtubeLink,
    this.twitterLink,
    required this.doctorId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory DoctorInfoModel.fromJson(Map<String, dynamic> json) {
    return DoctorInfoModel(
      id: json['_id'],
      name: json['name'],
      dateOfBirth: json['dateOfBirth'],
      country: json['country'],
      title: json['title'],
      study: json['study'],
      branches: json['branches'],
      images: List<String>.from(json['images']),
      facebookLink: json['facebook'],
      instagramLink: json['instagram'],
      twitterLink: json['twitter'],
      youtubeLink: json['youtube'],
      doctorId: json['doctorId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}
