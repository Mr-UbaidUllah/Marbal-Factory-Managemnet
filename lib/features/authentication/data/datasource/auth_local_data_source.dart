import 'dart:convert';
import 'package:factory_management/core/errors/exceptions.dart';
import 'package:factory_management/features/authentication/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearUser();
  Future<bool> hasToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _userKey = 'cached_user';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await sharedPreferences.setString(_userKey, userJson);
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = sharedPreferences.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(_userKey);
  }

  @override
  Future<bool> hasToken() async {
    final user = await getUser();
    return user?.token != null;
  }
}
