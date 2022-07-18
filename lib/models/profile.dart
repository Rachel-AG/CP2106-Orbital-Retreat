import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String username;
  final String updatedAt;
  final String? avatarUrl;

  const Profile(this.id, this.username, this.updatedAt, this.avatarUrl);

  @override
  List<Object?> get props => [id, username, updatedAt, avatarUrl];

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(json['id'] as String, json['username'] as String,
        json['updated_at'] as String, json['avatar_url']);
  }

  @override
  String toString() {
    return 'id: $id, username: $username, updated at: $updatedAt, avatar: $avatarUrl';
  }
}
