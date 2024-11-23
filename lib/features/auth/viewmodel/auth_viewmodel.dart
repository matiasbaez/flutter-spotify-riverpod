import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  final AuthRemoteRepository _authRemoteRepository = AuthRemoteRepository();

  @override
  AsyncValue<UserModel>? build() {
    return null;
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final response = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );

    final data = switch (response) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
  }

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    final response = await _authRemoteRepository.signin(
      email: email,
      password: password,
    );

    final data = switch (response) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
  }
}
