import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstant.baseUrl}/auth/signin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return Right(UserModel.fromMap(body));
      }

      return Left(AppFailure(body['detail'] as String));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstant.baseUrl}/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return Right(UserModel.fromMap(body));
      }

      return Left(AppFailure(body['detail'] as String));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}

// class AuthRemoteRepository {
//   final AuthApiClient _authApiClient;

//   AuthRemoteRepository(this._authApiClient);

//   Future<User> login(String email, String password) async {
//     final response = await _authApiClient.login(email, password);
//     return User.fromJson(response);
//   }

//   Future<User> register(String email, String password) async {
//     final response = await _authApiClient.register(email, password);
//     return User.fromJson(response);
//   }
// }
