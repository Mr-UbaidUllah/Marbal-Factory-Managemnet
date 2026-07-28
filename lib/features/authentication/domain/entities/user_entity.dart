import 'package:equatable/equatable.dart';

enum UserRole {
  owner,
  admin,
  staff,
  customer;

  String get name => toString().split('.').last;
  
  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role.toLowerCase(),
      orElse: () => UserRole.customer,
    );
  }
}

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final String? profileImage;
  final String token;
  final String refreshToken;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.profileImage,
    required this.token,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phone,
        role,
        profileImage,
        token,
        refreshToken,
      ];
}
