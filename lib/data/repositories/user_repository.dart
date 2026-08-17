import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/user_data.dart';

part 'generated/user_repository.g.dart';

class UserRepository {
  UserData _userData = const UserData();

  UserData get userData => _userData;

  void updateUserData(UserData userData) {
    _userData = userData;
  }

  UserData getUserData() {
    return _userData;
  }
}

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepository();
}
