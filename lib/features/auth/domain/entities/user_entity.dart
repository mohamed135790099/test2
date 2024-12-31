import 'dart:io';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? email;
  final String? password;
  final File? imageFile;
  final String? fcmToken;

  const UserEntity({
    this.id,
    this.firstName,
    this.imageFile,
    this.fcmToken,
    this.lastName,
    this.name,
    this.email,
    this.password,
    this.image,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        imageFile,
        image,
        email,
        password,
        fcmToken,
        firstName,
        lastName,
      ];
}
