import 'package:factory_management/core/errors/exceptions.dart';
import 'package:factory_management/features/authentication/data/models/user_model.dart';
import 'package:factory_management/features/authentication/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'owner@factory.com' && password == 'password123') {
      return const UserModel(
        id: '1',
        fullName: 'Owner User',
        email: 'owner@factory.com',
        phone: '1234567890',
        role: UserRole.owner,
        token: 'mock_token_owner',
        refreshToken: 'mock_refresh_token_owner',
      );
    } else if (email == 'admin@factory.com' && password == 'password123') {
      return const UserModel(
        id: '2',
        fullName: 'Admin User',
        email: 'admin@factory.com',
        phone: '0987654321',
        role: UserRole.admin,
        token: 'mock_token_admin',
        refreshToken: 'mock_refresh_token_admin',
      );
    } else if (email == 'staff@factory.com' && password == 'password123') {
      return const UserModel(
        id: '3',
        fullName: 'Staff User',
        email: 'staff@factory.com',
        phone: '1122334455',
        role: UserRole.staff,
        token: 'mock_token_staff',
        refreshToken: 'mock_refresh_token_staff',
      );
    } else if (email == 'customer@gmail.com' && password == 'password123') {
      return const UserModel(
        id: '4',
        fullName: 'Customer User',
        email: 'customer@gmail.com',
        phone: '5544332211',
        role: UserRole.customer,
        token: 'mock_token_customer',
        refreshToken: 'mock_refresh_token_customer',
      );
    } else {
      throw ServerException('Invalid credentials');
    }
  }
}
