import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? authToken; // Only present after login

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    this.authToken,
  });

  @override
  List<Object?> get props => [id, username, email, authToken];
}
